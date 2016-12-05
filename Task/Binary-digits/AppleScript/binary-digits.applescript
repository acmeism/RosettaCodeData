-- binaryString :: Int -> String
on binaryString(n)

    showIntAtBase(2, n)

end binaryString


-- showIntAtBase :: Int -> Int -> String
on showIntAtBase(base, n)
    if base > 1 then
        if n > 0 then
            set m to n mod base
            set r to n - m
            if r > 0 then
                set prefix to showIntAtBase(base, r div base)
            else
                set prefix to ""
            end if

            if m < 10 then
                set baseCode to 48 -- "0"
            else
                set baseCode to 55 -- "A" - 10
            end if

            prefix & character id (baseCode + m)
        else
            "0"
        end if
    else
        missing value
    end if
end showIntAtBase


-- TEST
on run

    intercalate(linefeed, ¬
        map(binaryString, [5, 50, 9000]))

end run




-- GENERIC FUNCTIONS FOR TESTING

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
            property lambda : f
        end script
    end if
end mReturn
