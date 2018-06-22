-- MULTIPLE DISTINCT OBJECTS -------------------------------------------------

-- nObjects Constructor -> Int -> [Object]
on nObjects(f, n)
    map(f, enumFromTo(1, n))
end nObjects

-- TEST ----------------------------------------------------------------------
on run
    -- someConstructor :: a -> Int -> b
    script someConstructor
        on |λ|(_, i)
            {index:i}
        end |λ|
    end script

    nObjects(someConstructor, 6)

    --> {{index:1}, {index:2}, {index:3}, {index:4}, {index:5}, {index:6}}
end run

-- GENERIC FUNCTIONS ---------------------------------------------------------

-- enumFromTo :: Int -> Int -> [Int]
on enumFromTo(m, n)
    if m > n then
        set d to -1
    else
        set d to 1
    end if
    set lst to {}
    repeat with i from m to n by d
        set end of lst to i
    end repeat
    return lst
end enumFromTo

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
