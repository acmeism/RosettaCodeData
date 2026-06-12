----------------- MINIMUM NUMBER OF COINS ----------------

-- change :: [Int] -> Int -> [(Int, Int)]
on change(units, n)
    if {} = units or 0 = n then
        {}
    else
        set {x, xs} to {item 1 of units, rest of units}
        set q to n div x
        if 0 = q then
            change(xs, n)
        else
            {{q, x}} & change(xs, n mod x)
        end if
    end if
end change


--------------------------- TEST -------------------------
on run
    set coinReport to ¬
        showChange({200, 100, 50, 20, 10, 5, 2, 1})

    unlines(map(coinReport, {1024, 988}))
end run


-- showChange :: [Int] -> Int -> String
on showChange(units)
    script
        on |λ|(n)
            script go
                on |λ|(qd)
                    set {q, d} to qd
                    (q as text) & " * " & d as text
                end |λ|
            end script
            unlines({("Summing to " & n as text) & ":"} & ¬
                map(go, change(units, n))) & linefeed
        end |λ|
    end script
end showChange


------------------------- GENERIC ------------------------

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
