on quickselect(theList, l, r, k)
    script o
        property lst : theList's items -- Shallow copy.
    end script

    repeat
        -- Median-of-3 pivot selection.
        set leftValue to item l of o's lst
        set rightValue to item r of o's lst
        set pivot to item ((l + r) div 2) of o's lst
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

        -- Initialise pivot store indices and swap the already compared outer values here if necessary.
        set pLeft to l - 1
        set pRight to r + 1
        if (leftGreaterThanRight) then
            set item r of o's lst to leftValue
            set item l of o's lst to rightValue
            if (leftValue = pivot) then
                set pRight to r
            else if (rightValue = pivot) then
                set pLeft to l
            end if
        else
            if (leftValue = pivot) then set pLeft to l
            if (rightValue = pivot) then set pRight to r
        end if

        -- Continue three-way partitioning.
        set i to l + 1
        set j to r - 1
        repeat until (i > j)
            set leftValue to item i of o's lst
            repeat while (leftValue < pivot)
                set i to i + 1
                set leftValue to item i of o's lst
            end repeat

            set rightValue to item j of o's lst
            repeat while (rightValue > pivot)
                set j to j - 1
                set rightValue to item j of o's lst
            end repeat

            if (j > i) then
                if (leftValue = pivot) then
                    set pRight to pRight - 1
                    if (pRight > j) then
                        set leftValue to item pRight of o's lst
                        set item pRight of o's lst to pivot
                    end if
                end if
                if (rightValue = pivot) then
                    set pLeft to pLeft + 1
                    if (pLeft < i) then
                        set rightValue to item pLeft of o's lst
                        set item pLeft of o's lst to pivot
                    end if
                end if
                set item j of o's lst to leftValue
                set item i of o's lst to rightValue
            else if (i > j) then
                exit repeat
            end if

            set i to i + 1
            set j to j - 1
        end repeat
        -- Swap stored pivot(s) into a central partition.
        repeat with p from l to pLeft
            if (j > pLeft) then
                set item p of o's lst to item j of o's lst
                set item j of o's lst to pivot
                set j to j - 1
            else
                set j to p - 1
                exit repeat
            end if
        end repeat
        repeat with p from r to pRight by -1
            if (i < pRight) then
                set item p of o's lst to item i of o's lst
                set item i of o's lst to pivot
                set i to i + 1
            else
                set i to p + 1
                exit repeat
            end if
        end repeat

        -- If k's in either of the outer partitions, repeat for that partition. Othewise return the item in slot k.
        if (k ≥ i) then
            set l to i
        else if (k ≤ j) then
            set r to j
        else
            return item k of o's lst
        end if
    end repeat
end quickselect

-- Task code:
set theVector to {9, 8, 7, 6, 5, 0, 1, 2, 3, 4}
set selected to {}
set vectorLength to (count theVector)
repeat with i from 1 to vectorLength
    set end of selected to quickselect(theVector, 1, vectorLength, i)
end repeat
return selected
