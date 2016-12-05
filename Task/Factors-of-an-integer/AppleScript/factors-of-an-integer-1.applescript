-- integerFactors :: Int -> [Int]
on integerFactors(n)
    if n = 1 then
        {1}
    else
        set realRoot to n ^ (1 / 2)
        set intRoot to realRoot as integer
        set blnPerfectSquare to intRoot = realRoot

        -- isFactor :: Int -> Bool
        script isFactor
            on lambda(x)
                (n mod x) = 0
            end lambda
        end script

        -- Factors up to square root of n,
        set lows to filter(isFactor, range(1, intRoot))

        -- integerQuotient :: Int -> Int
        script integerQuotient
            on lambda(x)
                (n / x) as integer
            end lambda
        end script

        -- and quotients of these factors beyond the square root.
        lows & map(integerQuotient, ¬
            items (1 + (blnPerfectSquare as integer)) thru -1 of reverse of lows)
    end if
end integerFactors


-- TEST
on run

    integerFactors(120)

    --> {1, 2, 3, 4, 5, 6, 8, 10, 12, 15, 20, 24, 30, 40, 60, 120}
end run



-- GENERIC LIBRARY FUNCTIONS

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

-- range :: Int -> Int -> [Int]
on range(m, n)
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
