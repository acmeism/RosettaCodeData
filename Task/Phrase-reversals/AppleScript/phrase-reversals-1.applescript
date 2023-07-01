-- REVERSED PHRASES, COMPONENT WORDS, AND WORD ORDER ---------------------

-- reverseString, reverseEachWord, reverseWordOrder :: String -> String
on stringReverse(s)
    |reverse|(s)
end stringReverse

on reverseEachWord(s)
    wordLevel(curry(my map)'s |λ|(my |reverse|))'s |λ|(s)
end reverseEachWord

on reverseWordOrder(s)
    wordLevel(my |reverse|)'s |λ|(s)
end reverseWordOrder


-- wordLevel :: ([String] -> [String]) -> String -> String
on wordLevel(f)
    script
        on |λ|(x)
            unwords(mReturn(f)'s |λ|(|words|(x)))
        end |λ|
    end script
end wordLevel


-- TEST ----------------------------------------------------------------------
on run
    unlines(|<*>|({stringReverse, reverseEachWord, reverseWordOrder}, ¬
        {"rosetta code phrase reversal"}))

    -->

    --     "lasrever esarhp edoc attesor
    --      attesor edoc esarhp lasrever
    --      reversal phrase code rosetta"
end run


-- GENERIC FUNCTIONS ---------------------------------------------------------

-- A list of functions applied to a list of arguments
-- (<*> | ap) :: [(a -> b)] -> [a] -> [b]
on |<*>|(fs, xs)
    set {nf, nx} to {length of fs, length of xs}
    set acc to {}
    repeat with i from 1 to nf
        tell mReturn(item i of fs)
            repeat with j from 1 to nx
                set end of acc to |λ|(contents of (item j of xs))
            end repeat
        end tell
    end repeat
    return acc
end |<*>|

-- curry :: (Script|Handler) -> Script
on curry(f)
    script
        on |λ|(a)
            script
                on |λ|(b)
                    |λ|(a, b) of mReturn(f)
                end |λ|
            end script
        end |λ|
    end script
end curry

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

-- reverse :: [a] -> [a]
on |reverse|(xs)
    if class of xs is text then
        (reverse of characters of xs) as text
    else
        reverse of xs
    end if
end |reverse|

-- words :: String -> [String]
on |words|(s)
    words of s
end |words|

-- unlines :: [String] -> String
on unlines(lstLines)
    intercalate(linefeed, lstLines)
end unlines

-- unwords :: [String] -> String
on unwords(lstWords)
    intercalate(space, lstWords)
end unwords
