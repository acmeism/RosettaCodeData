-- _reverse :: [a] -> [a]
on _reverse(xs)
    if class of xs is text then
        (reverse of characters of xs) as text
    else
        reverse of xs
    end if
end _reverse


-- TEST

on run {}
    set phrase to "rosetta code phrase reversal"

    unlines({¬
        _reverse(phrase), ¬
        unwords(map(_reverse, _words(phrase))), ¬
        unwords(_reverse(_words(phrase)))})
end run



-- GENERIC FUNCTIONS

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

-- _words :: String -> [String]
on _words(str)
    words of str
end _words

-- unlines :: [String] -> String
on unlines(lstLines)
    intercalate(linefeed, lstLines)
end unlines

-- unwords :: [String] -> String
on unwords(lstWords)
    intercalate(space, lstWords)
end unwords

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
