-- MULTIPLICATION TABLE FOR INTEGERS M TO N

-- table :: Int -> Int -> [[String]]
on table(m, n)

    set axis to range(m, n)

    script column
        on lambda(x)
            script row
                on lambda(y)
                    if y < x then
                        {""}
                    else
                        {(x * y) as text}
                    end if
                end lambda
            end script

            {x & map(row, axis)}
        end lambda
    end script

    {{"x"} & axis} & concatMap(column, axis)
end table


on run

    tableText(table(1, 12))

end run


-- TABLE DISPLAY

-- tableText :: [[String]] -> String
on tableText(lstTable)
    script tableLine
        on lambda(lstLine)
            script tableCell
                on lambda(cell)
                    (characters -4 thru -1 of ("    " & cell)) as string
                end lambda
            end script

            intercalate(" ", map(tableCell, lstLine))
        end lambda
    end script

    intercalate(linefeed, map(tableLine, lstTable))
end tableText


-- GENERIC LIBRARY FUNCTIONS

-- concatMap :: (a -> [b]) -> [a] -> [b]
on concatMap(f, xs)
    script append
        on lambda(a, b)
            a & b
        end lambda
    end script

    foldl(append, {}, map(f, xs))
end concatMap

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

-- intercalate :: Text -> [Text] -> Text
on intercalate(strText, lstText)
    set {dlm, my text item delimiters} to {my text item delimiters, strText}
    set strJoined to lstText as text
    set my text item delimiters to dlm
    return strJoined
end intercalate
