function fm2 = FM2(pg, Fm2)
%% Fuzzy logic setting for power demoand, see Figure 1b
Fm2 = Fm2 - 1;
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