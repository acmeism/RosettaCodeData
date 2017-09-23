on summed(a, b)
    a + b
end summed

on product(a, b)
    a * b
end product

-- TEST -----------------------------------------------------------------------
on run

    set xs to enumFromTo(1, 10)

    {xs, ¬
        {sum:foldl(summed, 0, xs)}, ¬
        {product:foldl(product, 1, xs)}}

    --> {{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}, {sum:55}, {product:3628800}}

end run

-- GENERIC FUNCTIONS ----------------------------------------------------------

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
