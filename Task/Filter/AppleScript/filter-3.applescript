-------------------------- FILTER --------------------------

-- filter :: (a -> Bool) -> [a] -> [a]
on filter(f, xs)
    tell mReturn(f)
        set lst to {}
        set lng to length of xs
        repeat with i from 1 to lng
            set v to item i of xs
            if |λ|(v, i, xs) then set end of lst to v
        end repeat
        return lst
    end tell
end filter


--------------------------- TEST ---------------------------
on run
    filter(even, {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10})

    --> {0, 2, 4, 6, 8, 10}
end run


-------------------- GENERIC FUNCTIONS ---------------------

-- even :: Int -> Bool
on even(x)
    0 = x mod 2
end even


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
