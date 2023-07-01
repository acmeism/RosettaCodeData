on sieveOfEratosthenes(limit)
    script o
        property numberList : {missing value}
    end script

    repeat with n from 2 to limit
        set end of o's numberList to n
    end repeat
    repeat with n from 2 to (limit ^ 0.5 div 1)
        if (item n of o's numberList is n) then
            repeat with multiple from (n * n) to limit by n
                set item multiple of o's numberList to missing value
            end repeat
        end if
    end repeat

    return o's numberList's numbers
end sieveOfEratosthenes

on factors(n)
    set output to {}

    if (n < 0) then set n to -n
    set sqrt to n ^ 0.5
    set limit to sqrt div 1
    if (limit = sqrt) then
        set end of output to limit
        set limit to limit - 1
    end if
    repeat with i from limit to 1 by -1
        if (n mod i is 0) then
            set beginning of output to i
            set end of output to n div i
        end if
    end repeat

    return output
end factors

on isLongPrime(n)
    if (n < 3) then return false
    script o
        property f : factors(n - 1)
    end script

    set counter to 0
    repeat with fi in o's f
        set fi to fi's contents
        set e to 1
        set base to 10
        repeat until (fi = 0)
            if (fi mod 2 = 1) then set e to e * base mod n
            set base to base * base mod n
            set fi to fi div 2
        end repeat
        if (e = 1) then
            set counter to counter + 1
            if (counter > 1) then exit repeat
        end if
    end repeat

    return (counter = 1)
end isLongPrime

-- Task code:
on longPrimesTask()
    script o
        -- The isLongPrime() handler above returns the correct result for any number
        -- passed to it, but feeeding it only primes in the first place speeds things up.
        property primes : sieveOfEratosthenes(64000)
        property longs : {}
    end script

    set output to {}
    set counter to 0
    set mileposts to {500, 1000, 2000, 4000, 8000, 16000, 32000, 64000}
    set m to 1
    set nextMilepost to beginning of mileposts
    set astid to AppleScript's text item delimiters
    repeat with p in o's primes
        set p to p's contents
        if (isLongPrime(p)) then
            -- p being odd, it's never exactly one of the even mileposts.
            if (p < 500) then
                set end of o's longs to p
            else if (p > nextMilepost) then
                if (nextMilepost = 500) then
                    set AppleScript's text item delimiters to space
                    set end of output to "Long primes up to 500:"
                    set end of output to o's longs as text
                end if
                set end of output to "Number of long primes up to " & nextMilepost & ":  " & counter
                set m to m + 1
                set nextMilepost to item m of mileposts
            end if
            set counter to counter + 1
        end if
    end repeat
    set end of output to "Number of long primes up to " & nextMilepost & ":  " & counter
    set AppleScript's text item delimiters to linefeed
    set output to output as text
    set AppleScript's text item delimiters to astid

    return output
end longPrimesTask

longPrimesTask()
