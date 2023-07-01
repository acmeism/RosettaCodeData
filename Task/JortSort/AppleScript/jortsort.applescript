use AppleScript version "2.4"
use framework "Foundation"
use scripting additions


------------------------- JORTSORT -------------------------


-- jortSort :: Ord a => [a] -> Bool
on jortSort(xs)
    xs = sort(xs)
end jortSort


--------------------------- TEST ---------------------------
on run
    map(jortSort, {{4, 5, 1, 3, 2}, {1, 2, 3, 4, 5}})

    --> {false, true}
end run


------------------------- GENERIC --------------------------

-- map :: (a -> b) -> [a] -> [b]
on map(f, xs)
    -- The list obtained by applying f
    -- to each element of xs.
    tell mReturn(f)
        set lng to length of xs
        set lst to {}
        repeat with i from 1 to lng
            set end of lst to |λ|(item i of xs, i, xs)
        end repeat
        return lst
    end tell
end map


-- mReturn :: First-class m => (a -> b) -> m (a -> b)
on mReturn(f)
    -- 2nd class handler function lifted into 1st class script wrapper.
    if script is class of f then
        f
    else
        script
            property |λ| : f
        end script
    end if
end mReturn


-- sort :: Ord a => [a] -> [a]
on sort(xs)
    ((current application's NSArray's arrayWithArray:xs)'s ¬
        sortedArrayUsingSelector:"compare:") as list
end sort
