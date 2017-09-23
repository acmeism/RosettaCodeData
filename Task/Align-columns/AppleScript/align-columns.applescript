-- COLUMN ALIGNMENTS ---------------------------------------------------------

property pstrLines : ¬
    "Given$a$text$file$of$many$lines,$where$fields$within$a$line$\n" & ¬
    "are$delineated$by$a$single$'dollar'$character,$write$a$program\n" & ¬
    "that$aligns$each$column$of$fields$by$ensuring$that$words$in$each$\n" & ¬
    "column$are$separated$by$at$least$one$space.\n" & ¬
    "Further,$allow$for$each$word$in$a$column$to$be$either$left$\n" & ¬
    "justified,$right$justified,$or$center$justified$within$its$column."

property eLeft : -1
property eCenter : 0
property eRight : 1

-- columnsAligned :: EnumValue -> [[String]] -> String
on columnsAligned(eAlign, lstCols)
    -- padwords :: Int -> [String] -> [[String]]
    script padwords
        on |λ|(n, lstWords)

            -- pad :: String -> String
            script pad
                on |λ|(str)
                    set lngPad to n - (length of str)
                    if eAlign = my eCenter then
                        set lngHalf to lngPad div 2
                        {replicate(lngHalf, space), str, ¬
                            replicate(lngPad - lngHalf, space)}
                    else
                        if eAlign = my eLeft then
                            {"", str, replicate(lngPad, space)}
                        else
                            {replicate(lngPad, space), str, ""}
                        end if
                    end if
                end |λ|
            end script

            map(pad, lstWords)
        end |λ|
    end script

    unlines(map(my unwords, ¬
        transpose(zipWith(padwords, ¬
            map(my widest, lstCols), lstCols))))
end columnsAligned

-- lineColumns :: String -> String -> String
on lineColumns(strColDelim, strText)
    -- _words :: Text -> [Text]
    script _words
        on |λ|(str)
            splitOn(strColDelim, str)
        end |λ|
    end script

    set lstRows to map(_words, splitOn(linefeed, pstrLines))
    set nCols to widest(lstRows)

    -- fullRow :: [[a]] -> [[a]]
    script fullRow
        on |λ|(lst)
            lst & replicate(nCols - (length of lst), {""})
        end |λ|
    end script

    transpose(map(fullRow, lstRows))
end lineColumns

-- widest [a] -> Int
on widest(xs)
    |length|(maximumBy(comparing(my |length|), xs))
end widest

-- TEST ----------------------------------------------------------------------
on run
    set lstCols to lineColumns("$", pstrLines)

    script testAlignment
        on |λ|(eAlign)
            columnsAligned(eAlign, lstCols)
        end |λ|
    end script

    intercalate(return & return, ¬
        map(testAlignment, {eLeft, eRight, eCenter}))
end run

-- GENERIC FUNCTIONS ---------------------------------------------------------

-- comparing :: (a -> b) -> (a -> a -> Ordering)
on comparing(f)
    set mf to mReturn(f)
    script
        on |λ|(a, b)
            set x to mf's |λ|(a)
            set y to mf's |λ|(b)
            if x < y then
                -1
            else
                if x > y then
                    1
                else
                    0
                end if
            end if
        end |λ|
    end script
end comparing

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

-- Text -> [Text] -> Text
on intercalate(strText, lstText)
    set {dlm, my text item delimiters} to {my text item delimiters, strText}
    set strJoined to lstText as text
    set my text item delimiters to dlm
    return strJoined
end intercalate

-- length :: [a] -> Int
on |length|(xs)
    length of xs
end |length|

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

-- maximumBy :: (a -> a -> Ordering) -> [a] -> a
on maximumBy(f, xs)
    set cmp to mReturn(f)
    script max
        on |λ|(a, b)
            if a is missing value or cmp's |λ|(a, b) < 0 then
                b
            else
                a
            end if
        end |λ|
    end script

    foldl(max, missing value, xs)
end maximumBy

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
    if class of a is string then
        set out to ""
    else
        set out to {}
    end if
    if n < 1 then return out
    set dbl to a

    repeat while (n > 1)
        if (n mod 2) > 0 then set out to out & dbl
        set n to (n div 2)
        set dbl to (dbl & dbl)
    end repeat
    return out & dbl
end replicate

-- Text -> Text -> [Text]
on splitOn(strDelim, strMain)
    set {dlm, my text item delimiters} to {my text item delimiters, strDelim}
    set lstParts to text items of strMain
    set my text item delimiters to dlm
    return lstParts
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

-- [Text] -> Text
on unlines(lstLines)
    intercalate(linefeed, lstLines)
end unlines

-- [Text] -> Text
on unwords(lstWords)
    intercalate(" ", lstWords)
end unwords

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
