----------------------- COMBINATIONS ---------------------

-- comb :: Int -> [a] -> [[a]]
on comb(n, lst)
    if 1 > n then
        {{}}
    else
        if not isNull(lst) then
            set {h, xs} to uncons(lst)

            map(cons(h), ¬
                comb(n - 1, xs)) & comb(n, xs)
        else
            {}
        end if
    end if
end comb

--------------------------- TEST -------------------------
on run

    intercalate(linefeed, ¬
        map(unwords, comb(3, enumFromTo(0, 4))))

end run

-------------------- GENERIC FUNCTIONS -------------------

-- cons :: a -> [a] -> [a]
on cons(x)
    script
        on |λ|(xs)
            {x} & xs
        end |λ|
    end script
end cons

-- enumFromTo :: Int -> Int -> [Int]
on enumFromTo(m, n)
    if m ≤ n then
        set lst to {}
        repeat with i from m to n
            set end of lst to i
        end repeat
        lst
    else
        {}
    end if
end enumFromTo

-- intercalate :: Text -> [Text] -> Text
on intercalate(strText, lstText)
    set {dlm, my text item delimiters} to {my text item delimiters, strText}
    set strJoined to lstText as text
    set my text item delimiters to dlm
    return strJoined
end intercalate

-- isNull :: [a] -> Bool
on isNull(xs)
    if class of xs is string then
        xs = ""
    else
        xs = {}
    end if
end isNull

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

-- uncons :: [a] -> Maybe (a, [a])
on uncons(xs)
    set lng to length of xs
    if lng > 0 then
        if class of xs is string then
            set cs to text items of xs
            {item 1 of cs, rest of cs}
        else
            {item 1 of xs, rest of xs}
        end if
    else
        missing value
    end if
end uncons

-- unwords :: [String] -> String
on unwords(xs)
    intercalate(space, xs)
end unwords
