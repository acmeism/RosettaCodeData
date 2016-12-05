use framework "Foundation"

-- toUpperCase :: Text -> Text
on toUpperCase(str)
    set ca to current application
    ((ca's NSString's stringWithString:(str))'s ¬
        uppercaseStringWithLocale:(ca's NSLocale's currentLocale())) as text
end toUpperCase

-- toLowerCase :: Text -> Text
on toLowerCase(str)
    set ca to current application
    ((ca's NSString's stringWithString:(str))'s ¬
        lowercaseStringWithLocale:(ca's NSLocale's currentLocale())) as text
end toLowerCase

-- toCapitalized :: Text -> Text
on toCapitalized(str)
    set ca to current application
    ((ca's NSString's stringWithString:(str))'s ¬
        capitalizedStringWithLocale:(ca's NSLocale's currentLocale())) as text
end toCapitalized


-- TEST
on run

    -- testCase :: Handler -> String
    script testCase
        on lambda(f)
            mReturn(f)'s lambda("alphaBETA αβγδΕΖΗΘ")
        end lambda
    end script

    map(testCase, {toUpperCase, toLowerCase, toCapitalized})

end run


-- GENERIC FUNCTIONS
-- map :: (a -> b) -> [a] -> [b]
on map(f, xs)
    tell mReturn(f)
        set lng to length of xs
        set lst to {}
        repeat with i from 1 to lng
            set end of lst to lambda(item i of xs, i, xs)
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
            property lambda : f
        end script
    end if
end mReturn
