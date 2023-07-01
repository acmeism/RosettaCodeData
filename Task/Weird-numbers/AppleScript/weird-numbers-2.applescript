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

-- Is n a weird number?
on isWeird(n)
    -- Yes if its aliquot sum's greater than it and no subset of its proper divisors adds up to it.
    -- Using aliquotSum() to get the divisor sum and then calling properDivisors() too if a list's actually
    -- needed is generally faster than calling properDivisors() in the first place and summing the result.
    set sum to aliquotSum(n)
    if (sum > n) then
        set divisors to properDivisors(n)
        -- Check that no subset sums to the smaller (usually the latter) of n and sum - n.
        tell (sum - n) to if (it < n) then set n to it
        return (not (my subsetOf:divisors sumsTo:n))
    else
        return false
    end if
end isWeird

-- Task code:
on weirdNumbers(target)
    script o
        property weirds : {}
    end script

    set n to 2
    set counter to 0
    repeat until (counter = target)
        if (isWeird(n)) then
            set end of o's weirds to n
            set counter to counter + 1
        end if
        set n to n + 1
    end repeat

    return o's weirds
end weirdNumbers

weirdNumbers(25)
