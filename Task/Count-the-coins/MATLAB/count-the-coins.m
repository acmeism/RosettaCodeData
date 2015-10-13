%% Count_The_Coins
clear;close all;clc;
tic

for i = 1:2 % 1st loop is main challenge 2nd loop is optional challenge
    if (i == 1)
        amount = 100;                       % Matlab indexes from 1 not 0, so we need to add 1 to our target value
        amount = amount + 1;
        coins = [1 5 10 25];                % Value of coins we can use
    else
        amount = 100*1000;                  % Matlab indexes from 1 not 0, so we need to add 1 to our target value
        amount = amount + 1;
        coins = [1 5 10 25 50 100];         % Value of coins we can use
    end % End if
    ways = zeros(1,amount);                 % Preallocating for speed
    ways(1) = 1;                            % First solution is 1

    % Solves from smallest sub problem to largest (bottom up approach of dynamic programming).
    for j = 1:length(coins)
        for K = coins(j)+1:amount
            ways(K) = ways(K) + ways(K-coins(j));
        end % End for
    end % End for
        if (i == 1)
            fprintf(‘Main Challenge: %d \n', ways(amount));
        else
            fprintf(‘Bonus Challenge: %d \n', ways(amount));
        end % End if
end % End for
toc
