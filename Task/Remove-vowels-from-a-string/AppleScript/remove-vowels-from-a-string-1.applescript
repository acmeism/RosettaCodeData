------- REMOVE A DEFINED SUBSET OF GLYPHS FROM A TEXT ------

-- exceptGlyphs :: String -> String -> Bool
on exceptGlyphs(exclusions, s)
    script go
        on |λ|(c)
            if exclusions contains c then
                {}
            else
                {c}
            end if
        end |λ|
    end script

    concatMap(go, s)
end exceptGlyphs


-- Or, in terms of a general filter function:

-- exceptGlyphs2 :: String -> String -> Bool
on exceptGlyphs2(exclusions, s)
    script p
        on |λ|(c)
            exclusions does not contain c
        end |λ|
    end script

    filter(p, s)
end exceptGlyphs2



---------------------------- TEST --------------------------
on run
    set txt to unlines({¬
        "Rosetta Code is a programming chrestomathy site. ", ¬
        "The idea is to present solutions to the same ", ¬
        "task in as many different languages as possible, ", ¬
        "to demonstrate how languages are similar and ", ¬
        "different, and to aid a person with a grounding ", ¬
        "in one approach to a problem in learning another."})

    exceptGlyphs("eau", txt)
end run



--------------------- LIBRARY FUNCTIONS --------------------

-- concatMap :: (a -> [b]) -> [a] -> [b]
on concatMap(f, xs)
    set lng to length of xs
    set acc to {}
    tell mReturn(f)
        repeat with i from 1 to lng
            set acc to acc & (|λ|(item i of xs, i, xs))
        end repeat
    end tell
    if {text, string} contains class of xs then
        acc as text
    else
        acc
    end if
end concatMap


-- filter :: (a -> Bool) -> [a] -> [a]
on filter(p, xs)
    tell mReturn(p)
        set lst to {}
        set lng to length of xs
        repeat with i from 1 to lng
            set v to item i of xs
            if |λ|(v, i, xs) then set end of lst to v
        end repeat
        if {text, string} contains class of xs then
            lst as text
        else
            lst
        end if
    end tell
end filter


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
