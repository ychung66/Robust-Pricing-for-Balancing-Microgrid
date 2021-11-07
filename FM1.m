function fm1 = FM1(pg, Fm1)
%% Fuzzy logic setting for power supply, see Figure 1a
Fm1 = Fm1 - 1;
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