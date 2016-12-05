-- finalDoors :: Int -> [(Int, Bool)]
on finalDoors(n)

    -- toggledCorridor :: [(Int, Bool)] -> (Int, Bool) -> Int -> [(Int, Bool)]
    script toggledCorridor
        on lambda(a, _, k)

            -- perhapsToggled :: Bool -> Int -> Bool
            script perhapsToggled
                on lambda(x, i)
                    if i mod k = 0 then
                        {i, not item 2 of x}
                    else
                        {i, item 2 of x}
                    end if
                end lambda
            end script

            map(perhapsToggled, a)
        end lambda
    end script

    set lstRange to range(1, n)

    foldl(toggledCorridor, ¬
        zip(lstRange, replicate(n, {false})), lstRange)
end finalDoors

-- TEST
on run
    -- isOpenAtEnd :: (Int, Bool) -> Bool
    script isOpenAtEnd
        on lambda(door)
            (item 2 of door)
        end lambda
    end script

    -- doorNumber :: (Int, Bool) -> Int
    script doorNumber
        on lambda(door)
            (item 1 of door)
        end lambda
    end script

    map(doorNumber, filter(isOpenAtEnd, finalDoors(100)))

    --> {1, 4, 9, 16, 25, 36, 49, 64, 81, 100}
end run



-- GENERIC FUNCTIONS

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

-- foldl :: (a -> b -> a) -> a -> [b] -> a
on foldl(f, startValue, xs)
    tell mReturn(f)
        set v to startValue
        set lng to length of xs
        repeat with i from 1 to lng
            set v to lambda(v, item i of xs, i, xs)
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
            set end of lst to lambda(item i of xs, i, xs)
        end repeat
        return lst
    end tell
end map

-- zip :: [a] -> [b] -> [(a, b)]
on zip(xs, ys)
    script pair
        on lambda(x, i)
            [x, item i of ys]
        end lambda
    end script

    if length of xs = length of ys then
        map(pair, xs)
    else
        missing value
    end if
end zip

-- Egyptian multiplication - progressively doubling a list, appending
-- stages of doubling to an accumulator where needed for binary
-- assembly of a target length

-- replicate :: Int -> a -> [a]
on replicate(n, a)
    if class of a is list then
        set out to {}
    else
        set out to ""
    end if
    if n < 1 then return out
    set dbl to a

    repeat while (n > 1)
        if (n mod 2) > 0 then set out to out & dbl
        set n to (n div 2)
        set dbl to (dbl & dbl)
    end repeat
    return out & dbl
end replicate

-- range :: Int -> Int -> [Int]
on range(m, n)
    set d to 1
    if n < m then set d to -1
    set lst to {}
    repeat with i from m to n by d
        set end of lst to i
    end repeat
    return lst
end range

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
