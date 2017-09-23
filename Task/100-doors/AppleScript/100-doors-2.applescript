-- FINAL DOOR STATES ---------------------------------------------------------

-- finalDoors :: Int -> [(Int, Bool)]
on finalDoors(n)

    -- toggledCorridor :: [(Int, Bool)] -> (Int, Bool) -> Int -> [(Int, Bool)]
    script toggledCorridor
        on |λ|(a, _, k)

            -- perhapsToggled :: Bool -> Int -> Bool
            script perhapsToggled
                on |λ|(x, i)
                    if i mod k = 0 then
                        {i, not item 2 of x}
                    else
                        {i, item 2 of x}
                    end if
                end |λ|
            end script

            map(perhapsToggled, a)
        end |λ|
    end script

    set xs to enumFromTo(1, n)

    foldl(toggledCorridor, ¬
        zip(xs, replicate(n, {false})), xs)
end finalDoors

-- TEST ----------------------------------------------------------------------
on run
    -- isOpenAtEnd :: (Int, Bool) -> Bool
    script isOpenAtEnd
        on |λ|(door)
            (item 2 of door)
        end |λ|
    end script

    -- doorNumber :: (Int, Bool) -> Int
    script doorNumber
        on |λ|(door)
            (item 1 of door)
        end |λ|
    end script

    map(doorNumber, filter(isOpenAtEnd, finalDoors(100)))

    --> {1, 4, 9, 16, 25, 36, 49, 64, 81, 100}
end run


-- GENERIC FUNCTIONS ---------------------------------------------------------

-- enumFromTo :: Int -> Int -> [Int]
on enumFromTo(m, n)
    if n < m then
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

-- foldl :: (a -> b -> a) -> a -> [b] -> a
on foldl(f, startValue, xs)
    tell mReturn(f)
        set v to startValue
        set lng to length of xs
        repeat with i from 1 to lng
            set v to |λ|(v, item i of xs, i, xs)
        end repeat
        return v
    end tell
end foldl

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

-- min :: Ord a => a -> a -> a
on min(x, y)
    if y < x then
        y
    else
        x
    end if
end min

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

-- replicate :: Int -> a -> [a]
on replicate(n, a)
    set out to {}
    if n < 1 then return out
    set dbl to {a}

    repeat while (n > 1)
        if (n mod 2) > 0 then set out to out & dbl
        set n to (n div 2)
        set dbl to (dbl & dbl)
    end repeat
    return out & dbl
end replicate

-- zip :: [a] -> [b] -> [(a, b)]
on zip(xs, ys)
    set lng to min(length of xs, length of ys)
    set lst to {}
    repeat with i from 1 to lng
        set end of lst to {item i of xs, item i of ys}
    end repeat
    return lst
end zip
