% This program implement the following paper
% Energy IMbalance Management Using a Robust Pricing Scheme, IEEE Transaction on smart grid v4 2013
% Wei-Yu Chiu, Hongjian Sun, H. Vincent Poor

%% Power market parameter setting, see Table 1
clear
clc
cg = 0.5;
bg = 2;
cd = -0.5;
bd = 10;
k = 0.1;
tg = 0.3; % time constant for generation dynamic
td = 0.2; % time constant for demand dynamic
tl = 100; % time constant for price dynamic

%% Initial condition, see Table 1
l0 = 4.66;
pg0 = 10.4;
pd0 = 13;
e0 = 0;
x0 = [pg0; pd0; e0];

%% Construct power market model
% power market model is a linear system model, see Eq(7) and Eq(20) for more detail
A = [-cg/tg 0 -k/tg;
    0 cd/td 0;
    1 -1 0];
B = [-1/tg 0 0;
    0  1/td 0;
    0   0   1];
C = [0 0 1;
    0 0 0];
D = [0; 0.2];
b = [-bg/tg; bd/td; 0];
tau = [1/tg; -1/td; 0];
w0 = [0; 0; 0];

%% Randomly generate uncertainty samples
% In this project, we consider three type of uncertainty -- power supply. power demand and renewable power injection
% L samples is generated to calculate the fuzzy rule matricex Am in Eq(10)
L = 1500; % number of generated samples
xl = zeros(L, 3);
rng = [5 25;
    5 25;
    -20 10];
for i = 1: 3
    xl(:, i) = (rng(i, 2) - rng(i, 1)).*rand(L, 1) + rng(i, 1);
end
yl = (A*xl' + b)'; % Eq(9)

%% Set up fuzzy logic equation, compute Fm1, Fm2 nad Fm3
hm = zeros(64, L);
for i = 1: L
    for j = 1: 4
        for k = 1: 4
            for m = 1: 4
                hm((j-1)*16+(k-1)*4 + m, i) = FM1(xl(i, 1), j) * FM2(xl(i, 2), k) * FM3(xl(i, 3), m);
            end
        end
    end
end
%% Set up y = XB for least square fitting, see more detail in Numerical Example section in the paper
% By substituting xl and yl into Eq(11), we have 3L equations with Am, m=1,2,...,M as variable to be determined
% The matrices Am can be estimated by using least-square methods
X = zeros(L*3, 576);
for i = 1: L
    for j = 1: 3
        for m = 1: 64
            X((i-1)*3+j, (m-1)*9+(j-1)*3+1: (m-1)*9+(j-1)*3+3) = xl(i, :)' * hm(m, i);
        end
    end
end
y = yl(:);
beta = X\y;
Am = zeros(3, 3, 64);
for i = 1: 64
    Am(:, :, i) = [beta((i-1)*9+1: (i-1)*9+3)';
        beta((i-1)*9+4: (i-1)*9+6)';
        beta((i-1)*9+7: (i-1)*9+9)'];
end

%% Solve Linear Matrix Inequality to get Km. Eq(25)-Eq(29)
Ym = zeros(1, 3, 64);
Km = zeros(1, 3, 64);
gamma_list = zeros([1, 64]);
t_list = zeros([1. 64]);
for i = 1: 64
    gamma = 2;
    find = [0 0];
    options = zeros(1,5);      % default parameter to LMI solver
    options(2) = 200;
    options(3) = 500;
    options(5) = 1;
    setlmis([])
    [Q, xa, xb]= lmivar(2, [3 3]);
    [ym, ya, yb] = lmivar(2,[1 3]);
    lmiterm([1 1 1 Q], Am(:, :, i), 1, 's');
    lmiterm([1 1 1 ym], tau, 1, 's');
    lmiterm([1 1 2 0], B);
    lmiterm([1 1 3 Q], 1, C');
    lmiterm([1 1 3 -ym], 1, D');
    lmiterm([1 2 2 0], -gamma*eye(3));
    lmiterm([1 2 3 0], zeros(3, 2));
    lmiterm([1 3 3 0], -eye(2));
    lmiterm([-2 1 1 Q], 1, 1);
    lmis = getlmis;
    [tmin,xfeas] = feasp(lmis, options);
    Q = [xfeas([1 2 3])'; xfeas([4 5 6])'; xfeas([7 8 9])'];
    Ym(:, :, i) = xfeas([10:12])';
    Km(:, :, i) = Ym(:, :, i)/Q;
    gamma_list(i) = gamma;
    t_list(i) = tmin;
end

%% Compute approximation error
dxl = yl';
for i = 1: L
    for j = 1: 64
        dxl(:, i) = dxl(:, i) - hm(j, i) * Am(:, :, j) * xl(i, :)';
    end
end
error = zeros(1, L);
for i = 1: L
    error(i) = (dxl(:, i)'*dxl(:, i))/(xl(i, :)*xl(i, :)');
end

%% save workspace data for simulation
save('work_data.mat', 'Km','x0','l0','A','B','b','tau','tl');