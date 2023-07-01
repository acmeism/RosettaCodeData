-- stripChars :: String -> String -> String
on stripChars(needles, haystack)
    script notNeedles
        on |λ|(x)
            needles does not contain x
        end |λ|
    end script

    intercalate("", filter(notNeedles, haystack))
end stripChars


--------------------------- TEST -------------------------
on run

    stripChars("aei", "She was a soul stripper. She took my heart!")

    --> "Sh ws  soul strppr. Sh took my hrt!"
end run


-------------------- GENERIC FUNCTIONS -------------------

-- filter :: (a -> Bool) -> [a] -> [a]
on filter(f, xs)
    tell mReturn(f)
        set lst to {}
        set lng to length of xs
        repeat with i from 1 to lng
            set v to item i of xs
            if |λ|(v, i, xs) then set end of lst to v
        end repeat
        return lst
    end tell
end filter


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
