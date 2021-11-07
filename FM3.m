function fm3 = FM3(pg, Fm3)
%% Fuzzy logic setting for storage, see Figure 1c
Fm3 = Fm3 - 1;
% k = [-10 -3.33 3.33 10];
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