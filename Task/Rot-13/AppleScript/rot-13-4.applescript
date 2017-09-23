-- ROT 13 --------------------------------------------------------------------

-- rot13 :: String -> String
on rot13(str)
    script rt13
        on |λ|(x)
            if (x ≥ "a" and x ≤ "m") or (x ≥ "A" and x ≤ "M") then
                character id ((id of x) + 13)
            else if (x ≥ "n" and x ≤ "z") or (x ≥ "N" and x ≤ "Z") then
                character id ((id of x) - 13)
            else
                x
            end if
        end |λ|
    end script

    intercalate("", map(rt13, characters of str))
end rot13


-- TEST ----------------------------------------------------------------------
on run
    rot13("nowhere ABJURER")

    -->  "abjurer NOWHERE"
end run


-- GENERIC FUNCTIONS ---------------------------------------------------------

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

-- intercalate :: Text -> [Text] -> Text
on intercalate(strText, lstText)
    set {dlm, my text item delimiters} to {my text item delimiters, strText}
    set strJoined to lstText as text
    set my text item delimiters to dlm
    return strJoined
end intercalate

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
