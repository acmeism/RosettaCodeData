-- fib :: Int -> Int
on fib(n)

    -- (Int, Int) -> (Int, Int)
    script lastTwo
        on lambda([a, b])
            [b, a + b]
        end lambda
    end script

    item 1 of foldl(lastTwo, {0, 1}, range(1, n))
end fib



-- TEST
on run

    fib(32)

    --> 2178309
end run



-- GENERIC FUNCTIONS

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
