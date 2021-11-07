%% Description
% This is main program for microgrid simulation

%% load workspace from main.m
clear
clc
load('work_data.mat')

%% Set up simulation parameter
uncertainty = 0;    % 0: run simulation without unceratinty, 1: run simulation with uncertainty
step_price = 1e-2;  % step size for power market price
step = 1e-2;        % step size for microgrid 
N = 10000;          % number of time step
% bound = [-1.5 1.5; -1.5 1.5; 0 2];  % bound for uncertainty, see Eq(30)
bound = [-0.5 0.5; -0.4 0.6; 0 2];  % bound for uncertainty, see Eq(30)
w = [(bound(1, 2)-bound(1,1))*rand(N, 1)+bound(2,1) ...
     (bound(2, 2)-bound(2,1))*rand(N, 1)+bound(2,1) ...
     (bound(3, 2)-bound(3,1))*rand(N, 1)+bound(3,1)];
 
% Start simulation of microgrid
for ITER = 1:2 % ITER: 1 --> Area Control Error (ACE) Pricing, 2 --> Robust Pricing
    x = x0;
    l = l0;
    x_record = [];
    for i = 1: N
        if uncertainty == 0
            dx = mdynmaic(A,x,b,tau,l,B,[0;0;0]);
        elseif uncertainty == 1
            dx = mdynmaic(A,x,b,tau,l,B,w(i, :)');
        end
        if ITER == 1
            % ACE pricing
            l = l -step_price*x(3)/tl;
        elseif ITER == 2
            % Robust pricing
            l = Pricing(x, Km);
        end
        x_record = [x_record [x; l]];
        x = x + step*dx;
    end
    if ITER == 1
        save('ACE_result.mat', 'x_record', 'N');
    elseif ITER == 2
        save('ROP_result.mat', 'x_record', 'N');
    end
end

%% Plot simulation result
subplot(1, 2, 2)
load('ROP_result.mat')
t = 1:N;
pg = x_record(1, :);
pd = x_record(2, :);
e = x_record(3, :);
lambda = x_record(4, :);
hold on
h1 = plot(t, pg, 'r');
h2 = plot(t, pd, 'b');
h3 = plot(t, e, 'g');
h4 = plot(t, lambda, 'k');
h5 = legend('Pg', 'Pd', 'e(storage)', '\lambda');
h6 = title('Robust Pricing with no uncertainty');
ylim([-20 20])
xlabel('Time')
set([h1 h2 h3 h4], 'LineWidth', 2)
set([h5 h6], 'FontSize', 16)
set(gcf, 'color', 'w')
subplot(1, 2, 1)
hold on
load('ACE_result.mat')
pg = x_record(1, :);
pd = x_record(2, :);
e = x_record(3, :);
lambda = x_record(4, :);
hold on
h1 = plot(t, pg, 'r');
h2 = plot(t, pd, 'b');
h3 = plot(t, e, 'g');
h4 = plot(t, lambda, 'k');
h5 = legend('Pg', 'Pd', 'e(storage)', '\lambda');
h6 = title('ACE Pricing with no uncertainty');
ylim([-20 20])
xlabel('Time')
set([h1 h2 h3 h4], 'LineWidth', 2)
set([h5 h6], 'FontSize', 16)
set(gcf, 'color', 'w')
set(gcf,'position',[10,10,1500,500])
hold off
