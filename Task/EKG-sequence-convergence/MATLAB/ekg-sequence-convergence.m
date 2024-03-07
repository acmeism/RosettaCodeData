% Displaying EKG sequences and the convergence point
for i = [2, 5, 7, 9, 10]
    ekg = ekgsequence(i, 30);
    fprintf('EKG(%d): %s\n', i, num2str(ekg));
end

convergencePoint = convergeat(5, 7);
fprintf('EKGs of 5 & 7 converge at term %d\n', convergencePoint);



function ekg = ekgsequence(n, limit)
    ekg = [1, n];
    while length(ekg) < limit
        for i = 2:2^18
            if all(ekg ~= i) && gcd(ekg(end), i) > 1
                ekg = [ekg, i];
                break;
            end
        end
    end
end

function point = convergeat(n, m, max)
    if nargin < 3
        max = 100;
    end

    ekgn = ekgsequence(n, max);
    ekgm = ekgsequence(m, max);

    point = 0;
    for i = 3:max
        if ekgn(i) == ekgm(i) && sum(ekgn(1:i+1)) == sum(ekgm(1:i+1))
            point = i;
            return;
        end
    end

    if point == 0
        warning('No convergence in %d terms', max);
    end
end
