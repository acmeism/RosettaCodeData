--------------------- NESTED FUNCTION --------------------

-- makeList :: String -> String
on makeList(separator)
    set counter to 0

    -- makeItem :: String -> String
    script makeItem
        on |λ|(x)
            set counter to counter + 1

            (counter & separator & x & linefeed) as string
        end |λ|
    end script

    map(makeItem, ["first", "second", "third"]) as string
end makeList

--------------------------- TEST -------------------------
on run

    makeList(". ")

end run


-------------------- GENERIC FUNCTIONS -------------------

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
