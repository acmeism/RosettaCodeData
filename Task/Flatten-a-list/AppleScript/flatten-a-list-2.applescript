-- flatten :: Tree a -> [a]
on flatten(t)
    if class of t is list then
        concatMap(flatten, t)
    else
        t
    end if
end flatten

--------------------------- TEST ---------------------------
on run

    flatten([[1], 2, [[3, 4], 5], [[[]]], [[[6]]], 7, 8, []])

    --> {1, 2, 3, 4, 5, 6, 7, 8}
end run


-------------------- GENERIC FUNCTIONS ---------------------

-- concatMap :: (a -> [b]) -> [a] -> [b]
on concatMap(f, xs)
    set lst to {}
    set lng to length of xs
    tell mReturn(f)
        repeat with i from 1 to lng
            set lst to (lst & |λ|(item i of xs, i, xs))
        end repeat
    end tell
    return lst
end concatMap

-- Lift 2nd class handler function into 1st class script wrapper
-- mReturn :: Handler -> Script
on mReturn(f)
    if class of f is script then
        f
    else
        script
            property |λ| : f
        end script
    end if
end mReturn
