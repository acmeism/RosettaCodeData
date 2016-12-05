use framework "Foundation" -- Yosemite onwards, for the toLowerCase() function

-- Kelvin to other scale

-- kelvinAs :: ScaleName -> Num -> Num
on kelvinAs(strOtherScale, n)
    heatBabel(n, "Kelvin", strOtherScale)
end kelvinAs


-- More general conversion

-- heatBabel :: n -> ScaleName -> ScaleName -> Num
on heatBabel(n, strFromScale, strToScale)
    set ratio to 9 / 5
    set cels to 273.15
    set fahr to 459.67

    script reading
        on lambda(x, strFrom)
            if strFrom = "k" then
                x as real
            else if strFrom = "c" then
                x + cels
            else if strFrom = "f" then
                (fahr + x) * ratio
            else
                x / ratio
            end if
        end lambda
    end script

    script writing
        on lambda(x, strTo)
            if strTo = "k" then
                x
            else if strTo = "c" then
                x - cels
            else if strTo = "f" then
                (x * ratio) - fahr
            else
                x * ratio
            end if
        end lambda
    end script

    writing's lambda(reading's lambda(n, ¬
        toLowerCase(text 1 of strFromScale)), ¬
        toLowerCase(text 1 of strToScale))
end heatBabel


-- TEST

on kelvinTranslations(n)
    script translations
        on lambda(x)
            {x, kelvinAs(x, n)}
        end lambda
    end script

    map(translations, {"K", "C", "F", "R"})
end kelvinTranslations

on run
    script tabbed
        on lambda(x)
            intercalate(tab, x)
        end lambda
    end script

    intercalate(linefeed, map(tabbed, kelvinTranslations(21)))
end run



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
