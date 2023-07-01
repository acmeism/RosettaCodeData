-- In-place bubble sort.
on bubbleSort(theList, l, r) -- Sort items l thru r of theList.
    set listLen to (count theList)
    if (listLen < 2) then return
    -- Convert negative and/or transposed range indices.
    if (l < 0) then set l to listLen + l + 1
    if (r < 0) then set r to listLen + r + 1
    if (l > r) then set {l, r} to {r, l}

    -- The list as a script property to allow faster references to its items.
    script o
        property lst : theList
    end script

    set lPlus1 to l + 1
    repeat with j from r to lPlus1 by -1
        set lv to o's lst's item l
        -- Hereafter lv is only set when necessary and from rv rather than from the list.
        repeat with i from lPlus1 to j
            set rv to o's lst's item i
            if (lv > rv) then
                set o's lst's item (i - 1) to rv
                set o's lst's item i to lv
            else
                set lv to rv
            end if
        end repeat
    end repeat

    return -- nothing.
end bubbleSort
property sort : bubbleSort

-- Demo:
local aList
set aList to {61, 23, 11, 55, 1, 94, 71, 98, 70, 33, 29, 77, 58, 95, 2, 52, 68, 29, 27, 37, 74, 38, 45, 73, 10}
sort(aList, 1, -1) -- Sort items 1 thru -1 of aList.
return aList
