-- Comb sort with insertion sort finish.
-- Comb sort algorithm: Włodzimierz Dobosiewicz and Artur Borowy, 1980. Stephen Lacey and Richard Box, 1991.

on combSort(theList, l, r) -- Sort items l thru r of theLIst.
    set listLen to (count theList)
    if (listLen < 2) then return
    -- Negative and/or transposed range indices.
    if (l < 0) then set l to listLen + l + 1
    if (r < 0) then set r to listLen + r + 1
    if (l > r) then set {l, r} to {r, l}

    script o
        property lst : theList
    end script

    -- This implementation performs fastest with a comb gap divisor of 1.4
    -- and the insertion sort taking over when the gap's down to 8 or less.
    set divisor to 1.4
    set gap to (r - l + 1) div divisor
    repeat while (gap > 8)
        repeat with i from l to (r - gap)
            set j to i + gap
            set lv to o's lst's item i
            set rv to o's lst's item j
            if (lv > rv) then
                set o's lst's item i to rv
                set o's lst's item j to lv
            end if
        end repeat
        set gap to gap div divisor
    end repeat

    insertionSort(theList, l, r)

    return -- nothing.
end combSort

on insertionSort(theList, l, r) -- Sort items l thru r of theList.
    set listLength to (count theList)
    if (listLength < 2) then return
    if (l < 0) then set l to listLength + l + 1
    if (r < 0) then set r to listLength + r + 1
    if (l > r) then set {l, r} to {r, l}

    script o
        property lst : theList
    end script

    set highestSoFar to o's lst's item l
    set rv to o's lst's item (l + 1)
    if (highestSoFar > rv) then
        set o's lst's item l to rv
    else
        set highestSoFar to rv
    end if
    repeat with j from (l + 2) to r
        set rv to o's lst's item j
        if (highestSoFar > rv) then
            repeat with i from (j - 2) to l by -1
                set lv to o's lst's item i
                if (lv > rv) then
                    set o's lst's item (i + 1) to lv
                else
                    set i to i + 1
                    exit repeat
                end if
            end repeat
            set o's lst's item i to rv
        else
            set o's lst's item (j - 1) to highestSoFar
            set highestSoFar to rv
        end if
    end repeat
    set o's lst's item r to highestSoFar

    return -- nothing.
end insertionSort

-- Demo:
local aList
set aList to {7, 56, 70, 22, 94, 42, 5, 25, 54, 90, 29, 65, 87, 27, 4, 5, 86, 8, 2, 30, 87, 12, 85, 86, 7}
combSort(aList, 1, -1) -- Sort items 1 thru -1 of aList.
aList
