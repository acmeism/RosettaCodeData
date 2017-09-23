use framework "Foundation"

-- sort :: [a] -> [a]
on sort(lst)
    ((current application's NSArray's arrayWithArray:lst)'s ¬
        sortedArrayUsingSelector:"compare:") as list
end sort

-- TEST -----------------------------------------------------------------------
on run

    map(sort, [[9, 1, 8, 2, 8, 3, 7, 0, 4, 6, 5], ¬
        ["alpha", "beta", "gamma", "delta", "epsilon", "zeta", "eta", ¬
            "theta", "iota", "kappa", "lambda", "mu"]])

end run


-- GENERIC FUNCTIONS  ---------------------------------------------------------

-- map :: (a -> b) -> [a] -> [b]
on map(f, xs)
    tell mReturn(f)
        set lng to length of xs
        set lst to {}
        repeat with i from 1 to lng
            set end of lst to |λ|(item i of xs, i, xs)
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
            property |λ| : f
        end script
    end if
end mReturn
