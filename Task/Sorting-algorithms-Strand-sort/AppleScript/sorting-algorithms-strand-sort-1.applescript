-- Return a deep copy of theList with items l thru r sorted ascending.
on strandSort(theList, l, r)
    -- Resolve negative and/or transposed range index parameters.
    set listLength to (count theList)
    if (l < 0) then set l to listLength + l + 1
    if (r < 0) then set r to listLength + r + 1
    if (l > r) then set {l, r} to {r, l}
    if ((l < 1) or (r > listLength)) then ¬
        error "strandSort(): range index parameter(s) outside list range."

    script o
        property src : missing value
        property dest : missing value
        property ranges : {}
    end script

    -- Arrange a copy of the list into "strands" of exisiting ascending order
    -- and get the strands' ranges within this arrangement.
    copy theList to o's src
    set i to l
    repeat until (i > r)
        set j to i
        set jVal to o's src's item j
        repeat with k from (j + 1) to r
            set kVal to o's src's item k
            if (kVal < jVal) then
            else
                set j to j + 1
                set o's src's item k to o's src's item j
                set o's src's item j to kVal
                set jVal to kVal
            end if
        end repeat
        set o's ranges's end to {i, j}
        set i to j + 1
    end repeat
    set rangeCount to (count o's ranges)
    if (rangeCount = 1) then return o's src -- Already in order.

    -- Merge the strands back and forth between this list and another duplicate.
    set o's dest to o's src's items
    repeat until (rangeCount = 1)
        set {o's src, o's dest} to {o's dest, o's src}
        set k to l
        repeat with rr from 2 to rangeCount by 2
            set {{i, ix}, {j, jx}} to o's ranges's items (rr - 1) thru rr
            set o's ranges's item (rr - 1) to {i, jx}
            set o's ranges's item rr to missing value

            set iVal to o's src's item i
            set jVal to o's src's item j
            repeat until (k > jx)
                if (iVal > jVal) then
                    set o's dest's item k to jVal
                    set j to j + 1
                    if (j > jx) then
                        repeat with i from i to ix
                            set k to k + 1
                            set o's dest's item k to o's src's item i
                        end repeat
                    else
                        set jVal to o's src's item j
                    end if
                else
                    set o's dest's item k to iVal
                    set i to i + 1
                    if (i > ix) then
                        repeat with k from j to jx
                            set o's dest's item k to o's src's item k
                        end repeat
                    else
                        set iVal to o's src's item i
                    end if
                end if
                set k to k + 1
            end repeat
        end repeat
        if (rr < rangeCount) then
            set {i, ix} to o's ranges's end
            repeat with k from i to ix
                set o's dest's item k to o's src's item k
            end repeat
        end if

        set o's ranges to o's ranges's lists
        set rangeCount to (rangeCount + 1) div 2
    end repeat

    return o's dest
end strandSort

strandSort({5, 1, 4, 37, 2, 0, 9, 6, -44, 3, 8, 7}, 1, -1)
