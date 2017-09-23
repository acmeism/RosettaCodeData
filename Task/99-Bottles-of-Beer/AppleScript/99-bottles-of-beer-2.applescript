-- BRIEF -----------------------------------------------------------------------
on run
    set localisations to ¬
        {"on the wall", ¬
            "Take one down, pass it around", ¬
            "Better go to the store to buy some more", "bottle"}

    intercalate("\n\n", ¬
        (map(curry(incantation)'s |λ|(localisations), enumFromTo(99, 0))))
end run


-- DECLARATIVE -----------------------------------------------------------------

-- incantation :: [String] -> Int -> String
on incantation(xs, n)
    script asset
        on |λ|(n)
            unwords({(n as string), item -1 of xs & cond(n ≠ 1, "s", "")})
        end |λ|
    end script

    script store
        on |λ|(n)
            unwords({asset's |λ|(n), item 1 of xs})
        end |λ|
    end script

    set {distribute, solve} to items 2 thru 3 of xs
    if n > 0 then
        unlines({store's |λ|(n), asset's |λ|(n), distribute, store's |λ|(n - 1)})
    else
        solve
    end if
end incantation


-- GENERICALLY DYSFUNCTIONAL ---------------------------------------------------

-- cond :: Bool -> a -> a -> a
on cond(bln, f, g)
    if bln then
        f
    else
        g
    end if
end cond

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

-- enumFromTo :: Int -> Int -> [Int]
on enumFromTo(m, n)
    if m > n then
        set d to -1
    else
        set d to 1
    end if
    set lst to {}
    repeat with i from m to n by d
        set end of lst to i
    end repeat
    return lst
end enumFromTo

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

-- unlines :: [String] -> String
on unlines(xs)
    intercalate(linefeed, xs)
end unlines

-- unwords :: [String] -> String
on unwords(xs)
    intercalate(space, xs)
end unwords
