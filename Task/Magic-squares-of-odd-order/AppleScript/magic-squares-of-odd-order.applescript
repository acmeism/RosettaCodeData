---------------- MAGIC SQUARE OF ODD ORDER ---------------

-- oddMagicSquare :: Int -> [[Int]]
on oddMagicSquare(n)
    if 0 < (n mod 2) then
        cycleRows(transpose(cycleRows(table(n))))
    else
        missing value
    end if
end oddMagicSquare


--------------------------- TEST -------------------------
on run
    -- Orders 3, 5, 11

    -- wikiTableMagic :: Int -> String
    script wikiTableMagic
        on |λ|(n)
            formattedTable(oddMagicSquare(n))
        end |λ|
    end script

    intercalate(linefeed & linefeed, map(wikiTableMagic, {3, 5, 11}))
end run

-- table :: Int -> [[Int]]
on table(n)
    set lstTop to enumFromTo(1, n)

    script cols
        on |λ|(row)
            script rows
                on |λ|(x)
                    (row * n) + x
                end |λ|
            end script

            map(rows, lstTop)
        end |λ|
    end script

    map(cols, enumFromTo(0, n - 1))
end table

-- cycleRows :: [[a]] -> [[a]]
on cycleRows(lst)
    script rotationRow
        -- rotatedList :: [a] -> Int -> [a]
        on rotatedList(lst, n)
            if n = 0 then return lst

            set lng to length of lst
            set m to (n + lng) mod lng
            items -m thru -1 of lst & items 1 thru (lng - m) of lst
        end rotatedList

        on |λ|(row, i)
            rotatedList(row, (((length of row) + 1) div 2) - (i))
        end |λ|
    end script

    map(rotationRow, lst)
end cycleRows


-------------------- GENERIC FUNCTIONS -------------------

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

-- splitOn :: Text -> Text -> [Text]
on splitOn(strDelim, strMain)
    set {dlm, my text item delimiters} to {my text item delimiters, strDelim}
    set xs to text items of strMain
    set my text item delimiters to dlm
    return xs
end splitOn

-- transpose :: [[a]] -> [[a]]
on transpose(xss)
    script column
        on |λ|(_, iCol)
            script row
                on |λ|(xs)
                    item iCol of xs
                end |λ|
            end script

            map(row, xss)
        end |λ|
    end script

    map(column, item 1 of xss)
end transpose



----------------------- WIKI DISPLAY ---------------------

-- formattedTable :: [[Int]] -> String
on formattedTable(lstTable)
    set n to length of lstTable
    set w to 2.5 * n
    "magic(" & n & ")" & linefeed & linefeed & wikiTable(lstTable, ¬
        false, "text-align:center;width:" & ¬
        w & "em;height:" & w & "em;table-layout:fixed;")
end formattedTable

-- wikiTable :: [Text] -> Bool -> Text -> Text
on wikiTable(xs, blnHdr, strStyle)
    script wikiRows
        on |λ|(lstRow, iRow)
            set strDelim to cond(blnHdr and (iRow = 0), "!", "|")
            set strDbl to strDelim & strDelim
            linefeed & "|-" & linefeed & strDelim & space & ¬
                intercalate(space & strDbl & space, lstRow)
        end |λ|
    end script

    linefeed & "{| class=\"wikitable\" " & ¬
        cond(strStyle ≠ "", "style=\"" & strStyle & "\"", "") & ¬
        intercalate("", ¬
            map(wikiRows, xs)) & linefeed & "|}" & linefeed
end wikiTable

-- cond :: Bool -> a -> a -> a
on cond(bool, f, g)
    if bool then
        f
    else
        g
    end if
end cond
