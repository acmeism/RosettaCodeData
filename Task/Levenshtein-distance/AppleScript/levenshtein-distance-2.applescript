-- levenshtein :: String -> String -> Int
on levenshtein(sa, sb)
    set {s1, s2} to {characters of sa, characters of sb}

    script
        on |λ|(ns, c)
            script minPath
                on |λ|(z, c1xy)
                    set {c1, x, y} to c1xy
                    minimum({y + 1, z + 1, x + fromEnum(c1 is not c)})
                end |λ|
            end script

            set {n, ns1} to uncons(ns)
            scanl(minPath, n + 1, zip3(s1, ns, ns1))
        end |λ|
    end script

    |last|(foldl(result, enumFromTo(0, length of s1), s2))
end levenshtein

-- TEST -----------------------------------------------------------------------
on run
    script test
        on |λ|(xs)
            levenshtein(item 1 of xs, item 2 of xs)
        end |λ|
    end script

    map(test, [["kitten", "sitting"], ["sitting", "kitten"], ¬
        ["rosettacode", "raisethysword"], ["raisethysword", "rosettacode"]])

    --> {3, 3, 8, 8}
end run


-- GENERIC FUNCTIONS -----------------------------------------------------------

-- enumFromTo :: Enum a => a -> a -> [a]
on enumFromTo(m, n)
    set {intM, intN} to {fromEnum(m), fromEnum(n)}

    if intM > intN then
        set d to -1
    else
        set d to 1
    end if
    set lst to {}
    if class of m is text then
        repeat with i from intM to intN by d
            set end of lst to chr(i)
        end repeat
    else
        repeat with i from intM to intN by d
            set end of lst to i
        end repeat
    end if
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

-- fromEnum :: Enum a => a -> Int
on fromEnum(x)
    set c to class of x
    if c is boolean then
        if x then
            1
        else
            0
        end if
    else if c is text then
        if x ≠ "" then
            id of x
        else
            missing value
        end if
    else
        x as integer
    end if
end fromEnum

-- last :: [a] -> a
on |last|(xs)
    if length of xs > 0 then
        item -1 of xs
    else
        missing value
    end if
end |last|

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

-- minimum :: [a] -> a
on minimum(xs)
    script min
        on |λ|(a, x)
            if x < a or a is missing value then
                x
            else
                a
            end if
        end |λ|
    end script

    foldl(min, missing value, xs)
end minimum

-- scanl :: (b -> a -> b) -> b -> [a] -> [b]
on scanl(f, startValue, xs)
    tell mReturn(f)
        set v to startValue
        set lng to length of xs
        set lst to {startValue}
        repeat with i from 1 to lng
            set v to |λ|(v, item i of xs, i, xs)
            set end of lst to v
        end repeat
        return lst
    end tell
end scanl

-- uncons :: [a] -> Maybe (a, [a])
on uncons(xs)
    if length of xs > 0 then
        {item 1 of xs, rest of xs}
    else
        missing value
    end if
end uncons

-- zip3 :: [a] -> [b] -> [c] -> [(a, b, c)]
on zip3(xs, ys, zs)
    script
        on |λ|(x, i)
            [x, item i of ys, item i of zs]
        end |λ|
    end script

    map(result, items 1 thru ¬
        minimum({length of xs, length of ys, length of zs}) of xs)
end zip3
