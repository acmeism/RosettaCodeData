clear all; close all; clc;

% Print the sequence for numbers from 0 to 20
for x = 0:20
    zeckString = arrayfun(@num2str, zeck(x), 'UniformOutput', false);
    zeckString = strjoin(zeckString, '');
    fprintf("%d : %s\n", x, zeckString);
end

function dig = zeck(n)
    if n <= 0
        dig = 0;
        return;
    end

    fib = [1, 2];
    while fib(end) < n
        fib(end + 1) = sum(fib(end-1:end));
    end
    fib = fliplr(fib); % Reverse the order of Fibonacci numbers

    dig = [];
    for i = 1:length(fib)
        if fib(i) <= n
            dig(end + 1) = 1;
            n = n - fib(i);
        else
            dig(end + 1) = 0;
        end
    end

    if dig(1) == 0
        dig = dig(2:end);
    end
end
