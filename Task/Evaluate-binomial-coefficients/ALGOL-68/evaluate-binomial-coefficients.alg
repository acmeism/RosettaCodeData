PROC factorial = (INT n)INT:
(
        INT result;

        result := 1;
        FOR i  TO n DO
                result *:= i
        OD;

        result
);

PROC choose = (INT n, INT k)INT:
(
        INT result;

# Note: code can be optimised here as k < n #
        result := factorial(n) OVER (factorial(k) * factorial(n - k));

        result
);

test:(
        print((choose(5, 3), new line))
)
