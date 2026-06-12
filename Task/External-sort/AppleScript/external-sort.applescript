(*
Quicksort algorithm: S.A.R. (Tony) Hoare, 1960.
Optimisations by Robert Sedgewick and others at various times.
Heap sort algorithm: J.W.J. Williams, 1964.
*)

use AppleScript version "2.3.1" -- MacOS 10.9 (Mavericks) or later — for these 'use' commands!
use internalSorter : script "Heap sort" -- <https://www.rosettacode.org/wiki/Sorting_algorithms/Heapsort#AppleScript>.
use scripting additions

-- Configuration.
property maxChunkSize : 256000 -- 256 KBytes (64000 AppleScript integers). The larger this figure can be, the less slow the sort.
property integerSize : 4
property maxInternalSortSize : maxChunkSize

on externalSort(theFile) -- Param: file, alias, or HFS path.
    (* Properties and handlers for the sort. *)
    script o
        -- Precalculated values.
        property twiceIntegerSize : integerSize + integerSize
        property maxHalfChunkSize : maxChunkSize div twiceIntegerSize * integerSize
        -- Reference number of the system file handle for the open file.
        property fRef : missing value
        -- Start byte indices of integers in the file.
        property i : missing value
        property j : missing value
        -- Start byte indices of the most recent additions to pivot stores in the file.
        property pLeft : missing value
        property pRight : missing value
        -- Two buffer lists and assocatiated info.
        property leftList : missing value
        property leftEndByte : missing value -- End byte index of equivalent range in file.
        property a : missing value -- Left list index.
        property leftListLength : missing value
        property rightList : missing value
        property rightStartByte : missing value -- Start byte index of equivalent range in file.
        property b : missing value -- Right list index.
        -- Whether or not down to single-list working.
        property singleList : missing value

        (* Quicksort handler. Sorts a file of integers in place. *)
        on qsrt(l, r) -- Params: start-byte indices in the file of the first and last integers in a range to be partitioned.
            repeat -- Tail call elimination repeat.
                -- Prime the properties for this range.
                set {i, j, pLeft, pRight, leftEndByte, a, leftListLength, rightStartByte, b, singleList} to ¬
                    {l, r, l - integerSize, r + integerSize, l - 1, 0, 0, r + integerSize, 0, false}
                -- Get the first and last integers in the range, setting up the first two buffer lists in the process.
                set leftValue to nextLeftInteger(l, r)
                set rightValue to nextRightInteger(l, r)
                -- Read a third integer directly from the middle of the range in the file.
                set pivot to (read fRef from ((l + r - 2) div twiceIntegerSize * integerSize + 1) for integerSize as integer)
                -- Choose one of the three as the pivot (median-of-3 pivot selection).
                set leftGreaterThanRight to (leftValue > rightValue)
                if (leftValue > pivot) then
                    if (leftGreaterThanRight) then
                        if (rightValue > pivot) then set pivot to rightValue
                    else
                        set pivot to leftValue
                    end if
                else if (pivot > rightValue) then
                    if (leftGreaterThanRight) then
                        set pivot to leftValue
                    else
                        set pivot to rightValue
                    end if
                end if
                -- Whichever's now the pivot, swap the outermost two if the left's greater than the right.
                -- If either of them *is* the pivot, advance the pivot store boundary on the relevant side.
                if (leftGreaterThanRight) then
                    write leftValue to fRef as integer starting at r
                    write rightValue to fRef as integer starting at l
                    if (leftValue = pivot) then
                        set pRight to r
                    else if (rightValue = pivot) then
                        set pLeft to l
                    end if
                else
                    if (leftValue = pivot) then set pLeft to l
                    if (rightValue = pivot) then set pRight to r
                end if

                -- Continue partitioning the range.
                set i to l + integerSize
                set j to r - integerSize
                repeat until (i > j) -- Partitioning repeat.
                    set leftValue to nextLeftInteger(l, r)
                    repeat while (leftValue < pivot)
                        set i to i + integerSize
                        set leftValue to nextLeftInteger(l, r)
                    end repeat

                    set rightValue to nextRightInteger(l, r)
                    repeat while (rightValue > pivot)
                        set j to j - integerSize
                        set rightValue to nextRightInteger(l, r)
                    end repeat

                    if (j > i) then
                        -- Three-way partitioning: if either value to be swapped is a pivot instance, extend the pivot store
                        -- on the destination side and, if the appropriated slot isn't already the pivot destination, swap its
                        -- current content for (a copy of) the pivot and use the retrieved value instead in the main swap.
                        if (leftValue = pivot) then
                            set pRight to pRight - integerSize
                            if (pRight > j) then
                                set leftValue to (read fRef from pRight for integerSize as integer)
                                write pivot as integer to fRef starting at pRight
                            end if
                        end if
                        if (rightValue = pivot) then
                            set pLeft to pLeft + integerSize
                            if (pLeft < i) then
                                set rightValue to (read fRef from pLeft for integerSize as integer)
                                write pivot as integer to fRef starting at pLeft
                            end if
                        end if
                        -- Write the values to be swapped to the appropriate places in the file.
                        write rightValue to fRef as integer starting at i
                        write leftValue to fRef as integer starting at j
                        -- If down to a single buffer list, update this too so that the repeat will know when to stop.
                        if (singleList) then
                            set item a of my leftList to rightValue
                            set item b of my leftList to leftValue
                        end if
                    else if (i > j) then
                        exit repeat
                    end if

                    set i to i + integerSize
                    set j to j - integerSize
                end repeat -- Partitioning.

                -- Swap any stored pivot instances into the slots next to the crossed indices
                -- and advance the indices to exclude the pivots from the rest of the sort.
                repeat with p from l to pLeft by integerSize
                    if (j > pLeft) then
                        write (read fRef from j for integerSize as integer) to fRef as integer starting at p
                        write pivot to fRef as integer starting at j
                        set j to j - integerSize
                    else
                        -- Don't bother swapping where store and target slots overlap.
                        set j to p - integerSize
                        exit repeat
                    end if
                end repeat
                repeat with p from r to pRight by -integerSize
                    if (i < pRight) then
                        write (read fRef from i for integerSize as integer) to fRef as integer starting at p
                        write pivot to fRef as integer starting at i
                        set i to i + integerSize
                    else
                        set i to p + integerSize
                        exit repeat
                    end if
                end repeat

                -- Where the new partitions are short enough, sort them in memory with a non-recursive sort.
                -- Otherwise subpartition the shorter one recursively, then the longer iteratively.
                set leftDiff to j - l
                set rightDiff to r - i
                if (leftDiff < rightDiff) then
                    set {shorterDiff, ls, rs, longerDiff, l} to {leftDiff, l, j, rightDiff, i}
                else
                    set {shorterDiff, ls, rs, longerDiff, r} to {rightDiff, i, r, leftDiff, j}
                end if
                if (shorterDiff < maxInternalSortSize) then
                    if (rs > ls) then sortInMemory(ls, rs)
                else
                    qsrt(ls, rs)
                end if
                if (longerDiff < maxInternalSortSize) then
                    if (r > l) then sortInMemory(l, r)
                    exit repeat -- … and return from the handler.
                end if
                -- Otherwise go round again to handle the longer partition.
            end repeat -- Tail call elimination.
        end qsrt

        (* Return the next integer from the left buffer list, setting up or replacing the list as necessary. *)
        on nextLeftInteger(l, r)
            set a to a + 1
            if (a > leftListLength) then
                -- The existing left list has been used up or doesn't yet exist.
                set leftEndByte to leftEndByte + maxHalfChunkSize
                -- Derive a new left list from the next half-chunk of data — unless any of this is already
                -- covered by the other list, in which case replace both lists with a single one.
                if (leftEndByte < rightStartByte) then
                    set leftList to (read fRef from i for maxHalfChunkSize as integer) as list
                    set a to 1
                    set leftListLength to (count leftList)
                else
                    goToSingleList(l, r)
                    set b to b + 1
                end if
            end if

            return item a of my leftList
        end nextLeftInteger

        (* Return the next integer from the right buffer list, simile. *)
        on nextRightInteger(l, r)
            set b to b - 1
            if (b < 1) then
                set rightStartByte to rightStartByte - maxHalfChunkSize
                if (rightStartByte > leftEndByte) then
                    set rightList to (read fRef from rightStartByte for maxHalfChunkSize as integer) as list
                    set b to (count rightList)
                else
                    goToSingleList(l, r)
                end if
            end if

            return item b of my rightList
        end nextRightInteger

        (* Set up a single buffer list for use in the closing stage of a partitioning repeat. *)
        on goToSingleList(l, r)
            -- The range to read from the file is from bytes i to (j + integerSize - 1)
            -- PLUS an integer either side, if these are within the range being partitioned,
            -- to help ensure that the partitioning repeat stops in the right place.
            if (i > l) then
                set readStart to i - integerSize
                set a to 2
            else
                set readStart to i
                set a to 1
            end if
            if (j < r) then
                set readEnd to j + twiceIntegerSize - 1
            else
                set readEnd to j + integerSize - 1
            end if
            -- Ditch the existing right list.
            set rightList to missing value
            -- Read the integers from the calculated range and set both list properties to the same result instance.
            set leftList to (read fRef from readStart to readEnd as integer) as list
            set rightList to leftList
            -- Set the other relevant properties.
            set b to (count rightList)
            if (j < r) then set b to b - 1
            set leftListLength to b
            set singleList to true
        end goToSingleList

        (* Read integers from a given range in the file, sort them in memory, and write them back to the same range. *)
        on sortInMemory(l, r)
            set rightList to missing value
            set leftList to (read fRef from l to (r + integerSize - 1) as integer) as list
            tell internalSorter to sort(leftList, 1, -1)
            read fRef from l for 0 -- Set the file handle's position pointer.
            repeat with x from 1 to (count leftList)
                write (item x of my leftList) as integer to fRef
            end repeat
        end sortInMemory
    end script

    (* Main handler code. Sets up and starts the sort. *)

    -- Check the input.
    try
        set theFile to theFile as alias
    on error
        display dialog "The specified file doesn't exist." buttons {"Stop"} default button 1 cancel button 1 with icon stop
    end try
    set fileSize to (get eof theFile)
    if (fileSize is 0) then
        display dialog "The file is empty." buttons {"Stop"} default button 1 cancel button 1 with icon stop
    else if (fileSize mod integerSize > 0) then
        display dialog ¬
            "The file size isn't an exact number of integers." buttons {"Stop"} default button 1 cancel button 1 with icon stop
    end if

    -- Get the user to specify the destination file. Can be the original.
    set oldPath to theFile as text
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to ":"
    tell oldPath to set {rootPath, oldName} to {text 1 thru text item -2, text item -1}
    set AppleScript's text item delimiters to "."
    tell oldName to set newName to text 1 thru text item -2 & " (sorted copy)." & text item -1
    set AppleScript's text item delimiters to astid
    set newFile to ¬
        (choose file name with prompt "Save the sorted result as…" default name newName default location (rootPath as alias))
    -- If the original wasn't chosen, copy the data to the new location.
    -- There are simpler ways to copy a file, but this still practically instantaneous
    -- and definitely only involves maxChunkSize bytes at a time.
    if (newFile as text is not oldPath) then
        set readRef to (open for access theFile)
        set writeRef to (open for access newFile with write permission)
        try
            set eof writeRef to 0
            repeat with i from 1 to fileSize by maxChunkSize
                set d to (read readRef for maxChunkSize as data)
                write d as data to writeRef
            end repeat
            close access writeRef
            close access readRef
        on error errMsg
            close access writeRef
            close access readRef
            display dialog errMsg buttons {"Stop"} default button 1 cancel button 1 with icon stop
        end try
        set theFile to newFile
    end if

    -- Open the target file with write permission and perform the sort.
    set o's fRef to (open for access theFile with write permission)
    try
        -- Handler parameters: first-byte indices of the first and last integers in the file.
        if (fileSize > maxChunkSize) then
            tell o to qsrt(1, fileSize + 1 - integerSize)
        else
            tell o to sortInMemory(1, fileSize + 1 - integerSize)
        end if

        close access o's fRef
    on error errMsg
        close access o's fRef
        display dialog errMsg buttons {"Stop"} default button 1 cancel button 1 with icon stop
    end try

    -- Return the specifier for the sorted file.
    return theFile
end externalSort

set theFile to (path to desktop as text) & "Test.dat"
set sortedFile to externalSort(theFile)
