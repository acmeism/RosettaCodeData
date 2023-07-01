-- AMICABLE PAIRS ------------------------------------------------------------

-- amicablePairsUpTo :: Int -> Int
on amicablePairsUpTo(max)

    -- amicable :: [Int] -> Int -> Int -> [Int] -> [Int]
    script amicable
        on |λ|(a, m, n, lstSums)
            if (m > n) and (m ≤ max) and ((item m of lstSums) = n) then
                a & [[n, m]]
            else
                a
            end if
        end |λ|
    end script

    -- divisorsSummed :: Int -> Int
    script divisorsSummed
        -- sum :: Int -> Int -> Int
        script sum
            on |λ|(a, b)
                a + b
            end |λ|
        end script

        on |λ|(n)
            foldl(sum, 0, properDivisors(n))
        end |λ|
    end script

    foldl(amicable, {}, ¬
        map(divisorsSummed, enumFromTo(1, max)))
end amicablePairsUpTo


-- TEST ----------------------------------------------------------------------
on run

    amicablePairsUpTo(20000)

end run


-- PROPER DIVISORS -----------------------------------------------------------

-- properDivisors :: Int -> [Int]
on properDivisors(n)

    -- isFactor :: Int -> Bool
    script isFactor
        on |λ|(x)
            n mod x = 0
        end |λ|
    end script

    -- integerQuotient :: Int -> Int
    script integerQuotient
        on |λ|(x)
            (n / x) as integer
        end |λ|
    end script

    if n = 1 then
        {1}
    else
        set realRoot to n ^ (1 / 2)
        set intRoot to realRoot as integer
        set blnPerfectSquare to intRoot = realRoot

        -- Factors up to square root of n,
        set lows to filter(isFactor, enumFromTo(1, intRoot))

        -- and quotients of these factors beyond the square root,
        -- excluding n itself (last item)
        items 1 thru -2 of (lows & map(integerQuotient, ¬
            items (1 + (blnPerfectSquare as integer)) thru -1 of reverse of lows))
    end if
end properDivisors

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
