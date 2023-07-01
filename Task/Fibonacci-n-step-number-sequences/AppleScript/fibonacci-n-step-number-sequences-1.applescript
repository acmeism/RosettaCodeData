use AppleScript version "2.4"
use framework "Foundation"
use scripting additions


-- Start sequence -> Number of terms -> terms
-- takeNFibs :: [Int] -> Int -> [Int]
on takeNFibs(xs, n)
    script go
        on |λ|(xs, n)
            if 0 < n and 0 < length of xs then
                cons(head(xs), ¬
                    |λ|(append(tail(xs), {sum(xs)}), n - 1))
            else
                {}
            end if
        end |λ|
    end script
    go's |λ|(xs, n)
end takeNFibs

-- fibInit :: Int -> [Int]
on fibInit(n)
    script powerOfTwo
        on |λ|(x)
            2 ^ x as integer
        end |λ|
    end script
    cons(1, map(powerOfTwo, enumFromToInt(0, n - 2)))
end fibInit

-- TEST ---------------------------------------------------
on run
    set intTerms to 15
    script series
        on |λ|(s, n)
            justifyLeft(12, space, s & "nacci") & " -> " & ¬
                showJSON(takeNFibs(fibInit(n), intTerms))
        end |λ|
    end script

    set strTable to unlines(zipWith(series, ¬
        words of ("fibo tribo tetra penta hexa hepta octo nona deca"), ¬
        enumFromToInt(2, 10)))

    justifyLeft(12, space, "Lucas ") & " -> " & ¬
        showJSON(takeNFibs({2, 1}, intTerms)) & linefeed & strTable
end run

-- GENERIC FUNCTIONS --------------------------------------

-- Append two lists.
-- append (++) :: [a] -> [a] -> [a]
-- append (++) :: String -> String -> String
on append(xs, ys)
    xs & ys
end append

-- cons :: a -> [a] -> [a]
on cons(x, xs)
    if list is class of xs then
        {x} & xs
    else
        x & xs
    end if
end cons

-- enumFromToInt :: Int -> Int -> [Int]
on enumFromToInt(m, n)
    if m ≤ n then
        set lst to {}
        repeat with i from m to n
            set end of lst to i
        end repeat
        return lst
    else
        return {}
    end if
end enumFromToInt

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

-- head :: [a] -> a
on head(xs)
    if xs = {} then
        missing value
    else
        item 1 of xs
    end if
end head

-- justifyLeft :: Int -> Char -> String -> String
on justifyLeft(n, cFiller, strText)
    if n > length of strText then
        text 1 thru n of (strText & replicate(n, cFiller))
    else
        strText
    end if
end justifyLeft

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

-- min :: Ord a => a -> a -> a
on min(x, y)
    if y < x then
        y
    else
        x
    end if
end min

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

-- showJSON :: a -> String
on showJSON(x)
    set c to class of x
    if (c is list) or (c is record) then
        set ca to current application
        set {json, e} to ca's NSJSONSerialization's ¬
            dataWithJSONObject:x options:0 |error|:(reference)
        if json is missing value then
            e's localizedDescription() as text
        else
            (ca's NSString's alloc()'s ¬
                initWithData:json encoding:(ca's NSUTF8StringEncoding)) as text
        end if
    else if c is date then
        "\"" & ((x - (time to GMT)) as «class isot» as string) & ".000Z" & "\""
    else if c is text then
        "\"" & x & "\""
    else if (c is integer or c is real) then
        x as text
    else if c is class then
        "null"
    else
        try
            x as text
        on error
            ("«" & c as text) & "»"
        end try
    end if
end showJSON

-- sum :: [Num] -> Num
on sum(xs)
    script add
        on |λ|(a, b)
            a + b
        end |λ|
    end script

    foldl(add, 0, xs)
end sum

-- tail :: [a] -> [a]
on tail(xs)
    set blnText to text is class of xs
    if blnText then
        set unit to ""
    else
        set unit to {}
    end if
    set lng to length of xs
    if 1 > lng then
        missing value
    else if 2 > lng then
        unit
    else
        if blnText then
            text 2 thru -1 of xs
        else
            rest of xs
        end if
    end if
end tail

-- unlines :: [String] -> String
on unlines(xs)
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, linefeed}
    set str to xs as text
    set my text item delimiters to dlm
    str
end unlines

-- zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
on zipWith(f, xs, ys)
    set lng to min(length of xs, length of ys)
    if 1 > lng then return {}
    set lst to {}
    tell mReturn(f)
        repeat with i from 1 to lng
            set end of lst to |λ|(item i of xs, item i of ys)
        end repeat
        return lst
    end tell
end zipWith
