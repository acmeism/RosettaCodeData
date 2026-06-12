(* List range rotation, wholly in-place. Negative 'amount' = left rotation, positive = right.
    Method:
        Adjust the specified rotation amount to get a positive, < list length, left-rotation figure.
        If rotating by only 1 in either direction, do it in the obvious way.
        Otherwise reverse the range's leftmost 'amount' items, reverse the others, then reverse the lot.
*)
on rotate(theList, l, r, amount)
    set listLength to (count theList)
    if (listLength < 2) then return
    if (l < 0) then set l to listLength + l + 1
    if (r < 0) then set r to listLength + r + 1
    if (l > r) then set {l, r} to {r, l}

    script o
        property lst : theList

        on rotate1(a, z, step)
            set v to my lst's item a
            repeat with i from (a + step) to z by step
                set my lst's item (i - step) to my lst's item i
            end repeat
            set my lst's item z to v
        end rotate1

        on |reverse|(i, j)
            repeat with i from i to ((i + j - 1) div 2)
                set v to my lst's item i
                set my lst's item i to my lst's item j
                set my lst's item j to v
                set j to j - 1
            end repeat
        end |reverse|
    end script

    set rangeLength to r - l + 1
    set amount to (rangeLength + rangeLength - amount) mod rangeLength
    if (amount is 1) then
        tell o to rotate1(l, r, 1) -- Rotate left by 1.
    else if (amount = rangeLength - 1) then
        tell o to rotate1(r, l, -1) -- Rotate right by 1.
    else if (amount > 0) then
        tell o to |reverse|(l, l + amount - 1)
        tell o to |reverse|(l + amount, r)
        tell o to |reverse|(l, r)
    end if
end rotate

-- Task code:
local lst
set lst to {1, 2, 3, 4, 5, 6, 7, 8, 9}
-- Left-rotate all items (1 thru -1) by three places.
rotate(lst, 1, -1, -3)
return lst
