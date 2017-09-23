-- FLOYDs TRIANGLE -----------------------------------------------------------

-- floyd :: Int -> [[Int]]
on floyd(n)
    script floydRow
        on |λ|(start, row)
            {start + row + 1, enumFromTo(start, start + row)}
        end |λ|
    end script

    snd(mapAccumL(floydRow, 1, enumFromTo(0, n - 1)))
end floyd

-- showFloyd :: [[Int]] -> String
on showFloyd(xss)
    set ws to map(compose({my succ, my |length|, my show}), |last|(xss))

    script aligned
        on |λ|(xs)
            script pad
                on |λ|(w, x)
                    justifyRight(w, space, show(x))
                end |λ|
            end script

            concat(zipWith(pad, ws, xs))
        end |λ|
    end script

    unlines(map(aligned, xss))
end showFloyd


-- TEST ----------------------------------------------------------------------
on run
    script test
        on |λ|(n)
            showFloyd(floyd(n)) & linefeed
        end |λ|
    end script

    unlines(map(test, {5, 14}))
end run


-- GENERIC FUNCTIONS ---------------------------------------------------------

-- compose :: [(a -> a)] -> (a -> a)
on compose(fs)
    script
        on |λ|(x)
            script
                on |λ|(f, a)
                    mReturn(f)'s |λ|(a)
                end |λ|
            end script

            foldr(result, x, fs)
        end |λ|
    end script
end compose

-- concat :: [[a]] -> [a] | [String] -> String
on concat(xs)
    if length of xs > 0 and class of (item 1 of xs) is string then
        set acc to ""
    else
        set acc to {}
    end if
    repeat with i from 1 to length of xs
        set acc to acc & item i of xs
    end repeat
    acc
end concat

-- enumFromTo :: Int -> Int -> [Int]
on enumFromTo(m, n)
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

-- foldr :: (b -> a -> a) -> a -> [b] -> a
on foldr(f, startValue, xs)
    tell mReturn(f)
        set v to startValue
        set lng to length of xs
        repeat with i from lng to 1 by -1
            set v to |λ|(item i of xs, v, i, xs)
        end repeat
        return v
    end tell
end foldr

-- intercalate :: Text -> [Text] -> Text
on intercalate(strText, lstText)
    set {dlm, my text item delimiters} to {my text item delimiters, strText}
    set strJoined to lstText as text
    set my text item delimiters to dlm
    return strJoined
end intercalate

-- justifyRight :: Int -> Char -> Text -> Text
on justifyRight(n, cFiller, strText)
    if n > length of strText then
        text -n thru -1 of ((replicate(n, cFiller) as text) & strText)
    else
        strText
    end if
end justifyRight

-- last :: [a] -> a
on |last|(xs)
    if length of xs > 0 then
        item -1 of xs
    else
        missing value
    end if
end |last|

-- length :: [a] -> Int
on |length|(xs)
    length of xs
end |length|

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

    foldl(result, [acc, []], xs)
end mapAccumL

-- min :: Ord a => a -> a -> a
on min(x, y)
    if y < x then
        y
    else
        x
    end if
end min

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
    if class of xs is list and length of xs > 1 then
        item 2 of xs
    else
        missing value
    end if
end snd

-- show :: a -> String
on show(e)
    set c to class of e
    if c = list then
        script serialized
            on |λ|(v)
                show(v)
            end |λ|
        end script

        "{" & intercalate(", ", map(serialized, e)) & "}"
    else if c = record then
        script showField
            on |λ|(kv)
                set {k, v} to kv
                k & ":" & show(v)
            end |λ|
        end script

        "{" & intercalate(", ", ¬
            map(showField, zip(allKeys(e), allValues(e)))) & "}"
    else if c = date then
        ("date \"" & e as text) & "\""
    else if c = text then
        "\"" & e & "\""
    else
        try
            e as text
        on error
            ("«" & c as text) & "»"
        end try
    end if
end show

-- succ :: Int -> Int
on succ(x)
    x + 1
end succ

-- unlines :: [String] -> String
on unlines(xs)
    intercalate(linefeed, xs)
end unlines

-- zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
on zipWith(f, xs, ys)
    set lng to min(length of xs, length of ys)
    set lst to {}
    tell mReturn(f)
        repeat with i from 1 to lng
            set end of lst to |λ|(item i of xs, item i of ys)
        end repeat
        return lst
    end tell
end zipWith
