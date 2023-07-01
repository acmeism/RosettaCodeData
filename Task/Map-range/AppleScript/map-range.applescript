------------------------ MAP RANGE -----------------------

-- rangeMap :: (Num, Num) -> (Num, Num) -> Num -> Num
on rangeMap(a, b)
    script
        on |λ|(s)
            set {a1, a2} to a
            set {b1, b2} to b
            b1 + ((s - a1) * (b2 - b1)) / (a2 - a1)
        end |λ|
    end script
end rangeMap


--------------------------- TEST -------------------------
on run
    set mapping to rangeMap({0, 10}, {-1, 0})

    set xs to enumFromTo(0, 10)
    set ys to map(mapping, xs)
    set zs to map(approxRatio(0), ys)

    unlines(zipWith3(formatted, xs, ys, zs))
end run


------------------------- DISPLAY ------------------------

-- formatted :: Int -> Float -> Ratio -> String
on formatted(x, m, r)
    set fract to showRatio(r)
    set {n, d} to splitOn("/", fract)

    (justifyRight(2, space, x as string) & "   ->   " & ¬
        justifyRight(4, space, m as string)) & "   =   " & ¬
        justifyRight(2, space, n) & "/" & d
end formatted


-------------------- GENERIC FUNCTIONS -------------------

-- Absolute value.
-- abs :: Num -> Num
on abs(x)
    if 0 > x then
        -x
    else
        x
    end if
end abs


-- approxRatio :: Real -> Real -> Ratio
on approxRatio(epsilon)
    script
        on |λ|(n)
            if {real, integer} contains (class of epsilon) and 0 < epsilon then
                set e to epsilon
            else
                set e to 1 / 10000
            end if

            script gcde
                on |λ|(e, x, y)
                    script _gcd
                        on |λ|(a, b)
                            if b < e then
                                a
                            else
                                |λ|(b, a mod b)
                            end if
                        end |λ|
                    end script
                    |λ|(abs(x), abs(y)) of _gcd
                end |λ|
            end script

            set c to |λ|(e, 1, n) of gcde
            ratio((n div c), (1 div c))
        end |λ|
    end script
end approxRatio


-- enumFromTo :: Int -> Int -> [Int]
on enumFromTo(m, n)
    if m ≤ n then
        set lst to {}
        repeat with i from m to n
            set end of lst to i
        end repeat
        return lst
    else
        return {}
    end if
end enumFromTo


-- gcd :: Int -> Int -> Int
on gcd(a, b)
    set x to abs(a)
    set y to abs(b)
    repeat until y = 0
        if x > y then
            set x to x - y
        else
            set y to y - x
        end if
    end repeat
    return x
end gcd


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


-- Lift 2nd class handler function into 1st class script wrapper
-- mReturn :: First-class m => (a -> b) -> m (a -> b)
on mReturn(f)
    if class of f is script then
        f
    else
        script
            property |λ| : f
        end script
    end if
end mReturn


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


-- ratio :: Int -> Int -> Ratio Int
on ratio(x, y)
    script go
        on |λ|(x, y)
            if 0 ≠ y then
                if 0 ≠ x then
                    set d to gcd(x, y)
                    {type:"Ratio", n:(x div d), d:(y div d)}
                else
                    {type:"Ratio", n:0, d:1}
                end if
            else
                missing value
            end if
        end |λ|
    end script
    go's |λ|(x * (signum(y)), abs(y))
end ratio


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


-- showRatio :: Ratio -> String
on showRatio(r)
    (n of r as string) & "/" & (d of r as string)
end showRatio


-- signum :: Num -> Num
on signum(x)
    if x < 0 then
        -1
    else if x = 0 then
        0
    else
        1
    end if
end signum


-- splitOn :: String -> String -> [String]
on splitOn(pat, src)
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, pat}
    set xs to text items of src
    set my text item delimiters to dlm
    return xs
end splitOn


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
            set v to xs's |λ|()
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
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, linefeed}
    set str to xs as text
    set my text item delimiters to dlm
    str
end unlines


-- zipWith3 :: (a -> b -> c -> d) -> [a] -> [b] -> [c] -> [d]
on zipWith3(f, xs, ys, zs)
    set lng to minimum({length of xs, length of ys, length of zs})
    if 1 > lng then return {}
    set lst to {}
    tell mReturn(f)
        repeat with i from 1 to lng
            set end of lst to |λ|(item i of xs, item i of ys, item i of zs)
        end repeat
        return lst
    end tell
end zipWith3
