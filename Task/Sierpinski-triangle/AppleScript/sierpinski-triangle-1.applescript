------------------- SIERPINKSI TRIANGLE ------------------

-- sierpinski :: Int -> [String]
on sierpinski(n)
    if n > 0 then
        set previous to sierpinski(n - 1)
        set padding to replicate(2 ^ (n - 1), space)

        script alignedCentre
            on |λ|(s)
                concat(padding & s & padding)
            end |λ|
        end script

        script adjacentDuplicates
            on |λ|(s)
                unwords(replicate(2, s))
            end |λ|
        end script

        -- Previous triangle block centered,
        -- and placed on 2 adjacent duplicates.
        map(alignedCentre, previous) & map(adjacentDuplicates, previous)
    else
        {"*"}
    end if
end sierpinski


--------------------------- TEST -------------------------
on run
    unlines(sierpinski(4))
end run

-------------------- GENERIC FUNCTIONS -------------------

-- concat :: [[a]] -> [a] | [String] -> String
on concat(xs)
    if length of xs > 0 and class of (item 1 of xs) is string then
        set acc to ""
    else
        set acc to {}
    end if
    repeat with i from 1 to length of xs
        set acc to acc & item i of xs
    end repeat
    acc
end concat

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

-- replicate :: Int -> a -> [a]
on replicate(n, a)
    set out to {}
    if n < 1 then return out
    set dbl to {a}

    repeat while (n > 1)
        if (n mod 2) > 0 then set out to out & dbl
        set n to (n div 2)
        set dbl to (dbl & dbl)
    end repeat
    return out & dbl
end replicate

-- unlines, unwords :: [String] -> String
on unlines(xs)
    intercalate(linefeed, xs)
end unlines

on unwords(xs)
    intercalate(space, xs)
end unwords
