-- perfect :: integer -> bool
on perfect(n)

    -- isFactor :: integer -> bool
    script isFactor
        on lambda(x)
            n mod x = 0
        end lambda
    end script

    -- quotient :: number -> number
    script quotient
        on lambda(x)
            n / x
        end lambda
    end script

    -- sum :: number -> number -> number
    script sum
        on lambda(a, b)
            a + b
        end lambda
    end script

    -- Integer factors of n below the square root
    set lows to filter(isFactor, range(1, (n ^ (1 / 2)) as integer))

    -- low and high factors (quotients of low factors) tested for perfection
    (n > 1) and (foldl(sum, 0, (lows & map(quotient, lows))) / 2 = n)
end perfect


-- TEST

on run

    filter(perfect, range(1, 10000))

    --> {6, 28, 496, 8128}

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
