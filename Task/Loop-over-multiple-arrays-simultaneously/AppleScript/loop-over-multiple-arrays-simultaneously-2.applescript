-- CONCAT MAPPED OVER A TRANSPOSITION ----------------------------------------
on run

    unlines(map(concat, transpose([["a", "b", "c"], ["A", "B", "C"], [1, 2, 3]])))

end run

-- GENERIC FUNCTIONS ---------------------------------------------------------

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

-- intercalate :: String -> [String] -> String
on intercalate(s, xs)
    set {dlm, my text item delimiters} to {my text item delimiters, s}
    set str to xs as text
    set my text item delimiters to dlm
    return str
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

-- transpose :: [[a]] -> [[a]]
on transpose(xss)
    script column
        on |λ|(_, iCol)
            script row
                on |λ|(xs)
                    item iCol of xs
                end |λ|
            end script

            map(row, xss)
        end |λ|
    end script

    map(column, item 1 of xss)
end transpose

-- unlines :: [String] -> String
on unlines(xs)
    intercalate(linefeed, xs)
end unlines
