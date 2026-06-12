-- Find the longest run of "CalmoSoft primes" ≤ limit.
on CalmoSoftPrimes(limit)
    script o
        property primes : sieveOfSundaram(2, limit)
    end script

    set maxSum to 0
    repeat with p in o's primes
        set maxSum to maxSum + p
    end repeat
    if (isPrime(maxSum)) then return {sum:maxSum, |run|:o's primes}

    set {j, topRunLen} to {count o's primes, 0}
    repeat while (j > topRunLen)
        set testSum to maxSum
        repeat with i from 1 to (j - topRunLen)
            set testSum to testSum - (o's primes's item i)
            if (isPrime(testSum)) then exit repeat
        end repeat
        set runLen to j - i
        if (runLen > topRunLen) then
            set topRunLen to runLen
            set topRunStart to i + 1
            set topRunEnd to j
            set topRunSum to testSum
        end if
        set maxSum to maxSum - (o's primes's item j)
        set j to j - 1
    end repeat

    return {sum:topRunSum, |run|:o's primes's items topRunStart thru topRunEnd}
end CalmoSoftPrimes

on sieveOfSundaram(lowerLimit, upperLimit)
    if (upperLimit < lowerLimit) then set {upperLimit, lowerLimit} to {lowerLimit, upperLimit}
    if (upperLimit < 2) then return {}
    if (lowerLimit < 2) then set lowerLimit to 2

    set k to (upperLimit - 1) div 2
    set shift to lowerLimit div 2 - 1
    script o
        property sieve : makeList(k - shift, true)

        on zapMultiples(n)
            set i to (n * n) div 2
            if (i ≤ shift) then set i to shift + n - (shift - i) mod n
            repeat with i from (i - shift) to (k - shift) by n
                set my sieve's item i to false
            end repeat
        end zapMultiples
    end script

    o's zapMultiples(3)
    set addends to {2, 6, 8, 12, 14, 18, 24, 26}
    repeat with n from 5 to (upperLimit ^ 0.5 div 1) by 30
        o's zapMultiples(n)
        repeat with a in addends
            o's zapMultiples(n + a)
        end repeat
    end repeat

    repeat with i from 1 to (k - shift)
        if (o's sieve's item i) then set o's sieve's item i to (i + shift) * 2 + 1
    end repeat
    set o's sieve to o's sieve's numbers
    if (lowerLimit is 2) then set o's sieve's beginning to 2

    return o's sieve
end sieveOfSundaram

on makeList(limit, filler)
    if (limit < 1) then return {}
    script o
        property lst : {filler}
    end script

    set counter to 1
    repeat until (counter + counter > limit)
        set o's lst to o's lst & o's lst
        set counter to counter + counter
    end repeat
    if (counter < limit) then set o's lst to o's lst & o's lst's items 1 thru (limit - counter)
    return o's lst
end makeList

on isPrime(n)
    if (n < 4) then return (n > 1)
    if ((n mod 2 is 0) or (n mod 3 is 0)) then return false
    repeat with i from 5 to (n ^ 0.5) div 1 by 6
        if ((n mod i is 0) or (n mod (i + 2) is 0)) then return false
    end repeat

    return true
end isPrime

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

on intToText(int, separator)
    set groups to {}
    repeat while (int > 999)
        set groups's beginning to ((1000 + (int mod 1000 as integer)) as text)'s text 2 thru 4
        set int to int div 1000
    end repeat
    set groups's beginning to int
    return join(groups, separator)
end intToText

on task()
    set output to {"Longest run of CalmoSoft primes < 100:"}
    set {sum:sum, |run|:|run|} to CalmoSoftPrimes(99)
    set end of output to join(|run|, ", ")
    set end of output to "They add up to " & sum
    set end of output to "Beginning & end of longest run of CalmoSoft primes < 50,000,000:"
    script o
        property |run| : missing value
    end script
    set {sum:sum, |run|:o's |run|} to CalmoSoftPrimes(49999999)
    set end of output to join(o's |run|'s items 1 thru 6, ", ") & " … " & join(o's |run|'s items -6 thru -1, ", ")
    set end of output to "The entire run adds up to " & intToText(sum, ",")

    return join(output, linefeed)
end task

task()
