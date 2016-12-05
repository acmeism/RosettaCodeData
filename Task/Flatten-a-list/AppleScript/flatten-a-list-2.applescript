-- quickSort :: (Ord a) => [a] -> [a]
on quickSort(xs)
    set headTail to uncons(xs)
    if headTail is not missing value then
        set {h, t} to headTail

        -- lessOrEqual :: a -> Bool
        script lessOrEqual
            on lambda(x)
                x ≤ h
            end lambda
        end script

        set {less, more} to partition(lessOrEqual, t)

        quickSort(less) & h & quickSort(more)
    else
        xs
    end if
end quickSort


-- TEST
on run

    quickSort([11.8, 14.1, 21.3, 8.5, 16.7, 5.7])

    --> {5.7, 8.5, 11.8, 14.1, 16.7, 21.3}

end run



-- GENERIC FUNCTIONS

-- partition :: predicate -> List -> (Matches, nonMatches)
-- partition :: (a -> Bool) -> [a] -> ([a], [a])
on partition(f, xs)
    tell mReturn(f)
        set lst to {{}, {}}
        repeat with x in xs
            set v to contents of x
            set end of item ((lambda(v) as integer) + 1) of lst to v
        end repeat
        return {item 2 of lst, item 1 of lst}
    end tell
end partition

-- uncons :: [a] -> Maybe (a, [a])
on uncons(xs)
    if length of xs > 0 then
        {item 1 of xs, rest of xs}
    else
        missing value
    end if
end uncons

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
