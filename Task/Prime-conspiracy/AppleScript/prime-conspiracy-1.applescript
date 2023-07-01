on isPrime(n)
    if ((n < 4) or (n is 5)) then return (n > 1)
    if ((n mod 2 = 0) or (n mod 3 = 0) or (n mod 5 = 0)) then return false
    repeat with i from 7 to (n ^ 0.5) div 1 by 30
        if ((n mod i = 0) or (n mod (i + 4) = 0) or (n mod (i + 6) = 0) or ¬
            (n mod (i + 10) = 0) or (n mod (i + 12) = 0) or (n mod (i + 16) = 0) or ¬
            (n mod (i + 22) = 0) or (n mod (i + 24) = 0)) then return false
    end repeat

    return true
end isPrime

on conspiracy(limit)
    script o
        property counters : {{0, 0, 0, 0, 0, 0, 0, 0, 0}}
    end script
    repeat 8 times
        copy beginning of o's counters to end of o's counters
    end repeat

    if (limit > 1) then
        set primeCount to 1
        set i to 2 -- First prime.
        set n to 3 -- First number to test for primality.
        repeat until (primeCount = limit)
            if (isPrime(n)) then
                set primeCount to primeCount + 1
                set j to n mod 10
                set item j of item i of o's counters to (item j of item i of o's counters) + 1
                set i to j
            end if
            set n to n + 2
        end repeat
    end if

    set output to {"First " & limit & " primes: transitions between end digits of consecutive primes."}
    set totalTransitions to limit - 1
    repeat with i in {1, 2, 3, 5, 7, 9}
        set iTransitions to 0
        repeat with j from 1 to 9 by 2
            set iTransitions to iTransitions + (item j of item i of o's counters)
        end repeat
        repeat with j from 1 to 9 by 2
            set ijCount to item j of item i of o's counters
            if (ijCount > 0) then ¬
                set end of output to ¬
                    (i as text) & " → " & j & ¬
                    ("     count: " & ijCount) & ¬
                    ("     preference for " & j & ": " & (ijCount * 10000 / iTransitions as integer) / 100) & ¬
                    ("%     overall occurrence: " & (ijCount * 10000 / totalTransitions as integer) / 100 & "%")
        end repeat
    end repeat
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to linefeed
    set output to output as text
    set AppleScript's text item delimiters to astid
    return output
end conspiracy

conspiracy(1000000)
