on run
    script
        on |λ|(x)
            script
                on |λ|(y)
                    script
                        on |λ|(z)
                            if y ≠ z and 1 ≤ z and z ≤ 7 then
                                {{x, y, z} as string}
                            else
                                {}
                            end if
                        end |λ|
                    end script

                    concatMap(result, {12 - (x + y)}) --Z
                end |λ|
            end script

            concatMap(result, {1, 2, 3, 4, 5, 6, 7}) --Y
        end |λ|
    end script

    unlines(concatMap(result, {2, 4, 6})) --X
end run


-- GENERIC FUNCTIONS ----------------------------------------------------------

-- concatMap :: (a -> [b]) -> [a] -> [b]
on concatMap(f, xs)
    set lst to {}
    set lng to length of xs
    tell mReturn(f)
        repeat with i from 1 to lng
            set lst to (lst & |λ|(contents of item i of xs, i, xs))
        end repeat
    end tell
    return lst
end concatMap

-- intercalate :: Text -> [Text] -> Text
on intercalate(strText, lstText)
    set {dlm, my text item delimiters} to {my text item delimiters, strText}
    set strJoined to lstText as text
    set my text item delimiters to dlm
    return strJoined
end intercalate

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
