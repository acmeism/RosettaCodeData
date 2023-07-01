-------------------- MID THREE DIGITS ---------------------

-- mid3digits :: Int -> Either String String
on mid3digits(n)
    -- Either a message explaining why
    -- no "mid 3 digits" are defined for n,
    -- or the mid 3 digits themselves.

    set m to abs(n)
    if 100 > m then
        |Left|("Less than 3 digits")

    else if maxBound(1) < m then
        |Left|("Out of AppleScript integer range")

    else
        set s to m as string
        set intDigits to length of s

        if even(intDigits) then
            |Left|("Even digit count")
        else
            |Right|((items 1 thru 3 of ¬
                items (1 + ((intDigits - 3) div 2)) thru -1 of s) as string)
        end if
    end if
end mid3digits


-------------------------- TEST ---------------------------
on run
    set ints to map(readInt, splitOn(", ", ¬
        "123, 12345, 1234567, 987654321, 10001, -10001, " & ¬
        "-123, -100, 100, -12345, 1, 2, -1, -10, 2002, -2002, 0"))


    script showResult
        on |λ|(x)
            either(my bracketed, my str, x)
        end |λ|
    end script

    fTable("Mid three digits:", str, showResult, mid3digits, ints)
end run


------------------------ GENERICS -------------------------

-- Left :: a -> Either a b
on |Left|(x)
    {type:"Either", |Left|:x, |Right|:missing value}
end |Left|


-- Right :: b -> Either a b
on |Right|(x)
    {type:"Either", |Left|:missing value, |Right|:x}
end |Right|


-- abs :: Num -> Num
on abs(x)
    -- Absolute value.
    if 0 > x then
        -x
    else
        x
    end if
end abs


-- even :: Int -> Bool
on even(x)
    0 = x mod 2
end even


-- maxBound :: a -> a
on maxBound(x)
    set c to class of x
    if text is c then
        character id 65535
    else if integer is c then
        (2 ^ 29 - 1)
    else if real is c then
        1.797693E+308
    else if boolean is c then
        true
    end if
end maxBound


-------------------- GENERICS FOR TEST AND DISPLAY ---------------------

-- bracketed :: String -> String
on bracketed(s)
    "(" & s & ")"
end bracketed


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


-- either :: (a -> c) -> (b -> c) -> Either a b -> c
on either(lf, rf, e)
    if missing value is |Left| of e then
        tell mReturn(rf) to |λ|(|Right| of e)
    else
        tell mReturn(lf) to |λ|(|Left| of e)
    end if
end either


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


-- readInt :: String -> Int
on readInt(s)
    s as integer
end readInt


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
    x as string
end str


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
