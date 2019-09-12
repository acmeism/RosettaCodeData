-- factorial :: Int -> Int
on factorial(n)
    product(enumFromTo(1, n))
end factorial


-- binomialCoefficient :: Int -> Int -> Int
on binomialCoefficient(n, k)
    factorial(n) div (factorial(n - k) * (factorial(k)))
end binomialCoefficient

-- Or, by reduction:

-- binomialCoefficient2 :: Int -> Int -> Int
on binomialCoefficient2(n, k)
    product(enumFromTo(1 + k, n)) div (factorial(n - k))
end binomialCoefficient2


-- TEST -----------------------------------------------------
on run

    {binomialCoefficient(5, 3), binomialCoefficient2(5, 3)}

    --> {10, 10}
end run


-- GENERAL -------------------------------------------------

-- enumFromTo :: Int -> Int -> [Int]
on enumFromTo(m, n)
    if m ≤ n then
        set lst to {}
        repeat with i from m to n
            set end of lst to i
        end repeat
        return lst
    else
        return {}
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
-- mReturn :: First-class m => (a -> b) -> m (a -> b)
on mReturn(f)
    if script is class of f then
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
