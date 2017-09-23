use framework "Foundation" -- Yosemite onwards – for splitting by regex

-- SPARKLINE -----------------------------------------------------------------

-- sparkLine :: [Num] -> String
on sparkLine(xs)
    set min to minimumBy(my numericOrdering, xs)
    set max to maximumBy(my numericOrdering, xs)
    set dataRange to max - min

    -- scale :: Num -> Num
    script scale
        on |λ|(x)
            ((x - min) * 7) / dataRange
        end |λ|
    end script

    -- bucket :: Num -> String
    script bucket
        on |λ|(n)
            if n ≥ 0 and n < 8 then
                item (n + 1 as integer) of "▁▂▃▄▅▆▇█"
            else
                missing value
            end if
        end |λ|
    end script

    intercalate("", map(bucket, map(scale, xs)))
end sparkLine

-- numericOrdering :: Num -> Num -> (-1 | 0 | 1)
on numericOrdering(a, b)
    if a < b then
        -1
    else
        if a > b then
            1
        else
            0
        end if
    end if
end numericOrdering


-- TEST ----------------------------------------------------------------------
on run

    -- splitNumbers :: String -> [Real]
    script splitNumbers
        script asReal
            on |λ|(x)
                x as real
            end |λ|
        end script

        on |λ|(s)
            map(asReal, splitRegex("[\\s,]+", s))
        end |λ|
    end script

    map(sparkLine, map(splitNumbers, ["1 2 3 4 5 6 7 8 7 6 5 4 3 2 1", ¬
        "1.5, 0.5 3.5, 2.5 5.5, 4.5 7.5, 6.5", ¬
        "3 2 1 0 -1 -2 -3 -4 -3 -2 -1 0 1 2 3", ¬
        "-1000 100 1000 500 200 -400 -700 621 -189 3"]))

    -- {"▁▂▃▄▅▆▇█▇▆▅▄▃▂▁","▂▁▄▃▆▅█▇","█▇▆▅▄▃▂▁▂▃▄▅▆▇█","▁▅█▆▅▃▂▇▄▅"}
end run


-- GENERIC LIBRARY FUNCTIONS -------------------------------------------------

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
    script max
        property cmp : f
        on |λ|(a, b)
            if a is missing value or cmp(a, b) < 0 then
                b
            else
                a
            end if
        end |λ|
    end script

    foldl(max, missing value, xs)
end maximumBy

-- minimumBy :: (a -> a -> Ordering) -> [a] -> a
on minimumBy(f, xs)
    script min
        property cmp : f
        on |λ|(a, b)
            if a is missing value or cmp(a, b) > 0 then
                b
            else
                a
            end if
        end |λ|
    end script

    foldl(min, missing value, xs)
end minimumBy

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

-- regexMatches :: RegexPattern -> String -> [{location:Int, length:Int}]
on regexMatches(strRegex, str)
    set ca to current application
    set oRgx to ca's NSRegularExpression's regularExpressionWithPattern:strRegex ¬
        options:((ca's NSRegularExpressionAnchorsMatchLines as integer)) |error|:(missing value)
    set oString to ca's NSString's stringWithString:str
    set oMatches to oRgx's matchesInString:oString options:0 range:{location:0, |length|:oString's |length|()}

    set lstMatches to {}
    set lng to count of oMatches
    repeat with i from 1 to lng
        set end of lstMatches to range() of item i of oMatches
    end repeat
    lstMatches
end regexMatches

-- splitRegex :: RegexPattern -> String -> [String]
on splitRegex(strRegex, str)
    set lstMatches to regexMatches(strRegex, str)
    if length of lstMatches > 0 then
        script preceding
            on |λ|(a, x)
                set iFrom to start of a
                set iLocn to (location of x)

                if iLocn > iFrom then
                    set strPart to text (iFrom + 1) thru iLocn of str
                else
                    set strPart to ""
                end if
                {parts:parts of a & strPart, start:iLocn + (length of x) - 1}
            end |λ|
        end script

        set recLast to foldl(preceding, {parts:[], start:0}, lstMatches)

        set iFinal to start of recLast
        if iFinal < length of str then
            parts of recLast & text (iFinal + 1) thru -1 of str
        else
            parts of recLast & ""
        end if
    else
        {str}
    end if
end splitRegex
