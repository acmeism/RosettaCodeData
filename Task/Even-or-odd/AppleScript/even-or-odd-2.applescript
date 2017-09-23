-- even :: Integral a => a -> Bool
on even(n)
    n mod 2 = 0
end even

-- odd :: Integral a => a -> Bool
on odd(n)
    not even(n)
end odd


-- GENERIC FUNCTIONS FOR TEST ----------------------------------

-- filter :: (a -> Bool) -> [a] -> [a]
on filter(f, xs)
    tell mReturn(f)
        set lst to {}
        set lng to length of xs
        repeat with i from 1 to lng
            set v to item i of xs
            if lambda(v, i, xs) then set end of lst to v
        end repeat
        return lst
    end tell
end filter

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


-- TEST ---------------------------------------------------------
on run
    set xs to [-6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6]

    {filter(even, xs), filter(odd, xs)}
end run
