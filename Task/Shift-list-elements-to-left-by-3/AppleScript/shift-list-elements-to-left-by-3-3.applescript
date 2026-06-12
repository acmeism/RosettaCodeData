(* List range rotation, in-place with temporary external storage. Negative 'amount' = left rotation, positive = right.
    Method:
        Adjust the specified amount to get a positive, < list length, left-rotation figure.
        Store the range's leftmost 'amount' items.
        Move the range's other items 'amount' places to the left.
        Move the stored items into the range's rightmost slots.
*)
on rotate(theList, l, r, amount)
    set listLength to (count theList)
    if (listLength < 2) then return
    if (l < 0) then set l to listLength + l + 1
    if (r < 0) then set r to listLength + r + 1
    if (l > r) then set {l, r} to {r, l}

    script o
        property lst : theList
        property storage : missing value
    end script

    set rangeLength to r - l + 1
    set amount to (rangeLength + rangeLength - amount) mod rangeLength
    if (amount is 0) then return
    set o's storage to o's lst's items l thru (l + amount - 1)
    repeat with i from (l + amount) to r
        set o's lst's item (i - amount) to o's lst's item i
    end repeat
    set j to r - amount
    repeat with i from 1 to amount
        set o's lst's item (j + i) to o's storage's item i
    end repeat
end rotate

-- Task code:
local lst
set lst to {1, 2, 3, 4, 5, 6, 7, 8, 9}
-- Left-rotate all items (1 thru -1) by three places.
rotate(lst, 1, -1, -3)
return lst
