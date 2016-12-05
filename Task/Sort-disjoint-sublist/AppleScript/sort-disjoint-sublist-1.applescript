use framework "Foundation" -- for basic NSArray sort

--  disjointSort :: [a] -> [Int] -> [a]
on disjointSort(xs, indices)

    -- Sequence of indices discarded
    set indicesSorted to my sort(indices)

    -- valueByIndex :: Int -> a
    script valueByIndex
        on lambda(i)
            item i of xs
        end lambda
    end script

    set subsetSorted to ¬
        sort(map(valueByIndex, indicesSorted))

    -- staticOrSorted :: a -> Int -> a
    script staticOrSorted
        on lambda(x, i)
            set iIndex to elemIndex(i, indicesSorted)
            if iIndex is missing value then
                x
            else
                item iIndex of subsetSorted
            end if
        end lambda
    end script

    -- Sorted subset re-stitched into unsorted remainder of list
    map(staticOrSorted, xs)

end disjointSort


--TEST

on run
    -- The indexing of AppleScript lists is 1-based
    -- so we use {7,2,8} in place of {6,1,7}

    disjointSort({7, 6, 5, 4, 3, 2, 1, 0}, {7, 2, 8})
end run



-- GENERIC FUNCTIONS

-- sort :: [a] -> [a]
on sort(lst)
    ((current application's NSArray's arrayWithArray:lst)'s ¬
        sortedArrayUsingSelector:"compare:") as list
end sort

-- elemIndex :: a -> [a] -> Maybe Int
on elemIndex(x, xs)
    set lng to length of xs
    repeat with i from 1 to lng
        if x = (item i of xs) then return i
    end repeat
    return missing value
end elemIndex

-- map :: (a -> b) -> [a] -> [b]
on map(f, xs)
    tell mReturn(f)
        set lng to length of xs
        set lst to {}
        repeat with i from 1 to lng
            set end of lst to lambda(item i of xs, i, xs)
        end repeat
        return lst
    end tell
end map

-- Lift 2nd class handler function into 1st class script wrapper
-- mReturn :: Handler -> Script
on mReturn(f)
    if class of f is script then
        f
    else
        script
            property lambda : f
        end script
    end if
end mReturn
