-- pascal :: Int -> [[Int]]
on pascal(intRows)

    script addRow
        on nextRow(row)
            script add
                on lambda(a, b)
                    a + b
                end lambda
            end script

            zipWith(add, [0] & row, row & [0])
        end nextRow

        on lambda(xs)
            xs & {nextRow(item -1 of xs)}
        end lambda
    end script

    foldr(addRow, {{1}}, range(1, intRows - 1))
end pascal


-- TEST

on run
    set lstTriangle to pascal(7)

    script spaced
        on lambda(xs)
            script rightAlign
                on lambda(x)
                    text -4 thru -1 of ("    " & x)
                end lambda
            end script

            intercalate("", map(rightAlign, xs))
        end lambda
    end script

    script indented
        on lambda(a, x)
            set strIndent to leftSpace of a

            {rows:strIndent & x & linefeed & rows of a, leftSpace:leftSpace of a & "  "}
        end lambda
    end script

    rows of foldr(indented, {rows:"", leftSpace:""}, map(spaced, lstTriangle))
end run



-- GENERIC LIBRARY FUNCTIONS

-- foldr :: (a -> b -> a) -> a -> [b] -> a
on foldr(f, startValue, xs)
    tell mReturn(f)
        set v to startValue
        set lng to length of xs
        repeat with i from lng to 1 by -1
            set v to lambda(v, item i of xs, i, xs)
        end repeat
        return v
    end tell
end foldr

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

-- zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
on zipWith(f, xs, ys)
    set nx to length of xs
    set ny to length of ys
    if nx < 1 or ny < 1 then
        {}
    else
        set lng to cond(nx < ny, nx, ny)
        set lst to {}
        tell mReturn(f)
            repeat with i from 1 to lng
                set end of lst to lambda(item i of xs, item i of ys)
            end repeat
            return lst
        end tell
    end if
end zipWith

-- cond :: Bool -> (a -> b) -> (a -> b) -> (a -> b)
on cond(bool, f, g)
    if bool then
        f
    else
        g
    end if
end cond

-- intercalate :: Text -> [Text] -> Text
on intercalate(strText, lstText)
    set {dlm, my text item delimiters} to {my text item delimiters, strText}
    set strJoined to lstText as text
    set my text item delimiters to dlm
    return strJoined
end intercalate

-- range :: Int -> Int -> [Int]
on range(m, n)
    set lng to (n - m) + 1
    set base to m - 1
    set lst to {}
    repeat with i from 1 to lng
        set end of lst to i + base
    end repeat
    return lst
end range

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
