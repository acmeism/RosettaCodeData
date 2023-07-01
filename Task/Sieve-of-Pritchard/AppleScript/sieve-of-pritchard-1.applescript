on sieveOfPritchard(limit)
    if (limit < 2) then return {}
    script o
        property wheel : {2}
        property extension : missing value
    end script

    set {x, newCircumference, currentPrime, mv} to {0, 2, 1, missing value}
    repeat until (currentPrime * currentPrime > limit)
        -- Get the next confirmed prime from the wheel.
        set x to x + 1
        set currentPrime to o's wheel's item x
        -- Get an extension list nominally expanding the wheel to the lesser of
        -- its current circumference * currentPrime and the limit parameter.
        -- It'll be far longer than needed, but hey.
        set oldCircumference to newCircumference
        set newCircumference to oldCircumference * currentPrime
        if (newCircumference > limit) then set newCircumference to limit
        set o's extension to makeList(newCircumference - oldCircumference, mv)
        -- Insert numbers that are oldCircumference added to 1 and to each number currently in the
        -- unpartitioned part of the wheel, except where the results are multiples of currentPrime.
        set k to 0
        set listLen to (count o's wheel)
        repeat with augend from oldCircumference to (newCircumference - 1) by oldCircumference
            set n to augend + 1
            if (n mod currentPrime > 0) then
                set k to k + 1
                set o's extension's item k to n
            end if
            repeat with i from x to listLen
                set n to augend + (o's wheel's item i)
                if (n > newCircumference) then exit repeat
                if (n mod currentPrime > 0) then
                    set k to k + 1
                    set o's extension's item k to n
                end if
            end repeat
        end repeat
        -- Find and delete multiples of the current prime which occur in the old part of the wheel.
        set maxMultiple to oldCircumference div currentPrime
        set i to x
        repeat while ((o's wheel's item i) < maxMultiple)
            set i to i + 1
        end repeat
        repeat with i from i to x by -1
            set j to binarySearch((o's wheel's item i) * currentPrime, o's wheel, i, listLen)
            if (j > 0) then
                set o's wheel's item j to mv
                set listLen to j - 1
            end if
        end repeat
        -- Keep the undeleted numbers and any in the extension list.
        set o's wheel to o's wheel's numbers
        if (k > 0) then set o's wheel to o's wheel & o's extension's items 1 thru k
    end repeat

    return o's wheel
end sieveOfPritchard

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

on binarySearch(n, theList, l, r)
    script o
        property lst : theList
    end script
    repeat until (l = r)
        set m to (l + r) div 2
        if (o's lst's item m < n) then
            set l to m + 1
        else
            set r to m
        end if
    end repeat

    if (o's lst's item l is n) then return l
    return 0
end binarySearch

sieveOfPritchard(150)
