-- ZIP LISTS WITH FUNCTION ---------------------------------------------------

-- zipListsWith :: ([a] -> b) -> [[a]] -> [[b]]
on zipListsWith(f, xss)
    set n to length of xss

    script
        on |λ|(_, i)
            script
                on |λ|(xs)
                    item i of xs
                end |λ|
            end script

            if i ≤ n then
                apply(f, (map(result, xss)))
            else
                {}
            end if
        end |λ|
    end script

    if n > 0 then
        map(result, item 1 of xss)
    else
        []
    end if
end zipListsWith


-- TEST  ( zip lists with concat ) -------------------------------------------
on run

    intercalate(linefeed, ¬
        zipListsWith(concat, ¬
            [["a", "b", "c"], ["A", "B", "C"], [1, 2, 3]]))

end run


-- GENERIC FUNCTIONS ---------------------------------------------------------

-- apply (a -> b) -> a -> b
on apply(f, a)
    mReturn(f)'s |λ|(a)
end apply

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
