use AppleScript version "2.4"
use framework "Foundation"


------------------- COMMON SORTED ARRAY ------------------
on run
    sort(nub(concat({¬
        {5, 1, 3, 8, 9, 4, 8, 7}, ¬
        {3, 5, 9, 8, 4}, ¬
        {1, 3, 7, 9}})))
end run


-------------------- GENERIC FUNCTIONS -------------------

-- concat :: [[a]] -> [a]
on concat(xs)
    ((current application's NSArray's arrayWithArray:xs)'s ¬
        valueForKeyPath:"@unionOfArrays.self") as list
end concat


-- nub :: [a] -> [a]
on nub(xs)
    ((current application's NSArray's arrayWithArray:xs)'s ¬
        valueForKeyPath:"@distinctUnionOfObjects.self") as list
end nub


-- sort :: Ord a => [a] -> [a]
on sort(xs)
    ((current application's NSArray's arrayWithArray:xs)'s ¬
        sortedArrayUsingSelector:"compare:") as list
end sort
