on run

    unlines(map(reverseWords, |lines|("---------- Ice and Fire ------------

fire, in end will world the say Some
ice. in say Some
desire of tasted I've what From
fire. favor who those with hold I

... elided paragraph last ...

Frost Robert -----------------------")))

end run


-- GENERIC FUNCTIONS ---------------------------------------------------------

-- reverseWords :: String -> String
on reverseWords(str)
    unwords(|reverse|(|words|(str)))
end reverseWords

-- |reverse| :: [a] -> [a]
on |reverse|(xs)
    if class of xs is text then
        (reverse of characters of xs) as text
    else
        reverse of xs
    end if
end |reverse|

-- |lines| :: Text -> [Text]
on |lines|(str)
    splitOn(linefeed, str)
end |lines|

-- |words| :: Text -> [Text]
on |words|(str)
    splitOn(space, str)
end |words|

-- ulines :: [Text] -> Text
on unlines(lstLines)
    intercalate(linefeed, lstLines)
end unlines

-- unwords :: [Text] -> Text
on unwords(lstWords)
    intercalate(space, lstWords)
end unwords

-- splitOn :: Text -> Text -> [Text]
on splitOn(strDelim, strMain)
    set {dlm, my text item delimiters} to {my text item delimiters, strDelim}
    set lstParts to text items of strMain
    set my text item delimiters to dlm
    lstParts
end splitOn

-- interCalate :: Text -> [Text] -> Text
on intercalate(strText, lstText)
    set {dlm, my text item delimiters} to {my text item delimiters, strText}
    set strJoined to lstText as text
    set my text item delimiters to dlm
    strJoined
end intercalate

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
