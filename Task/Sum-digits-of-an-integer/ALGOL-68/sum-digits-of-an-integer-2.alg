-- INTEGER DIGITS SUMMED -----------------------------------------------------

-- digitsSummed :: (Int | String) -> Int
on digitsSummed(n)

    -- digitAdded :: Int -> String -> Int
    script digitAdded

        -- Numeric values of known glyphs: 0-9 A-Z a-z
        -- digitValue :: String -> Int
        on digitValue(s)
            set i to id of s
            if i > 47 and i < 123 then -- 0-z
                if i < 58 then -- 0-9
                    i - 48
                else if i > 96 then -- a-z
                    i - 87
                else if i > 64 and i < 91 then -- A-Z
                    i - 55
                else -- unknown glyph
                    0
                end if
            else -- unknown glyph
                0
            end if
        end digitValue

        on |λ|(accumulator, strDigit)
            accumulator + digitValue(strDigit)
        end |λ|
    end script

    foldl(digitAdded, 0, splitOn("", n as string))
end digitsSummed


-- TEST ----------------------------------------------------------------------
on run
    -- showDigitSum :: Int -> String
    script showDigitSum
        on |λ|(n)
            (n as string) & " -> " & digitsSummed(n)
        end |λ|
    end script

    intercalate(linefeed, ¬
        map(showDigitSum, [1, 1234, "254", "fe", "f0e", "999ABCXYZ"]))
end run


-- GENERIC FUNCTIONS ---------------------------------------------------------

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

-- splitOn :: Text -> Text -> [Text]
on splitOn(strDelim, strMain)
    set {dlm, my text item delimiters} to {my text item delimiters, strDelim}
    set xs to text items of strMain
    set my text item delimiters to dlm
    return xs
end splitOn
