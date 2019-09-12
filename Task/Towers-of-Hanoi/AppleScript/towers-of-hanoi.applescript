-- hanoi :: Int -> (String, String, String) -> [(String, String)]
on hanoi(n, abc)
    script go
        on |λ|(n, {x, y, z})
            if n > 0 then
                |λ|(n - 1, {x, z, y}) & ¬
                    {{x, y}} & |λ|(n - 1, {z, y, x})
            else
                {}
            end if
        end |λ|
    end script
    go's |λ|(n, abc)
end hanoi

-- TEST ---------------------------------------------------
on run
    script arrow
        on |λ|(abc)
            item 1 of abc & " -> " & item 2 of abc
        end |λ|
    end script

    unlines(map(arrow, ¬
        hanoi(3, {"left", "right", "mid"})))
end run


-- GENERIC FUNCTIONS --------------------------------------

-- Lift 2nd class handler function into 1st class script wrapper
-- mReturn :: First-class m => (a -> b) -> m (a -> b)
on mReturn(f)
    if class of f is script then
        f
    else
        script
            property |λ| : f
        end script
    end if
end mReturn

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

-- unlines :: [String] -> String
on unlines(xs)
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, linefeed}
    set str to xs as text
    set my text item delimiters to dlm
    str
end unlines
