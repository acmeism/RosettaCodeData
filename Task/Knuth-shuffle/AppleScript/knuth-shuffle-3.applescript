-- Fisher-Yates (aka Durstenfeld, aka Knuth) shuffle.
on shuffle(theList, l, r)
    set listLength to (count theList)
    if (listLength < 2) then return array
    if (l < 0) then set l to listLength + l + 1
    if (r < 0) then set r to listLength + r + 1
    if (l > r) then set {l, r} to {r, l}
    script o
        property lst : theList
    end script

    repeat with i from l to (r - 1)
        set j to (random number from i to r)
        set v to o's lst's item i
        set o's lst's item i to o's lst's item j
        set o's lst's item j to v
    end repeat

    return theList
end shuffle

local array
set array to {"Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot", "Golf", "Hotel", "India", "Juliett", "Kilo", "Lima", "Mike"}
-- Shuffle all items (1 thru -1).
shuffle(array, 1, -1)
