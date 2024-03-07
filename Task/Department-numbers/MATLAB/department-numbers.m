% Execute the functions
clear all;close all;clc;
sol = findsolution();
disp(table(sol(:, 1), sol(:, 2), sol(:, 3), 'VariableNames',{'Pol.','Fire','San.'}))

function sol = findsolution()
    rng = 1:7;
    sol = [];
    for p = rng
        for f = rng
            for s = rng
                if p ~= s && s ~= f && f ~= p && p + s + f == 12 && mod(p, 2) == 0
                    sol = [sol; p s f];
                end
            end
        end
    end
end
