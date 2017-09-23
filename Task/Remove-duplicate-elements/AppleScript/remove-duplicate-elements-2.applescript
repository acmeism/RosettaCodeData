-- CASE-INSENSITIVE UNIQUE ELEMENTS ------------------------------------------

-- nub :: [a] -> [a]
on nub(xs)
    -- Eq :: a -> a -> Bool
    script Eq
        on |λ|(x, y)
            ignoring case
                x = y
            end ignoring
        end |λ|
    end script

    nubBy(Eq, xs)
end nub


-- TEST ----------------------------------------------------------------------
on run
    {intercalate(space, ¬
        nub(splitOn(space, "4 3 2 8 0 1 9 5 1 7 6 3 9 9 4 2 1 5 3 2"))), ¬
        intercalate("", ¬
            nub(characters of "abcabc ABCABC"))}

    --> {"4 3 2 8 0 1 9 5 7 6", "abc "}
end run


-- GENERIC FUNCTIONS ---------------------------------------------------------

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

-- nubBy :: (a -> a -> Bool) -> [a] -> [a]
on nubBy(fnEq, xxs)

    set lng to length of xxs
    if lng > 1 then
        set x to item 1 of xxs
        set xs to items 2 thru -1 of xxs
        set p to mReturn(fnEq)

        -- notEq :: a -> Bool
        script notEq
            on |λ|(a)
                not (p's |λ|(a, x))
            end |λ|
        end script

        {x} & nubBy(fnEq, filter(notEq, xs))
    else
        xxs
    end if
end nubBy

-- splitOn :: Text -> Text -> [Text]
on splitOn(strDelim, strMain)
    set {dlm, my text item delimiters} to {my text item delimiters, strDelim}
    set lstParts to text items of strMain
    set my text item delimiters to dlm
    return lstParts
end splitOn
