on selectionSort(theList, l, r) -- Sort items l thru r of theList in place.
    set listLength to (count theList)
    if (listLength < 2) then return
    -- Convert negative and/or transposed range indices.
    if (l < 0) then set l to listLength + l + 1
    if (r < 0) then set r to listLength + r + 1
    if (l > r) then set {l, r} to {r, l}

    script o
        property lst : theList
    end script

    repeat with i from l to (r - 1)
        set iVal to o's lst's item i
        set minVal to iVal
        set minPos to i
        repeat with j from (i + 1) to r
            set jVal to o's lst's item j
            if (minVal > jVal) then
                set minVal to jVal
                set minPos to j
            end if
        end repeat
        set o's lst's item minPos to iVal
        set o's lst's item i to minVal
    end repeat

    return -- nothing.
end selectionSort
property sort : selectionSort

on demo()
    set theList to {988, 906, 151, 71, 712, 177, 945, 558, 31, 627}
    sort(theList, 1, -1)
    return theList
end demo

demo()
