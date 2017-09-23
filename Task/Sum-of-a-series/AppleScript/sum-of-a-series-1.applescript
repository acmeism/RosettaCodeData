-- SUM OF SERIES -------------------------------------------------------------

-- seriesSum :: Num a => (a -> a) -> [a] -> a
on seriesSum(f, xs)
    set mf to mReturn(f)
    script
        on |λ|(a, x)
            a + (mf's |λ|(x))
        end |λ|
    end script

    foldl(result, 0, xs)
end seriesSum


-- TEST ----------------------------------------------------------------------

on inverseSquare(x)
    1 / (x ^ 2)
end inverseSquare

on run
    seriesSum(inverseSquare, enumFromTo(1, 1000))

    --> 1.643934566682
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
