-- PERFECT NUMBERS -----------------------------------------------------------

-- perfect :: integer -> bool
on perfect(n)

    -- isFactor :: integer -> bool
    script isFactor
        on |λ|(x)
            n mod x = 0
        end |λ|
    end script

    -- quotient :: number -> number
    script quotient
        on |λ|(x)
            n / x
        end |λ|
    end script

    -- sum :: number -> number -> number
    script sum
        on |λ|(a, b)
            a + b
        end |λ|
    end script

    -- Integer factors of n below the square root
    set lows to filter(isFactor, enumFromTo(1, (n ^ (1 / 2)) as integer))

    -- low and high factors (quotients of low factors) tested for perfection
    (n > 1) and (foldl(sum, 0, (lows & map(quotient, lows))) / 2 = n)
end perfect


-- TEST ----------------------------------------------------------------------
on run

    filter(perfect, enumFromTo(1, 10000))

    --> {6, 28, 496, 8128}

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
