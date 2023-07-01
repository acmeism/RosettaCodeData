-- iso8601Short :: Date -> String
on iso8601Short(dte)
    text 1 thru 10 of iso8601Local(dte)
end iso8601Short


-- longDate :: Date -> String
on longDate(dte)
    tell dte
        "" & its weekday & ", " & its month & " " & its day & ", " & year
    end tell
end longDate


---------------------------- TEST --------------------------
on run

    unlines(apList({iso8601Short, longDate}, ¬
        {current date}))

end run


-------------------------- GENERIC -------------------------


-- Each member of a list of functions applied to
-- each of a list of arguments, deriving a list of new values
-- apList (<*>) :: [(a -> b)] -> [a] -> [b]
on apList(fs, xs)
    set lst to {}
    repeat with f in fs
        tell mReturn(contents of f)
            repeat with x in xs
                set end of lst to |λ|(contents of x)
            end repeat
        end tell
    end repeat
    return lst
end apList


-- iso8601Local :: Date -> String
on iso8601Local(dte)
    (dte as «class isot» as string)
end iso8601Local


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
