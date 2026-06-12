on oneTwoPrimes(n)
    -- Take the first single-digit prime (the only even one) as read.
    set output to {"First " & n & " results:", " 1: 2"}
    repeat with n from 2 to n
        -- Generate odd one-two numbers by adding 1 to each of the n binary digits
        -- of each even number < 2 ^ n, treating the results as decimal digits.
        set none to true
        repeat with even from 0 to (2 ^ n - 2) by 2
            set p10 to 1
            set oneTwo to p10 -- even's bit 0 + 1.
            repeat (n - 1) times
                set even to even div 2
                set p10 to p10 * 10
                set oneTwo to oneTwo + (even mod 2 + 1) * p10
            end repeat
            -- Finish for this n if a one-two number proves to be a prime.
            if (isPrime(oneTwo)) then
                set end of output to text -2 thru -1 of (space & n) & ": " & intToText(oneTwo, "")
                set none to false
                exit repeat
            end if
        end repeat
        if (none) then set end of output to text -2 thru -1 of (space & n) & ": No prime identified"
    end repeat

    return join(output, linefeed)
end oneTwoPrimes

on isPrime(n)
    if (n < 4) then return (n > 1)
    if ((n mod 2 is 0) or (n mod 3 is 0)) then return false
    repeat with i from 5 to (n ^ 0.5) div 1 by 6
        if ((n mod i is 0) or (n mod (i + 2) is 0)) then return false
    end repeat
    return true
end isPrime

on intToText(int, separator)
    set groups to {}
    repeat while (int > 999)
        set groups's beginning to ((1000 + (int mod 1000 as integer)) as text)'s text 2 thru 4
        set int to int div 1000
    end repeat
    set groups's beginning to int as integer
    return join(groups, separator)
end intToText

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

return oneTwoPrimes(20)
