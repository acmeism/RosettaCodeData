------ TWO APPROACHES – SUM OVER MAP, AND DIRECT FOLD ----

-- sumOfSquares :: Num a => [a] -> a
on sumOfSquares(xs)
    script squared
        on |λ|(x)
            x ^ 2
        end |λ|
    end script

    sum(map(squared, xs))
end sumOfSquares


-- sumOfSquares2 :: Num a => [a] -> a
on sumOfSquares2(xs)
    script plusSquare
        on |λ|(a, x)
            a + x ^ 2
        end |λ|
    end script

    foldl(plusSquare, 0, xs)
end sumOfSquares2


--------------------------- TEST -------------------------
on run
    set xs to [3, 1, 4, 1, 5, 9]

    {sumOfSquares(xs), sumOfSquares2(xs)}

    -- {133.0, 133.0}
end run


-------------------- GENERIC FUNCTIONS -------------------

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


-- sum :: Num a => [a] -> a
on sum(xs)
    script add
        on |λ|(a, b)
            a + b
        end |λ|
    end script

    foldl(add, 0, xs)
end sum
