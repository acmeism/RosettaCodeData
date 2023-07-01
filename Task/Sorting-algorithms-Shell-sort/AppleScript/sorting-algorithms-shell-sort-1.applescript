-- In-place Shell sort.
-- Algorithm: Donald Shell, 1959.
on ShellSort(theList, l, r) -- Sort items l thru r of theList.
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

    set stepSize to (r - l + 1) div 2
    repeat while (stepSize > 0)
        repeat with i from (l + stepSize) to r
            set currentValue to o's lst's item i
            repeat with j from (i - stepSize) to l by -stepSize
                set thisValue to o's lst's item j
                if (thisValue > currentValue) then
                    set o's lst's item (j + stepSize) to thisValue
                else
                    set j to j + stepSize
                    exit repeat
                end if
            end repeat
            if (j < i) then set o's lst's item j to currentValue
        end repeat
        set stepSize to (stepSize / 2.2) as integer
    end repeat

    return -- nothing.
end ShellSort
property sort : ShellSort

-- Demo:
local aList
set aList to {56, 44, 72, 4, 93, 26, 61, 72, 52, 9, 87, 26, 73, 75, 94, 91, 30, 18, 63, 16}
sort(aList, 1, -1) -- Sort items 1 thru -1 of aList.
return aList
