use framework "Foundation" -- ( for case conversion function )


-- isPangram :: String -> Bool
on isPangram(s)
    script charUnUsed
        property lowerCaseString : my toLowerCase(s)

        on lambda(c)
            lowerCaseString does not contain c
        end lambda
    end script

    length of filter(charUnUsed, "abcdefghijklmnopqrstuvwxyz") = 0
end isPangram


-- TEST

on run
    map(isPangram, {¬
        "is this a pangram", ¬
        "The quick brown fox jumps over the lazy dog"})

    --> {false, true}
end run


-- GENERIC HIGHER ORDER FUNCTIONS (FILTER AND MAP)

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

-- OBJC function: lowercaseStringWithLocale

-- toLowerCase :: String -> String
on toLowerCase(str)
    set ca to current application
    unwrap(wrap(str)'s ¬
        lowercaseStringWithLocale:(ca's NSLocale's currentLocale))
end toLowerCase

-- wrap :: AS value -> NSObject
on wrap(v)
    set ca to current application
    ca's (NSArray's arrayWithObject:v)'s objectAtIndex:0
end wrap

-- unwrap :: NSObject -> AS value
on unwrap(objCValue)
    if objCValue is missing value then
        return missing value
    else
        set ca to current application
        item 1 of ((ca's NSArray's arrayWithObject:objCValue) as list)
    end if
end unwrap
