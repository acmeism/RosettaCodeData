use framework "Foundation"

------ CASE-INSENSITIVE PALINDROME, IGNORING SPACES ? ----

-- isPalindrome :: String -> Bool
on isPalindrome(s)
    s = intercalate("", reverse of characters of s)
end isPalindrome

-- toSpaceFreeLower :: String -> String
on spaceFreeToLower(s)
    script notSpace
        on |λ|(s)
            s is not space
        end |λ|
    end script

    intercalate("", filter(notSpace, characters of toLower(s)))
end spaceFreeToLower


--------------------------- TEST -------------------------
on run

    isPalindrome(spaceFreeToLower("In girum imus nocte et consumimur igni"))

    --> true

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


-- toLower :: String -> String
on toLower(str)
    set ca to current application
    ((ca's NSString's stringWithString:(str))'s ¬
        lowercaseStringWithLocale:(ca's NSLocale's currentLocale())) as text
end toLower
