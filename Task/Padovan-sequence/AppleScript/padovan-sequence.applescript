--------------------- PADOVAN NUMBERS --------------------

-- padovans :: [Int]
on padovans()
    script f
        on |λ|(abc)
            set {a, b, c} to abc

            {a, {b, c, a + b}}
        end |λ|
    end script

    unfoldr(f, {1, 1, 1})
end padovans


-- padovanFloor :: [Int]
on padovanFloor()
    script f
        property p : 1.324717957245
        property s : 1.045356793253
        on |λ|(n)
            {floor(0.5 + ((p ^ (n - 1)) / s)), 1 + n}
        end |λ|
    end script

    unfoldr(f, 0)
end padovanFloor


-- padovanLSystem :: [String]
on padovanLSystem()
    script rule
        on |λ|(c)
            if "A" = c then
                "B"
            else if "B" = c then
                "C"
            else
                "AB"
            end if
        end |λ|
    end script

    script f
        on |λ|(s)
            {s, concatMap(rule, characters of s) as string}
        end |λ|
    end script

    unfoldr(f, "A")
end padovanLSystem


--------------------------- TEST -------------------------
on run
    unlines({"First 20 padovans:", ¬
        showList(take(20, padovans())), ¬
        "", ¬
        "The recurrence and floor-based functions", ¬
        "match over the first 64 terms:\n", ¬
        prefixesMatch(padovans(), padovanFloor(), 64), ¬
        "", ¬
        "First 10 L-System strings:", ¬
        showList(take(10, padovanLSystem())), ¬
        "", ¬
        "The lengths of the first 32 L-System", ¬
        "strings match the Padovan sequence:\n", ¬
        prefixesMatch(padovans(), fmap(|length|, padovanLSystem()), 32)})
end run


-- prefixesMatch :: [a] -> [a] -> Bool
on prefixesMatch(xs, ys, n)
    take(n, xs) = take(n, ys)
end prefixesMatch


------------------------- GENERIC ------------------------

-- concatMap :: (a -> [b]) -> [a] -> [b]
on concatMap(f, xs)
    set lng to length of xs
    set acc to {}
    tell mReturn(f)
        repeat with i from 1 to lng
            set acc to acc & (|λ|(item i of xs, i, xs))
        end repeat
    end tell
    return acc
end concatMap


-- floor :: Num -> Int
on floor(x)
    if class of x is record then
        set nr to properFracRatio(x)
    else
        set nr to properFraction(x)
    end if
    set n to item 1 of nr
    if 0 > item 2 of nr then
        n - 1
    else
        n
    end if
end floor


-- fmap <$> :: (a -> b) -> Gen [a] -> Gen [b]
on fmap(f, gen)
    script
        property g : mReturn(f)
        on |λ|()
            set v to gen's |λ|()
            if v is missing value then
                v
            else
                g's |λ|(v)
            end if
        end |λ|
    end script
end fmap


-- intercalate :: String -> [String] -> String
on intercalate(delim, xs)
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, delim}
    set s to xs as text
    set my text item delimiters to dlm
    s
end intercalate


-- length :: [a] -> Int
on |length|(xs)
    set c to class of xs
    if list is c or string is c then
        length of xs
    else
        (2 ^ 29 - 1) -- (maxInt - simple proxy for non-finite)
    end if
end |length|


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


-- min :: Ord a => a -> a -> a
on min(x, y)
    if y < x then
        y
    else
        x
    end if
end min


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


-- properFraction :: Real -> (Int, Real)
on properFraction(n)
    set i to (n div 1)
    {i, n - i}
end properFraction


-- showList :: [a] -> String
on showList(xs)
    "[" & intercalate(",", map(my str, xs)) & "]"
end showList


-- str :: a -> String
on str(x)
    x as string
end str


-- take :: Int -> [a] -> [a]
-- take :: Int -> String -> String
on take(n, xs)
    set c to class of xs
    if list is c then
        if 0 < n then
            items 1 thru min(n, length of xs) of xs
        else
            {}
        end if
    else if string is c then
        if 0 < n then
            text 1 thru min(n, length of xs) of xs
        else
            ""
        end if
    else if script is c then
        set ys to {}
        repeat with i from 1 to n
            set v to |λ|() of xs
            if missing value is v then
                return ys
            else
                set end of ys to v
            end if
        end repeat
        return ys
    else
        missing value
    end if
end take


-- unfoldr :: (b -> Maybe (a, b)) -> b -> [a]
on unfoldr(f, v)
    -- A lazy (generator) list unfolded from a seed value
    -- by repeated application of f to a value until no
    -- residue remains. Dual to fold/reduce.
    -- f returns either nothing (missing value),
    -- or just (value, residue).
    script
        property valueResidue : {v, v}
        property g : mReturn(f)
        on |λ|()
            set valueResidue to g's |λ|(item 2 of (valueResidue))
            if missing value ≠ valueResidue then
                item 1 of (valueResidue)
            else
                missing value
            end if
        end |λ|
    end script
end unfoldr


-- unlines :: [String] -> String
on unlines(xs)
    -- A single string formed by the intercalation
    -- of a list of strings with the newline character.
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, linefeed}
    set s to xs as text
    set my text item delimiters to dlm
    s
end unlines
