clear all;close all;clc;
testMakePi();


function [a, g] = agm1step(x, y)
    a = (x + y) / 2;
    g = sqrt(x * y);
end

function [a, g, s, k] = approxPiStep(x, y, z, n)
    [a, g] = agm1step(x, y);
    k = n + 1;
    s = z + 2^(k + 1) * (a^2 - g^2);
end

function pi_approx = approxPi(a, g, s)
    pi_approx = 4 * a^2 / (1 - s);
end

function testMakePi()
    digits(512); % Set the precision for variable-precision arithmetic
    a = vpa(1.0);
    g = 1 / sqrt(vpa(2.0));
    s = vpa(0.0);
    k = 0;
    oldPi = vpa(0.0);
    % Define a small value as a threshold for convergence
    convergence_threshold = vpa(10)^(-digits);

    fprintf('   k     Error         Result\n');
    for i = 1:100
        [a, g, s, k] = approxPiStep(a, g, s, k);
        estPi = approxPi(a, g, s);
        if abs(estPi - oldPi) < convergence_threshold
            break;
        end
        oldPi = estPi;
        err = abs(vpa(pi) - estPi);
        fprintf('%4d%10.1e', i, double(err));
        fprintf('%70.60f\n', double(estPi));
    end
end
