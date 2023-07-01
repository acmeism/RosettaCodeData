-- PROPER DIVISORS -----------------------------------------------------------

-- properDivisors :: Int -> [Int]
on properDivisors(n)
    if n = 1 then
        {1}
    else
        set realRoot to n ^ (1 / 2)
        set intRoot to realRoot as integer
        set blnPerfectSquare to intRoot = realRoot

        -- isFactor :: Int -> Bool
        script isFactor
            on |λ|(x)
                n mod x = 0
            end |λ|
        end script

        -- Factors up to square root of n,
        set lows to filter(isFactor, enumFromTo(1, intRoot))

        -- and quotients of these factors beyond the square root,

        -- integerQuotient :: Int -> Int
        script integerQuotient
            on |λ|(x)
                (n / x) as integer
            end |λ|
        end script

        -- excluding n itself (last item)
        items 1 thru -2 of (lows & map(integerQuotient, ¬
            items (1 + (blnPerfectSquare as integer)) thru -1 of reverse of lows))
    end if
end properDivisors


-- TEST ----------------------------------------------------------------------
on run
    -- numberAndDivisors :: Int -> [Int]
    script numberAndDivisors
        on |λ|(n)
            {num:n, divisors:properDivisors(n)}
        end |λ|
    end script

    -- maxDivisorCount :: Record -> Int -> Record
    script maxDivisorCount
        on |λ|(a, n)
            set intDivisors to length of properDivisors(n)

            if intDivisors ≥ divisors of a then
                {num:n, divisors:intDivisors}
            else
                a
            end if
        end |λ|
    end script

    {oneToTen:map(numberAndDivisors, ¬
        enumFromTo(1, 10)), mostDivisors:foldl(maxDivisorCount, ¬
        {num:0, divisors:0}, enumFromTo(1, 20000))} ¬

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
