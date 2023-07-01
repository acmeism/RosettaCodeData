use framework "Foundation"

-- TEST -----------------------------------------------------------------------
on run

    ap({toLower, toTitle, toUpper}, {"alphaBETA αβγδΕΖΗΘ"})

    --> {"alphabeta αβγδεζηθ", "Alphabeta Αβγδεζηθ", "ALPHABETA ΑΒΓΔΕΖΗΘ"}

end run


-- GENERIC FUNCTIONS ----------------------------------------------------------

-- toLower :: String -> String
on toLower(str)
    set ca to current application
    ((ca's NSString's stringWithString:(str))'s ¬
        lowercaseStringWithLocale:(ca's NSLocale's currentLocale())) as text
end toLower

-- toTitle :: String -> String
on toTitle(str)
    set ca to current application
    ((ca's NSString's stringWithString:(str))'s ¬
        capitalizedStringWithLocale:(ca's NSLocale's currentLocale())) as text
end toTitle

-- toUpper :: String -> String
on toUpper(str)
    set ca to current application
    ((ca's NSString's stringWithString:(str))'s ¬
        uppercaseStringWithLocale:(ca's NSLocale's currentLocale())) as text
end toUpper

-- A list of functions applied to a list of arguments
-- (<*> | ap) :: [(a -> b)] -> [a] -> [b]
on ap(fs, xs)
    set {nf, nx} to {length of fs, length of xs}
    set lst to {}
    repeat with i from 1 to nf
        tell mReturn(item i of fs)
            repeat with j from 1 to nx
                set end of lst to |λ|(contents of (item j of xs))
            end repeat
        end tell
    end repeat
    return lst
end ap

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
