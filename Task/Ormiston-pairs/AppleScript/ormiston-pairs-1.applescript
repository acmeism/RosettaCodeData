use AppleScript version "2.4" -- Mac OS X 10.10 (Yosemite) or later.
use sorter : script "Insertion sort" -- <https://rosettacode.org/wiki/Sorting_algorithms/Insertion_sort#AppleScript>

on OrmistonPairs()
    script o
        property primes : sieveOfSundaram(13, 10000000)
    end script

    set output to {"First 30 Ormiston pairs:"}
    set outputLine to {}
    set p1 to missing value
    set digits1 to {}
    set counter to 0
    repeat with p2 in o's primes
        set p2 to p2's contents
        set p to p2
        set digits2 to {}
        repeat until (p = 0)
            set end of digits2 to p mod 10
            set p to p div 10
        end repeat
        tell sorter to sort(digits2, 1, -1)
        if (digits2 = digits1) then
            if (counter < 30) then
                set end of outputLine to ("{" & p1) & (", " & p2 & "}")
                if ((count outputLine) = 6) then
                    set end of output to join(outputLine, "  ")
                    set outputLine to {}
                end if
            end if
            set counter to counter + 1
        end if
        if ((p2 > 1000000) and (p1 < 1000000)) then ¬
            set end of output to "Number of pairs < 1,000,000: " & counter
        set p1 to p2
        set digits1 to digits2
    end repeat
    set end of output to "Number of pairs < 10,000,000: " & counter

    return join(output, linefeed)
end OrmistonPairs

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

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

OrmistonPairs()
