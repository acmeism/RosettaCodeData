------------------------ FACTORIAL -----------------------

-- factorial :: Int -> Int
on factorial(x)

    product(enumFromTo(1, x))

end factorial


--------------------------- TEST -------------------------
on run

    factorial(11)

    --> 39916800

end run


-------------------- GENERIC FUNCTIONS -------------------

-- enumFromTo :: Int -> Int -> [Int]
on enumFromTo(m, n)
    if m ≤ n then
        set xs to {}
        repeat with i from m to n
            set end of xs to i
        end repeat
        xs
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


-- product :: [Num] -> Num
on product(xs)
    script multiply
        on |λ|(a, b)
            a * b
        end |λ|
    end script

    foldl(multiply, 1, xs)
end product
