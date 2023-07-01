use framework "Foundation" -- ( for case conversion function )

--------------------- PANGRAM CHECKER --------------------

-- isPangram :: String -> Bool
on isPangram(s)
    script charUnUsed
        property lowerCaseString : my toLower(s)
        on |λ|(c)
            lowerCaseString does not contain c
        end |λ|
    end script

    0 = length of filter(charUnUsed, ¬
        "abcdefghijklmnopqrstuvwxyz")
end isPangram


--------------------------- TEST -------------------------
on run
    map(isPangram, {¬
        "is this a pangram", ¬
        "The quick brown fox jumps over the lazy dog"})

    --> {false, true}
end run


-------------------- GENERIC FUNCTIONS -------------------

-- filter :: (a -> Bool) -> [a] -> [a]
on filter(f, xs)
    tell mReturn(f)
        set lst to {}
        set lng to length of xs
        repeat with i from 1 to lng
            set v to item i of xs
            if |λ|(v, i, xs) then set end of lst to v
        end repeat
        return lst
    end tell
end filter


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


-- Lift 2nd class handler function into
-- 1st class script wrapper
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


-- toLower :: String -> String
on toLower(str)
    set ca to current application
    ((ca's NSString's stringWithString:(str))'s ¬
        lowercaseStringWithLocale:(ca's NSLocale's currentLocale())) as text
end toLower
