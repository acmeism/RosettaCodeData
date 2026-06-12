--------------- FIRST MISSING NATURAL NUMBER -------------

-- firstGap :: [Int] -> Int
on firstGap(xs)
    script p
        on |λ|(x)
            xs does not contain x
        end |λ|
    end script

    find(p, enumFrom(1))
end firstGap


--------------------------- TEST -------------------------
on run
    script test
        on |λ|(xs)
            showList(xs) & " -> " & (firstGap(xs) as string)
        end |λ|
    end script

    unlines(map(test, ¬
        {{1, 2, 0}, {3, 4, -1, 1}, {7, 8, 9, 11, 12}}))

    --> {1, 2, 0} -> 3
    --> {3, 4, -1, 1} -> 2
    --> {7, 8, 9, 11, 12} -> 1
end run


------------------------- GENERIC ------------------------

-- enumFrom :: Enum a => a -> [a]
on enumFrom(x)
    script
        property v : missing value
        on |λ|()
            if missing value is not v then
                set v to 1 + v
            else
                set v to x
            end if
            return v
        end |λ|
    end script
end enumFrom


-- find :: (a -> Bool) -> Gen [a] -> Maybe a
on find(p, gen)
    -- The first match for the predicate p
    -- in the generator stream gen, or missing value
    -- if no match is found.
    set mp to mReturn(p)
    set v to gen's |λ|()
    repeat until missing value is v or (|λ|(v) of mp)
        set v to (|λ|() of gen)
    end repeat
    v
end find


-- intercalate :: String -> [String] -> String
on intercalate(delim, xs)
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, delim}
    set s to xs as text
    set my text item delimiters to dlm
    s
end intercalate


-- map :: (a -> b) -> [a] -> [b]
on map(f, xs)
    -- The list obtained by applying f
    -- to each element of xs.
    tell mReturn(f)
        set lng to length of xs
        set lst to {}
        repeat with i from 1 to lng
            set end of lst to |λ|(item i of xs, i, xs)
        end repeat
        return lst
    end tell
end map


-- mReturn :: First-class m => (a -> b) -> m (a -> b)
on mReturn(f)
    -- 2nd class handler function lifted into 1st class script wrapper.
    if script is class of f then
        f
    else
        script
            property |λ| : f
        end script
    end if
end mReturn


-- showList :: [a] -> String
on showList(xs)
    script go
        on |λ|(x)
            x as string
        end |λ|
    end script
    "{" & intercalate(", ", map(go, xs)) & "}"
end showList


-- unlines :: [String] -> String
on unlines(xs)
    -- A single string formed by the intercalation
    -- of a list of strings with the newline character.
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, linefeed}
    set s to xs as text
    set my text item delimiters to dlm
    s
end unlines
