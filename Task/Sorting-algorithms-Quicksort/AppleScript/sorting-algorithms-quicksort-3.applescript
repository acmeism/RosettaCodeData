-- In-place Quicksort (basic algorithm).
-- Algorithm: S.A.R. (Tony) Hoare, 1960.
on quicksort(theList, l, r) -- Sort items l thru r of theList.
    set listLength to (count theList)
    if (listLength < 2) then return
    -- Convert negative and/or transposed range indices.
    if (l < 0) then set l to listLength + l + 1
    if (r < 0) then set r to listLength + r + 1
    if (l > r) then set {l, r} to {r, l}

    -- Script object containing the list as a property (to allow faster references to its items)
    -- and the recursive subhandler.
    script o
        property lst : theList

        on qsrt(l, r)
            set pivot to my lst's item ((l + r) div 2)
            set i to l
            set j to r
            repeat until (i > j)
                set lv to my lst's item i
                repeat while (pivot > lv)
                    set i to i + 1
                    set lv to my lst's item i
                end repeat

                set rv to my lst's item j
                repeat while (rv > pivot)
                    set j to j - 1
                    set rv to my lst's item j
                end repeat

                if (j > i) then
                    set my lst's item i to rv
                    set my lst's item j to lv
                else if (i > j) then
                    exit repeat
                end if

                set i to i + 1
                set j to j - 1
            end repeat

            if (j > l) then qsrt(l, j)
            if (i < r) then qsrt(i, r)
        end qsrt
    end script

    tell o to qsrt(l, r)

    return -- nothing.
end quicksort
property sort : quicksort

-- Demo:
local aList
set aList to {28, 9, 95, 22, 67, 55, 20, 41, 60, 53, 100, 72, 19, 67, 14, 42, 29, 20, 74, 39}
sort(aList, 1, -1) -- Sort items 1 thru -1 of aList.
return aList
