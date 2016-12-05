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

on run
    set lstCols to lineColumns("$", pstrLines)

    script testAlignment
        on lambda(eAlign)
            columnsAligned(eAlign, lstCols)
        end lambda
    end script

    intercalate(return & return, ¬
        map(testAlignment, {eLeft, eRight, eCenter}))
end run


-- columnsAligned :: EnumValue -> [[String]] -> String
on columnsAligned(eAlign, lstCols)
    -- padwords :: Int -> [String] -> [[String]]
    script padwords
        on lambda(n, lstWords)

            -- pad :: String -> String
            script pad
                on lambda(str)
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
                end lambda
            end script

            map(pad, lstWords)
        end lambda
    end script

    unlines(map(my unwords, ¬
        transpose(zipWith(padwords, ¬
            map(my widest, lstCols), lstCols))))
end columnsAligned

-- lineColumns :: String -> String -> String
on lineColumns(strColDelim, strText)
    -- _words :: Text -> [Text]
    script _words
        on lambda(str)
            splitOn(strColDelim, str)
        end lambda
    end script

    set lstRows to map(_words, splitOn(linefeed, pstrLines))
    set nCols to widest(lstRows)

    -- fullRow :: [[a]] -> [[a]]
    script fullRow
        on lambda(lst)
            lst & replicate(nCols - (length of lst), {""})
        end lambda
    end script

    transpose(map(fullRow, lstRows))
end lineColumns

-- widest [a] -> Int
on widest(xs)
    script maxLen
        on lambda(a, x)
            set lng to length of x
            cond(lng > a, lng, a)
        end lambda
    end script

    foldl(maxLen, 0, xs)
end widest



-- GENERIC LIBRARY FUNCTIONS

-- Text -> [Text] -> Text
on intercalate(strText, lstText)
    set {dlm, my text item delimiters} to {my text item delimiters, strText}
    set strJoined to lstText as text
    set my text item delimiters to dlm
    return strJoined
end intercalate

-- Text -> Text -> [Text]
on splitOn(strDelim, strMain)
    set {dlm, my text item delimiters} to {my text item delimiters, strDelim}
    set lstParts to text items of strMain
    set my text item delimiters to dlm
    return lstParts
end splitOn

-- [Text] -> Text
on unlines(lstLines)
    intercalate(linefeed, lstLines)
end unlines

-- [Text] -> Text
on unwords(lstWords)
    intercalate(" ", lstWords)
end unwords

-- transpose :: [[a]] -> [[a]]
on transpose(xss)
    script column
        on lambda(_, iCol)
            script row
                on lambda(xs)
                    item iCol of xs
                end lambda
            end script

            map(row, xss)
        end lambda
    end script

    map(column, item 1 of xss)
end transpose

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

-- zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
on zipWith(f, xs, ys)
    set lng to length of xs
    if lng is not length of ys then return missing value

    tell mReturn(f)
        set lst to {}
        repeat with i from 1 to lng
            set end of lst to lambda(item i of xs, item i of ys)
        end repeat
        return lst
    end tell
end zipWith

-- cond :: Bool -> a -> a -> a
on cond(bool, f, g)
    if bool then
        f
    else
        g
    end if
end cond

-- Egyptian multiplication - progressively doubling a list, appending
-- stages of doubling to an accumulator where needed for binary
-- assembly of a target length

-- replicate :: Int -> a -> [a]
on replicate(n, a)
    set out to cond(class of a is string, "", {})
    if n < 1 then return out
    set dbl to a

    repeat while (n > 1)
        if (n mod 2) > 0 then set out to out & dbl
        set n to (n div 2)
        set dbl to (dbl & dbl)
    end repeat
    return out & dbl
end replicate

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
