-- In-place insertion sort
on insertionSort(theList, l, r) -- Sort items l thru r of theList.
    set listLength to (count theList)
    if (listLength < 2) then return
    -- Convert negative and/or transposed range indices.
    if (l < 0) then set l to listLength + l + 1
    if (r < 0) then set r to listLength + r + 1
    if (l > r) then set {l, r} to {r, l}

    -- The list as a script property to allow faster references to its items.
    script o
        property lst : theList
    end script

    -- Set up a minor optimisation whereby the latest instance of the highest value so far isn't
    -- put back into the list until either it's superseded or the end of the sort is reached.
    set highestSoFar to o's lst's item l
    set rv to o's lst's item (l + 1)
    if (highestSoFar > rv) then
        set o's lst's item l to rv
    else
        set highestSoFar to rv
    end if
    -- Work through the rest of the range, rotating values back into the sorted group as necessary.
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
property sort : insertionSort

-- Demo:
local aList
set aList to {60, 73, 11, 66, 6, 77, 41, 97, 59, 45, 64, 15, 91, 100, 22, 89, 77, 59, 54, 61}
sort(aList, 1, -1) -- Sort items 1 thru -1 of aList.
return aList
