-- Return the median value of items l thru r of a list of numbers.
on getMedian(theList, l, r)
    if (theList is {}) then return theList

    script o
        property lst : theList's items l thru r -- Copy of the range to be searched.
    end script

    set rangeLength to (r - l + 1)
    set m to (rangeLength + 1) div 2 -- Central position in the range copy, or the leftmost of two.
    set {l, r} to {1, rangeLength} -- Outer partition indices.
    set previousR to r -- Reminder of previous r.
    repeat -- quickselect repeat
        set pivot to o's lst's item ((l + r) div 2)
        set i to l
        set j to r
        repeat until (i > j)
            set lv to o's lst's item i
            repeat while (lv < pivot)
                set i to i + 1
                set lv to o's lst's item i
            end repeat

            set rv to o's lst's item j
            repeat while (rv > pivot)
                set j to j - 1
                set rv to o's lst's item j
            end repeat

            if (i > j) then
            else
                set o's lst's item i to rv
                set o's lst's item j to lv
                set i to i + 1
                set j to j - 1
            end if
        end repeat

        -- If i and j have crossed at m, item m's the median value.
        -- Otherwise reset to partition the partition containing m.
        if (j < m) then
            if (i > m) then exit repeat
            set l to i
        else
            set previousR to r
            set r to j
        end if
    end repeat

    set median to item m of o's lst
    -- If the range has an even number of items, find the lowest value to the right of m and average it
    -- with the median just obtained. We only need to search to the end of the range just partitioned —
    -- unless that's where m is, in which case to end of the most recent extent beyond that (if any).
    if (rangeLength mod 2 is 0) then
        set median2 to item i of o's lst
        if (r = m) then set r to previousR
        repeat with i from (i + 1) to r
            set v to item i of o's lst
            if (v < median2) then set median2 to v
        end repeat
        set median to (median + median2) / 2
    end if

    return median
end getMedian

-- Demo:
local testList
set testList to {}
repeat with i from 1 to 8
    set end of testList to (random number 500) / 5
end repeat
return {|numbers|:testList, median:getMedian(testList, 1, (count testList))}
