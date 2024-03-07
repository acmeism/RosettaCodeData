benfords_law();

function benfords_law
    % Benford's Law
    P = @(d) log10(1 + 1./d);

    % Benford function
    function counts = benford(numbers)
        firstdigit = @(n) floor(mod(n / 10^floor(log10(n)), 10));
        counts = zeros(1, 9);
        for i = 1:length(numbers)
            digit = firstdigit(numbers(i));
            if digit ~= 0
                counts(digit) = counts(digit) + 1;
            end
        end
        counts = counts ./ sum(counts);
    end

    % Generate Fibonacci numbers
    function fibNums = fibonacci(n)
        fibNums = zeros(1, n);
        a = 0;
        b = 1;
        for i = 1:n
            c = b;
            b = a + b;
            a = c;
            fibNums(i) = b;
        end
    end

    % Sample
    sample = fibonacci(1000);

    % Observed and expected frequencies
    observed = benford(sample) * 100;
    expected = arrayfun(P, 1:9) * 100;

    % Table
    mytable = [1:9; observed; expected]';

    % Plotting
    bar(1:9, observed);
    hold on;
    plot(1:9, expected, 'LineWidth', 2);
    hold off;
    title("Benford's Law");
    xlabel("First Digit");
    ylabel("Frequency %");
    legend("1000 Fibonacci Numbers", "P(d) = log10(1 + 1/d)");
    xticks(1:9);

    % Displaying the results
    fprintf("Benford's Law\nFrequency of first digit\nin 1000 Fibonacci numbers\n");
    disp(table(mytable(:,1),mytable(:,2),mytable(:,3),'VariableNames',{'digit', 'observed(%)', 'expected(%)'}))
end
