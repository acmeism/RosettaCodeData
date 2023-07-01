-------------------- FIBONACCI SEQUENCE --------------------

-- fib :: Int -> Int
on fib(n)

    -- lastTwo : (Int, Int) -> (Int, Int)
    script lastTwo
        on |λ|([a, b])
            [b, a + b]
        end |λ|
    end script

    item 1 of foldl(lastTwo, {0, 1}, enumFromTo(1, n))
end fib


--------------------------- TEST ---------------------------
on run

    fib(32)

    --> 2178309
end run

-------------------- GENERIC FUNCTIONS ---------------------

-- enumFromTo :: Int -> Int -> [Int]
on enumFromTo(m, n)
    if m ≤ n then
        set lst to {}
        repeat with i from m to n
            set end of lst to i
        end repeat
        lst
    else
        {}
    end if
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
