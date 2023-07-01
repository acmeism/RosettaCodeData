----------------------- DOT PRODUCT -----------------------

-- dotProduct :: [Number] -> [Number] -> Number
on dotProduct(xs, ys)
    if length of xs = length of ys then
        sum(zipWith(my mul, xs, ys))
    else
        missing value -- arrays of differing dimension
    end if
end dotProduct


-------------------------- TEST ---------------------------
on run

    dotProduct([1, 3, -5], [4, -2, -1])

    --> 3
end run


-------------------- GENERIC FUNCTIONS --------------------

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


-- min :: Ord a => a -> a -> a
on min(x, y)
    if y < x then
        y
    else
        x
    end if
end min


-- mul :: Num -> Num -> Num
on mul(a, b)
    a * b
end mul


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


-- sum :: [Number] -> Number
on sum(xs)
    script add
        on |λ|(a, b)
            a + b
        end |λ|
    end script

    foldl(add, 0, xs)
end sum


-- zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
on zipWith(f, xs, ys)
    set lng to min(length of xs, length of ys)
    set lst to {}
    tell mReturn(f)
        repeat with i from 1 to lng
            set end of lst to |λ|(item i of xs, item i of ys)
        end repeat
        return lst
    end tell
end zipWith
