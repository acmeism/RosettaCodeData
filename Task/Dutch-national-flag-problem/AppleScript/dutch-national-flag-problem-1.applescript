use AppleScript version "2.3.1" -- OS X 10.9 (Mavericks) or later.
use sorter : script ¬
    "Custom Iterative Ternary Merge Sort" --<www.macscripter.net/t/timsort-and-nigsort/71383/3>

on DutchNationalFlagProblem(numberOfBalls)
    script o
        property colours : {"red", "white", "blue"}
        property balls : {}

        -- Custom comparison handler for the sort.
        on isGreater(a, b)
            return ((a ≠ b) and ((a is "blue") or (b is "red")))
        end isGreater
    end script

    repeat numberOfBalls times
        set end of o's balls to some item of o's colours
    end repeat
    tell sorter to sort(o's balls, 1, numberOfBalls, {comparer:o})

    return o's balls
end DutchNationalFlagProblem

DutchNationalFlagProblem(100)
