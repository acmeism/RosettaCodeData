-- ROMAN INTEGER STRINGS ------------------------------------------------------
-- roman :: Int -> String
on roman(n)
    set kvs to {["M", 1000], ["CM", 900], ["D", 500], ¬
        ["CD", 400], ["C", 100], ["XC", 90], ["L", 50], ["XL", 40], ¬
        ["X", 10], ["IX", 9], ["V", 5], ["IV", 4], ["I", 1]}

    script stringAddedValueDeducted
        on |λ|(balance, kv)
            set {k, v} to kv
            set {q, r} to quotRem(balance, v)
            if q > 0 then
                {r, concat(replicate(q, k))}
            else
                {r, ""}
            end if
        end |λ|
    end script

    concat(snd(mapAccumL(stringAddedValueDeducted, n, kvs)))
end roman

-- TEST -----------------------------------------------------------------------
on run

    map(roman, [2016, 1990, 2008, 2000, 1666])

    --> {"MMXVI", "MCMXC", "MMVIII", "MM", "MDCLXVI"}
end run


-- GENERIC LIBRARY FUNCTIONS --------------------------------------------------

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

-- 'The mapAccumL function behaves like a combination of map and foldl;
-- it applies a function to each element of a list, passing an
-- accumulating parameter from left to right, and returning a final
-- value of this accumulator together with the new list.' (see Hoogle)

-- mapAccumL :: (acc -> x -> (acc, y)) -> acc -> [x] -> (acc, [y])
on mapAccumL(f, acc, xs)
    script
        on |λ|(a, x)
            tell mReturn(f) to set pair to |λ|(item 1 of a, x)
            [item 1 of pair, (item 2 of a) & {item 2 of pair}]
        end |λ|
    end script

    foldl(result, [acc, {}], xs)
end mapAccumL

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

--  quotRem :: Integral a => a -> a -> (a, a)
on quotRem(m, n)
    {m div n, m mod n}
end quotRem

-- Egyptian multiplication - progressively doubling a list, appending
-- stages of doubling to an accumulator where needed for binary
-- assembly of a target length

-- replicate :: Int -> a -> [a]
on replicate(n, a)
    set out to {}
    if n < 1 then return out
    set dbl to {a}

    repeat while (n > 1)
        if (n mod 2) > 0 then set out to out & dbl
        set n to (n div 2)
        set dbl to (dbl & dbl)
    end repeat
    return out & dbl
end replicate

-- snd :: (a, b) -> b
on snd(xs)
    if class of xs is list and length of xs = 2 then
        item 2 of xs
    else
        missing value
    end if
end snd
