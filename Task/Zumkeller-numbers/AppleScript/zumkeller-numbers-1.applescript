-- Sum n's proper divisors.
on aliquotSum(n)
    if (n < 2) then return 0
    set sum to 1
    set sqrt to n ^ 0.5
    set limit to sqrt div 1
    if (limit = sqrt) then
        set sum to sum + limit
        set limit to limit - 1
    end if
    repeat with i from 2 to limit
        if (n mod i is 0) then set sum to sum + i + n div i
    end repeat

    return sum
end aliquotSum

-- Return n's proper divisors.
on properDivisors(n)
    set output to {}

    if (n > 1) then
        set sqrt to n ^ 0.5
        set limit to sqrt div 1
        if (limit = sqrt) then
            set end of output to limit
            set limit to limit - 1
        end if
        repeat with i from limit to 2 by -1
            if (n mod i is 0) then
                set beginning of output to i
                set end of output to n div i
            end if
        end repeat
        set beginning of output to 1
    end if

    return output
end properDivisors

-- Does a subset of the given list of numbers add up to the target value?
on subsetOf:numberList sumsTo:target
    script o
        property lst : numberList
        property someNegatives : false

        on ssp(target, i)
            repeat while (i > 1)
                set n to item i of my lst
                set i to i - 1
                if ((n = target) or (((n < target) or (someNegatives)) and (ssp(target - n, i)))) then return true
            end repeat
            return (target = beginning of my lst)
        end ssp
    end script
    -- The search can be more efficient if it's known the list contains no negatives.
    repeat with n in o's lst
        if (n < 0) then
            set o's someNegatives to true
            exit repeat
        end if
    end repeat

    return o's ssp(target, count o's lst)
end subsetOf:sumsTo:

-- Is n a Zumkeller number?
on isZumkeller(n)
    -- Yes if its aliquot sum is greater than or equal to it, the difference between them is even, and
    -- either n is odd or a subset of its proper divisors sums to half the sum of the divisors and it.
    -- Using aliquotSum() to get the divisor sum and then calling properDivisors() too if a list's actually
    -- needed is generally faster than using properDivisors() in the first place and summing the result.
    set sum to aliquotSum(n)
    return ((sum ≥ n) and ((sum - n) mod 2 = 0) and ¬
        ((n mod 2 = 1) or (my subsetOf:(properDivisors(n)) sumsTo:((sum + n) div 2))))
end isZumkeller

-- Task code:
-- Find and return q Zumkeller numbers, starting the search at n and continuing at the
-- given interval, applying the Zumkeller test only to numbers passing the given filter.
on zumkellerNumbers(q, n, interval, filter)
    script o
        property zumkellers : {}
    end script

    set counter to 0
    repeat until (counter = q)
        if ((filter's OK(n)) and (isZumkeller(n))) then
            set end of o's zumkellers to n
            set counter to counter + 1
        end if
        set n to n + interval
    end repeat

    return o's zumkellers
end zumkellerNumbers

on joinText(textList, delimiter)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delimiter
    set txt to textList as text
    set AppleScript's text item delimiters to astid

    return txt
end joinText

on formatForDisplay(resultList, heading, resultsPerLine, separator)
    script o
        property input : resultList
        property output : {heading}
    end script

    set len to (count o's input)
    repeat with i from 1 to len by resultsPerLine
        set j to i + resultsPerLine - 1
        if (j > len) then set j to len
        set end of o's output to joinText(items i thru j of o's input, separator)
    end repeat

    return joinText(o's output, linefeed)
end formatForDisplay

on doTask(cheating)
    set output to {}
    script noFilter
        on OK(n)
            return true
        end OK
    end script
    set header to "1st 220 Zumkeller numbers:"
    set end of output to formatForDisplay(zumkellerNumbers(220, 1, 1, noFilter), header, 20, "  ")
    set header to "1st 40 odd Zumkeller numbers:"
    set end of output to formatForDisplay(zumkellerNumbers(40, 1, 2, noFilter), header, 10, "  ")

    -- Stretch goal:
    set header to "1st 40 odd Zumkeller numbers not ending with 5:"
    script no5Multiples
        on OK(n)
            return (n mod 5 > 0)
        end OK
    end script
    if (cheating) then
        -- Knowing that the HCF of the first 203 odd Zumkellers not ending with 5
        -- is 63, just check 63 and each 126th number thereafter.
        -- For the 204th - 907th such numbers, the HCF reduces to 21, so adjust accordingly.
        -- (See Horsth's comments on the Talk page.)
        set zumkellers to zumkellerNumbers(40, 63, 126, no5Multiples)
    else
        -- Otherwise check alternate numbers from 1.
        set zumkellers to zumkellerNumbers(40, 1, 2, no5Multiples)
    end if
    set end of output to formatForDisplay(zumkellers, header, 10, "  ")

    return joinText(output, linefeed & linefeed)
end doTask

local cheating
set cheating to false
doTask(cheating)
