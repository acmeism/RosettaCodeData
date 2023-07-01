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

            set {n, ns1} to {item 1 of ns, rest of ns}
            scanl(minPath, n + 1, zip3(s1, ns, ns1))
        end |λ|
    end script

    last item of foldl(result, enumFromTo(0, length of s1), s2)
end levenshtein

--------------------------- TEST ---------------------------
on run
    script test
        on |λ|(tuple)
            set {sa, sb} to tuple

            levenshtein(sa, sb)
        end |λ|
    end script

    map(test, [["kitten", "sitting"], ["sitting", "kitten"], ¬
        ["rosettacode", "raisethysword"], ["raisethysword", "rosettacode"]])

    --> {3, 3, 8, 8}
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
    -- The list obtained by applying f
    -- to each element of xs.
    tell mReturn(f)
        set lng to length of xs
        set lst to {}
        repeat with i from 1 to lng
            set end of lst to |λ|(item i of xs, i, xs)
        end repeat
        return lst
    end tell
end map


-- minimum :: Ord a => [a] -> a
on minimum(xs)
    set lng to length of xs
    if lng < 1 then return missing value
    set m to item 1 of xs
    repeat with x in xs
        set v to contents of x
        if v < m then set m to v
    end repeat
    return m
end minimum


-- mReturn :: First-class m => (a -> b) -> m (a -> b)
on mReturn(f)
    -- 2nd class handler function lifted into 1st class script wrapper.
    if script is class of f then
        f
    else
        script
            property |λ| : f
        end script
    end if
end mReturn


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


-- zip3 :: [a] -> [b] -> [c] -> [(a, b, c)]
on zip3(xs, ys, zs)
    script
        on |λ|(x, i)
            {x, item i of ys, item i of zs}
        end |λ|
    end script
    map(result, items 1 thru ¬
        minimum({length of xs, length of ys, length of zs}) of xs)
end zip3
