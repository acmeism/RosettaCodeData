-- Sort items l thru r of theList in place, ascending.
on strandSort(theList, l, r)
    -- Deal with negative and/or transposed range index parameters.
    set listLength to (count theList)
    if (l < 0) then set l to listLength + l + 1
    if (r < 0) then set r to listLength + r + 1
    if (l > r) then set {l, r} to {r, l}
    if ((l < 1) or (r > listLength)) then error "strandSort(): range index parameter(s) outside list range."

    script o
        property dest : theList -- Original list.
        property src : my dest's items l thru r -- The items in the sort range.
        property ranges : {}
    end script

    -- Individually list-wrap the items in o's src to avoid having to
    -- hard-code their actual class in the line marked ** below.
    repeat with i from 1 to (r - l + 1)
        set o's src's item i to {o's src's item i}
    end repeat
    -- Extract "strands" of existing order from the sort range items
    -- and write the resulting runs over the range in the original list.
    set i to l
    repeat until (i > r)
        set j to i
        set jv to o's src's beginning's beginning -- The value in src's first sublist.
        set o's dest's item j to jv -- Store it in the next original-list slot
        set o's src's item 1 to missing value -- Replace the sublist with a placeholder.
        -- Do the same with any later values that are sequentially greater or equal.
        repeat with k from 2 to (count o's src)
            set kv to o's src's item k's beginning
            if (kv < jv) then
            else
                set j to j + 1
                set o's dest's item j to kv
                set jv to kv
                set o's src's item k to missing value
            end if
        end repeat
        set o's ranges's end to {i, j} -- Note this strand's range in the list.
        set o's src to o's src's lists -- Lose src's zapped sublists.  **
        set i to j + 1
    end repeat
    set strandCount to (count o's ranges)
    if (strandCount = 1) then return -- The input list was already in order.

    -- Work out how many passes the iterative merge will take and from this whether
    -- the auxiliary list has to be the source or the destination during the first pass.
    -- The destination in the final pass has to be the original list.
    set passCount to 0
    repeat while (2 ^ passCount < strandCount)
        set passCount to passCount + 1
    end repeat
    if (passCount mod 2 = 0) then
        set o's src to o's dest
        set o's dest to o's dest's items
    else
        set o's src to o's dest's items
    end if

    -- Merge the strands.
    repeat passCount times
        set k to l -- Destination index.
        repeat with rr from 2 to strandCount by 2 -- Per pair of ranges.
            set {{i, ix}, {j, jx}} to o's ranges's items (rr - 1) thru rr
            set o's ranges's item (rr - 1) to {i, jx}
            set o's ranges's item rr to missing value

            set iv to o's src's item i
            set jv to o's src's item j
            repeat until (k > jx)
                if (iv > jv) then
                    set o's dest's item k to jv
                    if (j < jx) then
                        set j to j + 1
                        set jv to o's src's item j
                    else
                        repeat with i from i to ix
                            set k to k + 1
                            set o's dest's item k to o's src's item i
                        end repeat
                    end if
                else
                    set o's dest's item k to iv
                    if (i < ix) then
                        set i to i + 1
                        set iv to o's src's item i
                    else
                        repeat with k from j to jx
                            set o's dest's item k to o's src's item k
                        end repeat
                    end if
                end if
                set k to k + 1
            end repeat
        end repeat
        if (rr < strandCount) then -- Odd range at the end of this pass?
            set {i, ix} to o's ranges's end
            repeat with k from i to ix
                set o's dest's item k to o's src's item k
            end repeat
        end if

        set o's ranges to o's ranges's lists
        set strandCount to (strandCount + 1) div 2
        set {o's src, o's dest} to {o's dest, o's src}
    end repeat

    return -- nothing.
end strandSort

local lst
set lst to {5, 1, 4, 37, 2, 0, 9, 6, -44, 3, 8, 7}
strandSort(lst, 1, -1)
return lst
