tableText(multTable(1, 12))

-- multTable :: Int -> [[String]]
on multTable(m, n)

    set axis to enumFromTo(m, n)

    script column
        on |λ|(x)
            script row
                on |λ|(y)
                    if y < x then
                        ""
                    else
                        (x * y) as string
                    end if
                end |λ|
            end script

            {x & map(row, axis)}
        end |λ|
    end script

    {{"x"} & axis} & concatMap(column, axis)
end multTable

-- TABLE DISPLAY --------------------------------------------------------------

-- tableText :: [[Int]] -> String
on tableText(lstTable)
    script tableLine
        on |λ|(lstLine)
            script tableCell
                on |λ|(int)
                    (characters -4 thru -1 of ("    " & int)) as string
                end |λ|
            end script

            intercalate(" ", map(tableCell, lstLine))
        end |λ|
    end script

    intercalate(linefeed, map(tableLine, lstTable))
end tableText


-- GENERIC FUNCTIONS ----------------------------------------------------------

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
