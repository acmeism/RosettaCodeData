use framework "Foundation"


-- isPalindrome :: String -> Bool
on isPalindrome(s)
    s = intercalate("", reverse of characters of s)
end isPalindrome



-- TEST

on run

    isPalindrome(lowerCaseNoSpace("In girum imus nocte et consumimur igni"))

    --> true

end run

-- lowerCaseNoSpace :: String -> String
on lowerCaseNoSpace(s)
    script notSpace
        on lambda(s)
            s is not space
        end lambda
    end script

    intercalate("", filter(notSpace, characters of toLowerCase(s)))
end lowerCaseNoSpace


-- GENERIC LIBRARY FUNCTIONS

-- toLowerCase :: String -> String
on toLowerCase(str)
    set ca to current application
    ((ca's NSString's stringWithString:(str))'s ¬
        lowercaseStringWithLocale:(ca's NSLocale's currentLocale())) as text
end toLowerCase

-- intercalate :: Text -> [Text] -> Text
on intercalate(strText, lstText)
    set {dlm, my text item delimiters} to {my text item delimiters, strText}
    set strJoined to lstText as text
    set my text item delimiters to dlm
    return strJoined
end intercalate

-- filter :: (a -> Bool) -> [a] -> [a]
on filter(f, xs)
    tell mReturn(f)
        set lst to {}
        set lng to length of xs
        repeat with i from 1 to lng
            set v to item i of xs
            if lambda(v, i, xs) then set end of lst to v
        end repeat
        return lst
    end tell
end filter

-- Lift 2nd class handler function into 1st class script wrapper
-- mReturn :: Handler -> Script
on mReturn(f)
    if class of f is script then
        f
    else
        script
            property lambda : f
        end script
    end if
end mReturn
