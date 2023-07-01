---------------------- PRICE FRACTION ----------------------

property table : [¬
    {0.06, 0.1}, {0.11, 0.18}, {0.16, 0.26}, {0.21, 0.32}, {0.26, 0.38}, ¬
    {0.31, 0.44}, {0.36, 0.5}, {0.41, 0.54}, {0.46, 0.58}, {0.51, 0.62}, ¬
    {0.56, 0.66}, {0.61, 0.7}, {0.66, 0.74}, {0.71, 0.78}, {0.76, 0.82}, ¬
    {0.81, 0.86}, {0.86, 0.9}, {0.91, 0.94}, {0.96, 0.98}, {1.01, 1.0}]


-- rescaled :: [(Float, Float)] -> Float -> Float
on rescaled(table)
    script
        on |λ|(x)
            if 0 > x or 1.01 < x then
                |Left|("Out of range.")
            else
                |Right|(snd(my head(dropWhile(compose(ge(x), my fst), table))))
            end if
        end |λ|
    end script
end rescaled


--------------------------- TEST ---------------------------
on run
    fTable("Price adjustments:\n", ¬
        showReal(2), either(identity, showReal(2)), ¬
        rescaled(table), enumFromThenTo(-0.05, 0, 1.1))
end run


----------- GENERAL AND REUSABLE PURE FUNCTIONS ------------

-- Left :: a -> Either a b
on |Left|(x)
    {type:"Either", |Left|:x, |Right|:missing value}
end |Left|


-- Right :: b -> Either a b
on |Right|(x)
    {type:"Either", |Left|:missing value, |Right|:x}
end |Right|


-- compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
on compose(f, g)
    script
        property mf : mReturn(f)
        property mg : mReturn(g)
        on |λ|(x)
            mf's |λ|(mg's |λ|(x))
        end |λ|
    end script
end compose


-- drop :: Int -> [a] -> [a]
-- drop :: Int -> String -> String
on drop(n, xs)
    set c to class of xs
    if script is not c then
        if string is not c then
            if n < length of xs then
                items (1 + n) thru -1 of xs
            else
                {}
            end if
        else
            if n < length of xs then
                text (1 + n) thru -1 of xs
            else
                ""
            end if
        end if
    else
        take(n, xs) -- consumed
        return xs
    end if
end drop


-- dropWhile :: (a -> Bool) -> [a] -> [a]
-- dropWhile :: (Char -> Bool) -> String -> String
on dropWhile(p, xs)
    set lng to length of xs
    set i to 1
    tell mReturn(p)
        repeat while i ≤ lng and |λ|(item i of xs)
            set i to i + 1
        end repeat
    end tell
    drop(i - 1, xs)
end dropWhile


-- either :: (a -> c) -> (b -> c) -> Either a b -> c
on either(lf, rf)
    script
        on |λ|(e)
            if missing value is |Left| of e then
                tell mReturn(rf) to |λ|(|Right| of e)
            else
                tell mReturn(lf) to |λ|(|Left| of e)
            end if
        end |λ|
    end script
end either


-- enumFromThenTo :: Int -> Int -> Int -> [Int]
on enumFromThenTo(x1, x2, y)
    set xs to {}
    set d to x2 - x1
    set v to x1
    repeat until v ≥ y
        set end of xs to v
        set v to d + v
    end repeat
    return xs
end enumFromThenTo


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


-- fst :: (a, b) -> a
on fst(tpl)
    if class of tpl is record then
        |1| of tpl
    else
        item 1 of tpl
    end if
end fst


-- fTable :: String -> (a -> String) -> (b -> String) -> (a -> b) -> [a] -> String
on fTable(s, xShow, fxShow, f, xs)
    set ys to map(xShow, xs)
    set w to maximum(map(my |length|, ys))
    script arrowed
        on |λ|(a, b)
            justifyRight(w, space, a) & " -> " & b
        end |λ|
    end script
    s & linefeed & unlines(zipWith(arrowed, ¬
        ys, map(compose(fxShow, f), xs)))
end fTable


-- ge :: Ord a => a -> a -> Bool
on ge(a)
    -- True if a is greater
    -- than or equal to b.
    script
        on |λ|(b)
            a ≥ b
        end |λ|
    end script
end ge


-- head :: [a] -> a
on head(xs)
    if xs = {} then
        missing value
    else
        item 1 of xs
    end if
end head


-- identity :: a -> a
on identity(x)
    -- The argument unchanged.
    x
end identity


-- justifyLeft :: Int -> Char -> String -> String
on justifyLeft(n, cFiller, strText)
    if n > length of strText then
        text 1 thru n of (strText & replicate(n, cFiller))
    else
        strText
    end if
end justifyLeft


-- justifyRight :: Int -> Char -> String -> String
on justifyRight(n, cFiller, strText)
    if n > length of strText then
        text -n thru -1 of ((replicate(n, cFiller) as text) & strText)
    else
        strText
    end if
end justifyRight


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


-- max :: Ord a => a -> a -> a
on max(x, y)
    if x > y then
        x
    else
        y
    end if
end max


-- maximum :: Ord a => [a] -> a
on maximum(xs)
    script
        on |λ|(a, b)
            if a is missing value or b > a then
                b
            else
                a
            end if
        end |λ|
    end script

    foldl(result, missing value, xs)
end maximum


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


-- Egyptian multiplication - progressively doubling a list, appending
-- stages of doubling to an accumulator where needed for binary
-- assembly of a target length
-- replicate :: Int -> a -> [a]
on replicate(n, a)
    set out to {}
    if 1 > n then return out
    set dbl to {a}

    repeat while (1 < n)
        if 0 < (n mod 2) then set out to out & dbl
        set n to (n div 2)
        set dbl to (dbl & dbl)
    end repeat
    return out & dbl
end replicate


-- showReal :: Num b => Int -> b -> String
on showReal(n)
    script
        on |λ|(x)
            set {l, r} to splitOn(".", (x as real) as string)
            l & "." & justifyLeft(n, "0", r)
        end |λ|
    end script
end showReal


-- snd :: (a, b) -> b
on snd(tpl)
    if class of tpl is record then
        |2| of tpl
    else
        item 2 of tpl
    end if
end snd


-- splitOn :: String -> String -> [String]
on splitOn(pat, src)
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, pat}
    set xs to text items of src
    set my text item delimiters to dlm
    return xs
end splitOn


-- str :: a -> String
on str(x)
    x as text
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


-- zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
on zipWith(f, xs, ys)
    set lng to min(length of xs, length of ys)
    set lst to {}
    if 1 > lng then
        return {}
    else
        tell mReturn(f)
            repeat with i from 1 to lng
                set end of lst to |λ|(item i of xs, item i of ys)
            end repeat
            return lst
        end tell
    end if
end zipWith
