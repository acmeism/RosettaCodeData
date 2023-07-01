(*
    In-place, iterative binary merge sort
    Merge sort algorithm: John von Neumann, 1945.

    Convenience terminology used here:
        run: one of two adjacent source-list ranges containing ordered items for merging.
        block: range in the destination list to which two runs are merged.
*)
on mergeSort(theList, l, r) -- Sort items l thru r of theList.
    set listLength to (count theList)
    if (listLength < 2) then return
    -- Convert negative and/or transposed range indices.
    if (l < 0) then set l to listLength + l + 1
    if (r < 0) then set r to listLength + r + 1
    if (l > r) then set {l, r} to {r, l}

    -- Script object containing the input list and the sort range indices.
    script main
        property lst : theList
        property l : missing value
        property r : missing value
    end script
    set {main's l, main's r} to {l, r}

    -- Just swap adjacent items as necessary on the first pass.
    -- (Short insertion sorts would be better, to create larger initial runs.)
    repeat with j from (l + 1) to r by 2
        set i to j - 1
        set lv to main's lst's item i
        set rv to main's lst's item j
        if (lv > rv) then
            set main's lst's item i to rv
            set main's lst's item j to lv
        end if
    end repeat
    set rangeLength to r - l + 1
    if (rangeLength < 3) then return -- That's all if fewer than three items to sort.

    -- Script object to alternate with the one above as the source and destination for the
    -- merges. Its list need only contain the items from the sort range as ordered so far.
    script aux
        property lst : main's lst's items l thru r
        property l : 1
        property r : rangeLength
    end script

    -- Work out how many merging passes will be needed and set the script objects' initial
    -- source and destination roles so that the final pass will merge back to the original list.
    set passesToDo to 0
    set blockSize to 2
    repeat while (blockSize < rangeLength)
        set passesToDo to passesToDo + 1
        set blockSize to blockSize + blockSize
    end repeat
    set {srce, dest} to {{main, aux}, {aux, main}}'s item (passesToDo mod 2 + 1)

    -- Do the remaining passes, doubling the run and block sizes on each pass.
    -- (The end set in each pass will usually be truncated.)
    set blockSize to 2
    repeat passesToDo times -- Per pass.
        set runSize to blockSize
        set blockSize to blockSize + blockSize
        set k to (dest's l) - 1 -- Destination traversal index.

        repeat with leftStart from srce's l to srce's r by blockSize -- Per merge.
            set blockEnd to k + blockSize
            if (blockEnd comes after dest's r) then set blockEnd to dest's r
            set i to leftStart -- Left run traversal index.
            set leftEnd to leftStart + runSize - 1
            if (leftEnd comes before srce's r) then
                set j to leftEnd + 1 -- Right run traversal index.
                set rightEnd to leftEnd + runSize
                if (rightEnd comes after srce's r) then set rightEnd to srce's r
                -- Merge process:
                set lv to srce's lst's item i
                set rv to srce's lst's item j
                repeat with k from (k + 1) to blockEnd
                    if (lv > rv) then
                        set dest's lst's item k to rv
                        if (j = rightEnd) then exit repeat -- Right run used up.
                        set j to j + 1
                        set rv to srce's lst's item j
                    else
                        set dest's lst's item k to lv
                        if (i = leftEnd) then -- Left run used up.
                            set i to j
                            exit repeat
                        end if
                        set i to i + 1
                        set lv to srce's lst's item i
                    end if
                end repeat
            end if
            -- Use up the remaining items from the not-yet-exhausted run.
            repeat with k from (k + 1) to blockEnd
                set dest's lst's item k to srce's lst's item i
                set i to i + 1
            end repeat
        end repeat -- Per merge.

        -- Switch source and destination scripts for the next pass.
        tell srce
            set srce to dest
            set dest to it
        end tell
    end repeat -- Per pass.

    return -- nothing
end mergeSort
property sort : mergeSort

-- Demo:
local aList
set aList to {22, 15, 98, 82, 22, 4, 58, 70, 80, 38, 49, 48, 46, 54, 93, 8, 54, 2, 72, 84, 86, 76, 53, 37, 90}
sort(aList, 1, -1) -- Sort items 1 thru -1 of aList.
return aList
