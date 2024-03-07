clear all;close all;clc;
BabbageProblem();

function BabbageProblem
    % Initialize x to 524, as the square root of 269696 is approximately 519.something
    x = 524;

    % Loop until the square of x modulo 1000000 equals 269696
    while mod(x^2, 1000000) ~= 269696
        % If the last digit of x is 4, increment x by 2
        % Otherwise, increment x by 8
        if mod(x, 10) == 4
            x = x + 2;
        else
            x = x + 8;
        end
    end

    % Display the result
    fprintf('The smallest positive integer whose square ends in 269696 = %d\n', x);
end
