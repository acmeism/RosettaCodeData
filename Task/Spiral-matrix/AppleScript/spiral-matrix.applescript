---------------------- SPIRAL MATRIX ---------------------

-- spiral :: Int -> [[Int]]
on spiral(n)
    script go
        on |λ|(rows, cols, start)
            if 0 < rows then
                {enumFromTo(start, start + pred(cols))} & ¬
                    map(my |reverse|, ¬
                        transpose(|λ|(cols, pred(rows), start + cols)))
            else
                {{}}
            end if
        end |λ|
    end script

    go's |λ|(n, n, 0)
end spiral


--------------------------- TEST -------------------------
on run
    wikiTable(spiral(5), ¬
        false, ¬
        "text-align:center;width:12em;height:12em;table-layout:fixed;")
end run


-------------------- WIKI TABLE FORMAT -------------------

-- wikiTable :: [Text] -> Bool -> Text -> Text
on wikiTable(lstRows, blnHdr, strStyle)
    script fWikiRows
        on |λ|(lstRow, iRow)
            set strDelim to if_(blnHdr and (iRow = 0), "!", "|")
            set strDbl to strDelim & strDelim
            linefeed & "|-" & linefeed & strDelim & space & ¬
                intercalateS(space & strDbl & space, lstRow)
        end |λ|
    end script

    linefeed & "{| class=\"wikitable\" " & ¬
        if_(strStyle ≠ "", "style=\"" & strStyle & "\"", "") & ¬
        intercalateS("", ¬
            map(fWikiRows, lstRows)) & linefeed & "|}" & linefeed
end wikiTable


------------------------- GENERIC ------------------------

-- comparing :: (a -> b) -> (a -> a -> Ordering)
on comparing(f)
    script
        on |λ|(a, b)
            tell mReturn(f)
                set fa to |λ|(a)
                set fb to |λ|(b)
                if fa < fb then
                    -1
                else if fa > fb then
                    1
                else
                    0
                end if
            end tell
        end |λ|
    end script
end comparing


-- concatMap :: (a -> [b]) -> [a] -> [b]
on concatMap(f, xs)
    set lng to length of xs
    set acc to {}
    tell mReturn(f)
        repeat with i from 1 to lng
            set acc to acc & (|λ|(item i of xs, i, xs))
        end repeat
    end tell
    if {text, string} contains class of xs then
        acc as text
    else
        acc
    end if
end concatMap


-- enumFromTo :: Int -> Int -> [Int]
on enumFromTo(m, n)
    if m ≤ n then
        set lst to {}
        repeat with i from m to n
            set end of lst to i
        end repeat
        return lst
    else
        return {}
    end if
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


-- if_ :: Bool -> a -> a -> a
on if_(bool, x, y)
    if bool then
        x
    else
        y
    end if
end if_


-- intercalateS :: String -> [String] -> String
on intercalateS(sep, xs)
    set {dlm, my text item delimiters} to {my text item delimiters, sep}
    set s to xs as text
    set my text item delimiters to dlm
    return s
end intercalateS


-- length :: [a] -> Int
on |length|(xs)
    length of xs
end |length|


-- max :: Ord a => a -> a -> a
on max(x, y)
    if x > y then
        x
    else
        y
    end if
end max


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


-- pred :: Enum a => a -> a
on pred(x)
    x - 1
end pred


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


-- reverse :: [a] -> [a]
on |reverse|(xs)
    if class of xs is text then
        (reverse of characters of xs) as text
    else
        reverse of xs
    end if
end |reverse|


-- Simplified version - assuming rows of unvarying length.
-- transpose :: [[a]] -> [[a]]
on transpose(rows)
    script cols
        on |λ|(_, iCol)
            script cell
                on |λ|(row)
                    item iCol of row
                end |λ|
            end script
            concatMap(cell, rows)
        end |λ|
    end script
    map(cols, item 1 of rows)
end transpose


-- unlines :: [String] -> String
on unlines(xs)
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, linefeed}
    set str to xs as text
    set my text item delimiters to dlm
    str
end unlines


-- unwords :: [String] -> String
on unwords(xs)
    intercalateS(space, xs)
end unwords
