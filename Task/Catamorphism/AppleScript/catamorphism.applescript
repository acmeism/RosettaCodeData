-- CATAMORPHISMS --------------------------------------------------

-- the arguments available to the called function f(a, x, i, l) are
-- a: current accumulator value
-- x: current item in list
-- i: [ 1-based index in list ] optional
-- l: [ a reference to the list itself ] optional

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

-- the arguments available to the called function f(a, x, i, l) are
-- a: current accumulator value
-- x: current item in list
-- i: [ 1-based index in list ] optional
-- l: [ a reference to the list itself ] optional

-- foldr :: (a -> b -> a) -> a -> [b] -> a
on foldr(f, startValue, xs)
    tell mReturn(f)
        set v to startValue
        set lng to length of xs
        repeat with i from lng to 1 by -1
            set v to |λ|(v, item i of xs, i, xs)
        end repeat
        return v
    end tell
end foldr


-- OTHER FUNCTIONS DEFINED IN TERMS OF FOLDL AND FOLDR ------------

-- concat :: [[a]] -> [a] | [String] -> String
on concat(xs)
    script append
        on |λ|(a, b)
            a & b
        end |λ|
    end script

    if length of xs > 0 and class of (item 1 of xs) is string then
        set unit to ""
    else
        set unit to {}
    end if
    foldl(append, unit, xs)
end concat

-- product :: Num a => [a] -> a
on product(xs)
    script
        on |λ|(a, b)
            a * b
        end |λ|
    end script

    foldr(result, 1, xs)
end product

-- sum :: Num a => [a] -> a
on sum(xs)
    script
        on |λ|(a, b)
            a + b
        end |λ|
    end script

    foldl(result, 0, xs)
end sum


-- TEST -----------------------------------------------------------
on run
    set xs to {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}

    {sum(xs), product(xs), concat(xs)}

    --> {55, 3628800, "10987654321"}
end run


-- GENERIC FUNCTION -----------------------------------------------

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
