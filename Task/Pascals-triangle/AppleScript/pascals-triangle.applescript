-- PASCAL ---------------------------------------------------------------------

-- pascal :: Int -> [[Int]]
on pascal(intRows)

    script addRow
        on nextRow(row)
            script add
                on |λ|(a, b)
                    a + b
                end |λ|
            end script

            zipWith(add, [0] & row, row & [0])
        end nextRow

        on |λ|(xs)
            xs & {nextRow(item -1 of xs)}
        end |λ|
    end script

    foldr(addRow, {{1}}, enumFromTo(1, intRows - 1))
end pascal

-- TEST -----------------------------------------------------------------------
on run
    set lstTriangle to pascal(7)

    script spaced
        on |λ|(xs)
            script rightAlign
                on |λ|(x)
                    text -4 thru -1 of ("    " & x)
                end |λ|
            end script

            intercalate("", map(rightAlign, xs))
        end |λ|
    end script

    script indented
        on |λ|(a, x)
            set strIndent to leftSpace of a

            {rows:¬
                strIndent & x & linefeed & rows of a, leftSpace:¬
                leftSpace of a & "  "} ¬

        end |λ|
    end script

    rows of foldr(indented, ¬
        {rows:"", leftSpace:""}, map(spaced, lstTriangle))
end run

-- GENERIC FUNCTIONS ----------------------------------------------------------

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

-- foldr :: (a -> b -> a) -> a -> [b] -> a
on foldr(f, startValue, xs)
    tell mReturn(f)
        set v to startValue
        set lng to length of xs
        repeat with i from lng to 1 by -1
            set v to |λ|(v, item i of xs, i, xs)
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
