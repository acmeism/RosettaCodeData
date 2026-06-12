on sumPrimes below this
    set limit to this - 1
    -- Is the limit 2 or lower?
    if (limit = 2) then return 2
    if (limit < 2) then return 0

    -- Build a list of limit (+ 2 for safety) missing values.
    set mv to missing value
    script o
        property numberList : {mv}
    end script
    repeat until ((count o's numberList) * 2 > limit)
        set o's numberList to o's numberList & o's numberList
    end repeat
    set o's numberList to {mv} & items 1 thru (limit - (count o's numberList) + 1) of o's numberList & o's numberList
    -- Populate every 6th slot after the 5th and 7th with the equivalent integers.
    -- The other slots all represent multiples of 2 and/or 3 and are left as missing values.
    repeat with n from 5 to limit by 6
        set item n of o's numberList to n
        tell (n + 2) to set item it of o's numberList to it
    end repeat
    -- If we're here, the limit must be 3 or higher. So start with the sum of 2 and 3.
    set sum to 5
    -- Continue adding primes from the list and eliminate multiples
    -- of those up to the limit's square root from the list.
    set isqrt to limit ^ 0.5 div 1
    repeat with n from 5 to limit by 6
        if (item n of o's numberList = n) then
            set sum to sum + n
            if (n ≤ isqrt) then
                repeat with multiple from (n * n) to limit by n
                    set item multiple of o's numberList to mv
                end repeat
            end if
        end if
        tell (n + 2)
            if ((it ≤ limit) and (item it of o's numberList = it)) then
                set sum to sum + it
                if (it ≤ isqrt) then
                    repeat with multiple from (it * it) to limit by it
                        set item multiple of o's numberList to mv
                    end repeat
                end if
            end if
        end tell
    end repeat

    return sum
end sumPrimes

sumPrimes below 2000000
