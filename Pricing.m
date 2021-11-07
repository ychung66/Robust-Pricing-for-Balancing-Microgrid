function y = Pricing(x, Km)
%% Implementation of robust pricing
% input: x: system state (3X1) array
%        Km: gain matrices Km (3X3X64) arrat
% output: y: power market price

hm = zeros(64, 1);
for j = 1: 4
    for n = 1: 4
        for m = 1: 4
            fm1 = 0;
            fm2 = 0;
            fm3 = 0;
            %%   FM1: Fuzzy logic 1
            pg = x(1);
            Fm1 = j - 1;
            k = [5 11.67 18.33 25];
            if Fm1 == 0
                if pg < k(1)
                    fm1 = 1;
                else
                    fm1 = max([1/(k(2)-k(1))*(k(2)-pg) 0]);
                end
            elseif Fm1 == 1
                fm1 = max([min([1/(k(2)-k(1))*(pg-k(1)), 1/(k(3)-k(2))*(k(3)-pg)]) 0]);
            elseif Fm1 == 2
                fm1 = max([min([1/(k(3)-k(2))*(pg-k(2)), 1/(k(4)-k(3))*(k(4)-pg)]) 0]);
            elseif Fm1 == 3
                if pg > k(4)
                    fm1 = 1;
                else
                    fm1 = max([1/(k(4)-k(3))*(pg-k(3)) 0]);
                end
            end
            %% FM2: Fuzzy logic 2
            pg = x(2);
            Fm2 = n - 1;
            k = [5 11.67 18.33 25];
            if Fm2 == 0
                if pg < k(1)
                    fm2 = 1;
                else
                    fm2 = max([1/(k(2)-k(1))*(k(2)-pg) 0]);
                end
            elseif Fm2 == 1
                fm2 = max([min([1/(k(2)-k(1))*(pg-k(1)), 1/(k(3)-k(2))*(k(3)-pg)]) 0]);
            elseif Fm2 == 2
                fm2 = max([min([1/(k(3)-k(2))*(pg-k(2)), 1/(k(4)-k(3))*(k(4)-pg)]) 0]);
            elseif Fm2 == 3
                if pg > k(4)
                    fm2 = 1;
                else
                    fm2 = max([1/(k(4)-k(3))*(pg-k(3)) 0]);
                end
            end
            %% FM3: Fuzzy logic 3
            pg = x(3);
            Fm3 = m - 1;
%             k = [-10 -3.33 3.33 10];
            k = [-20 -10 0 10];
            if Fm3 == 0
                if pg < k(1)
                    fm3 = 1;
                else
                    fm3 = max([1/(k(2)-k(1))*(k(2)-pg) 0]);
                end
            elseif Fm3 == 1
                fm3 = max([min([1/(k(2)-k(1))*(pg-k(1)), 1/(k(3)-k(2))*(k(3)-pg)]) 0]);
            elseif Fm3 == 2
                fm3 = max([min([1/(k(3)-k(2))*(pg-k(2)), 1/(k(4)-k(3))*(k(4)-pg)]) 0]);
            elseif Fm3 == 3
                if pg > k(4)
                    fm3 = 1;
                else
                    fm3 = max([1/(k(4)-k(3))*(pg-k(3)) 0]);
                end
            end
            hm((j-1)*16+(n-1)*4 + m) = fm1*fm2*fm3;
        end
    end
end
%% calculate market price Eq(14)
y = 0;
for i = 1: 64
    y = y + hm(i) * Km(:, :, i) * x;
end
