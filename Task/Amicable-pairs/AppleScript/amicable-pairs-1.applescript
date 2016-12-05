-- amicablePairsUpTo :: Int -> Int
on amicablePairsUpTo(max)

    -- amicable :: [Int] -> Int -> Int -> [Int] -> [Int]
    script amicable
        on lambda(lstAccumulator, m, n, lstSums)
            if (m > n) and (m ≤ max) and ((item m of lstSums) = n) then
                lstAccumulator & [[n, m]]
            else
                lstAccumulator
            end if
        end lambda
    end script

    -- divisorsSummed :: Int -> Int
    script divisorsSummed
        -- sum :: Int -> Int -> Int
        script sum
            on lambda(a, b)
                a + b
            end lambda
        end script

        on lambda(n)
            foldl(sum, 0, properDivisors(n))
        end lambda
    end script

    foldl(amicable, [], ¬
        map(divisorsSummed, range(1, max)))
end amicablePairsUpTo


-- TEST

on run

    amicablePairsUpTo(20000)

end run


-- PROPER DIVISORS

-- properDivisors :: Int -> [Int]
on properDivisors(n)

    -- isFactor :: Int -> Bool
    script isFactor
        on lambda(x)
            n mod x = 0
        end lambda
    end script

    -- integerQuotient :: Int -> Int
    script integerQuotient
        on lambda(x)
            (n / x) as integer
        end lambda
    end script

    if n = 1 then
        {1}
    else
        set realRoot to n ^ (1 / 2)
        set intRoot to realRoot as integer
        set blnPerfectSquare to intRoot = realRoot

        -- Factors up to square root of n,
        set lows to filter(isFactor, range(1, intRoot))

        -- and quotients of these factors beyond the square root,
        -- excluding n itself (last item)
        items 1 thru -2 of (lows & map(integerQuotient, ¬
            items (1 + (blnPerfectSquare as integer)) thru -1 of reverse of lows))
    end if
end properDivisors


---------------------------------------------------------------------------

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
