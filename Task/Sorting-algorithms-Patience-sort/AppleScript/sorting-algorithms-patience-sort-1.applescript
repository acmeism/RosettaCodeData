-- In-place patience sort.
on patienceSort(theList, l, r) -- Sort items l thru r of theList.
    set listLen to (count theList)
    if (listLen < 2) then return
    -- Convert any negative and/or transposed range indices.
    if (l < 0) then set l to listLen + l + 1
    if (r < 0) then set r to listLen + r + 1
    if (l > r) then set {l, r} to {r, l}

    script o
        property lst : theList
        property piles : {}
    end script

    -- Build piles.
    repeat with i from l to r
        set v to o's lst's item i
        set unplaced to true
        repeat with thisPile in o's piles
            if (v > thisPile's end) then
            else
                set thisPile's end to v
                set unplaced to false
                exit repeat
            end if
        end repeat
        if (unplaced) then set o's piles's end to {v}
    end repeat

    -- Remove successive lowest end values to the original list.
    set pileCount to (count o's piles)
    repeat with i from l to r
        set min to o's piles's beginning's end
        set minPile to 1
        repeat with j from 2 to pileCount
            set v to o's piles's item j's end
            if (v < min) then
                set min to v
                set minPile to j
            end if
        end repeat

        set o's lst's item i to min
        if ((count o's piles's item minPile) > 1) then
            set o's piles's item minPile to o's piles's item minPile's items 1 thru -2
        else
            set o's piles's item minPile to missing value
            set o's piles to o's piles's lists
            set pileCount to pileCount - 1
        end if
    end repeat

    return -- nothing
end patienceSort
property sort : patienceSort

local aList
set aList to {62, 86, 59, 65, 92, 85, 71, 71, 27, -52, 67, 59, 65, 80, 3, 65, 2, 46, 83, 72, 47, 5, 26, 18, 63}
sort(aList, 1, -1)
return aList
