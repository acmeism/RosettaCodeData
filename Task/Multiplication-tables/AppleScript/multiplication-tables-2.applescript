------------------- MULTIPLICATION TABLE -----------------

-- multiplicationTable :: Int -> Int -> String
on multiplicationTable(lower, upper)
    tell ap(my tableText, my mulTable)
        |λ|(enumFromTo(lower, upper))
    end tell
end multiplicationTable


-- mulTable :: [Int]-> [[Int]]
on mulTable(axis)

    script column
        on |λ|(x)
            script row
                on |λ|(y)
                    if y < x then
                        {}
                    else
                        {x * y}
                    end if
                end |λ|
            end script

            {{x} & map(row, axis)}
        end |λ|
    end script

    concatMap(column, axis)
end mulTable


-- tableText :: [[Int]] -> String
on tableText(axis, rows)

    set colWidth to 1 + (length of (|last|(|last|(rows)) as string))
    set cell to replicate(colWidth, space)

    script tableLine
        on |λ|(xys)
            script tableCell
                on |λ|(int)
                    (characters (-colWidth) thru -1 of (cell & int)) as string
                end |λ|
            end script

            intercalate(space, map(tableCell, xys))
        end |λ|
    end script

    set legend to {{"x"} & axis}
    intercalate(linefeed, map(tableLine, legend & {{}} & rows))

end tableText

--------------------------- TEST -------------------------
on run
    multiplicationTable(1, 12) & linefeed & linefeed & ¬
        multiplicationTable(30, 40)
end run


-------------------- GENERIC FUNCTIONS -------------------

-- ap :: (a -> b -> c) -> (a -> b) -> a -> c
on ap(f, g)
    -- The application of f x to g x
    script go
        property mf : |λ| of mReturn(f)
        property mg : |λ| of mReturn(g)
        on |λ|(x)
            mf(x, mg(x))
        end |λ|
    end script
end ap


-- concatMap :: (a -> [b]) -> [a] -> [b]
on concatMap(f, xs)
    set lst to {}
    set lng to length of xs
    tell mReturn(f)
        repeat with i from 1 to lng
            set lst to (lst & |λ|(item i of xs, i, xs))
        end repeat
    end tell
    return lst
end concatMap


-- enumFromTo :: Int -> Int -> [Int]
on enumFromTo(m, n)
    if m > n then
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
    item -1 of xs
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


-- replicate :: Int -> String -> String
on replicate(n, s)
    set out to ""
    if n < 1 then return out
    set dbl to s

    repeat while (n > 1)
        if (n mod 2) > 0 then set out to out & dbl
        set n to (n div 2)
        set dbl to (dbl & dbl)
    end repeat
    return out & dbl
end replicate
