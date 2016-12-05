-- levenshtein :: String -> String -> Int
on levenshtein(sa, sb)
    set {s1, s2} to {characters of sa, characters of sb}

    script
        on lambda(ns, c)
            script minPath
                on lambda(z, c1xy)
                    set {c1, x, y} to c1xy
                    minimum({y + 1, z + 1, x + fromEnum(c1 is not c)})
                end lambda
            end script

            set {n, ns1} to uncons(ns)
            scanl(minPath, n + 1, zip3(s1, ns, ns1))
        end lambda
    end script

    |last|(foldl(result, range(0, length of s1), s2))
end levenshtein


-- TEST ------------------------------------------------------------------------------

on run
    script test
        on lambda(xs)
            levenshtein(item 1 of xs, item 2 of xs)
        end lambda
    end script

    map(test, [["kitten", "sitting"], ["sitting", "kitten"], ¬
        ["rosettacode", "raisethysword"], ["raisethysword", "rosettacode"]])

    --> {3, 3, 8, 8}
end run


-- GENERIC FUNCTIONS ------------------------------------------------------------

-- minimum :: [a] -> a
on minimum(xs)
    script min
        on lambda(a, x)
            if x < a or a is missing value then
                x
            else
                a
            end if
        end lambda
    end script

    foldl(min, missing value, xs)
end minimum

-- fromEnum :: Enum a => a -> Int
on fromEnum(x)
    if class of x is boolean then
        x as integer
    else
        id of x
    end if
end fromEnum

-- uncons :: [a] -> Maybe (a, [a])
on uncons(xs)
    if length of xs > 0 then
        {item 1 of xs, rest of xs}
    else
        missing value
    end if
end uncons

-- scanl :: (b -> a -> b) -> b -> [a] -> [b]
on scanl(f, startValue, xs)
    tell mReturn(f)
        set v to startValue
        set lng to length of xs
        set lst to {startValue}
        repeat with i from 1 to lng
            set v to lambda(v, item i of xs, i, xs)
            set end of lst to v
        end repeat
        return lst
    end tell
end scanl

-- zip3 :: [a] -> [b] -> [c] -> [(a, b, c)]
on zip3(xs, ys, zs)
    script
        on lambda(x, i)
            [x, item i of ys, item i of zs]
        end lambda
    end script

    map(result, items 1 thru ¬
        minimum({length of xs, length of ys, length of zs}) of xs)
end zip3

-- last :: [a] -> a
on |last|(xs)
    if length of xs > 0 then
        item -1 of xs
    else
        missing value
    end if
end |last|

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

-- map :: (a -> b) -> [a] -> [b]
on map(f, xs)
    tell mReturn(f)
        set lng to length of xs
        set lst to {}
        repeat with i from 1 to lng
            set end of lst to lambda(item i of xs, i, xs)
        end repeat
        return lst
    end tell
end map

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
