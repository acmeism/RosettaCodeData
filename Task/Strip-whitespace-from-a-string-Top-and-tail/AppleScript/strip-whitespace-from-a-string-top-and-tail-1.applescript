use framework "Foundation" -- "OS X" Yosemite onwards, for NSRegularExpression

-- STRIP WHITESPACE ----------------------------------------------------------

-- isSpace :: Char -> Bool
on isSpace(c)
    ((length of c) = 1) and regexTest("\\s", c)
end isSpace

-- stripStart :: Text -> Text
on stripStart(s)
    dropWhile(isSpace, s) as text
end stripStart

-- stripEnd :: Text -> Text
on stripEnd(s)
    dropWhileEnd(isSpace, s) as text
end stripEnd

-- strip :: Text -> Text
on strip(s)
    dropAround(isSpace, s) as text
end strip


-- TEST ----------------------------------------------------------------------
on run
    set strText to "  \t\t \n \r    Much Ado About Nothing \t \n \r  "

    script arrowed
        on |λ|(x)
            "-->" & x & "<--"
        end |λ|
    end script

    map(arrowed, [stripStart(strText), stripEnd(strText), strip(strText)])

    --     {"-->Much Ado About Nothing
    --
    --   <--", "-->
    --
    --     Much Ado About Nothing<--", "-->Much Ado About Nothing<--"}
end run


-- GENERIC FUNCTIONS ---------------------------------------------------------

-- dropAround :: (Char -> Bool) -> [a] -> [a]
on dropAround(p, xs)
    dropWhile(p, dropWhileEnd(p, xs))
end dropAround

-- dropWhile :: (a -> Bool) -> [a] -> [a]
on dropWhile(p, xs)
    tell mReturn(p)
        set lng to length of xs
        set i to 1
        repeat while i ≤ lng and |λ|(item i of xs)
            set i to i + 1
        end repeat
    end tell
    if i ≤ lng then
        items i thru lng of xs
    else
        {}
    end if
end dropWhile

-- dropWhileEnd :: (a -> Bool) -> [a] -> [a]
on dropWhileEnd(p, xs)
    tell mReturn(p)
        set i to length of xs
        repeat while i > 0 and |λ|(item i of xs)
            set i to i - 1
        end repeat
    end tell
    if i > 0 then
        items 1 thru i of xs
    else
        {}
    end if
end dropWhileEnd

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

-- regexTest :: RegexPattern -> String -> Bool
on regexTest(strRegex, str)
    set ca to current application
    set oString to ca's NSString's stringWithString:str
    ((ca's NSRegularExpression's regularExpressionWithPattern:strRegex ¬
        options:((ca's NSRegularExpressionAnchorsMatchLines as integer)) ¬
        |error|:(missing value))'s firstMatchInString:oString options:0 ¬
        range:{location:0, |length|:oString's |length|()}) is not missing value
end regexTest
