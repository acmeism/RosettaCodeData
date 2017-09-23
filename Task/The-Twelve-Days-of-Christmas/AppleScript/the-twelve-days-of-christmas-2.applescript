use framework "Foundation"

property pstrGifts : "A partridge in a pear tree, Two turtle doves, Three French hens, " & ¬
    "Four calling birds, Five golden rings, Six geese a-laying, " & ¬
    "Seven swans a-swimming, Eight maids a-milking, Nine ladies dancing, " & ¬
    "Ten lords a-leaping, Eleven pipers piping, Twelve drummers drumming"

property pstrOrdinals : "first, second, third, fourth, fifth, " & ¬
    "sixth, seventh, eighth, ninth, tenth, eleventh, twelfth"

-- DAYS OF XMAS ------------------------------------------------------------

-- daysOfXmas :: () -> String
on daysOfXmas()

    -- csv :: String -> [String]
    script csv
        on |λ|(str)
            splitOn(", ", str)
        end |λ|
    end script

    set {gifts, ordinals} to map(csv, [pstrGifts, pstrOrdinals])

    -- verseOfTheDay :: Int -> String
    script verseOfTheDay

        -- dayGift :: Int -> String
        script dayGift
            on |λ|(n, i)
                set strGift to item n of gifts
                if n = 1 then
                    set strFirst to strGift & " !"
                    if i is not 1 then
                        "And " & toLower(text 1 of strFirst) & text 2 thru -1 of strFirst
                    else
                        strFirst
                    end if
                else if n = 5 then
                    toUpper(strGift)
                else
                    strGift
                end if
            end |λ|
        end script

        on |λ|(intDay)
            "On the " & item intDay of ordinals & " day of Xmas, my true love gave to me ..." & ¬
                linefeed & intercalate("," & linefeed, ¬
                map(dayGift, enumFromTo(intDay, 1)))

        end |λ|
    end script

    intercalate(linefeed & linefeed, ¬
        map(verseOfTheDay, enumFromTo(1, length of ordinals)))

end daysOfXmas

-- TEST ---------------------------------------------------------------------
on run

    daysOfXmas()

end run


-- GENERIC FUNCTIONS --------------------------------------------------------

-- enumFromTo :: Int -> Int -> [Int]
on enumFromTo(m, n)
    if m > n then
        set d to -1
    else
        set d to 1
    end if
    set lst to {}
    repeat with i from m to n by d
        set end of lst to i
    end repeat
    return lst
end enumFromTo

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

-- splitOn :: Text -> Text -> [Text]
on splitOn(strDelim, strMain)
    set {dlm, my text item delimiters} to {my text item delimiters, strDelim}
    set lstParts to text items of strMain
    set my text item delimiters to dlm
    return lstParts
end splitOn

-- toLower :: String -> String
on toLower(str)
    set ca to current application
    ((ca's NSString's stringWithString:(str))'s ¬
        lowercaseStringWithLocale:(ca's NSLocale's currentLocale())) as text
end toLower

-- toUpper :: String -> String
on toUpper(str)
    set ca to current application
    ((ca's NSString's stringWithString:(str))'s ¬
        uppercaseStringWithLocale:(ca's NSLocale's currentLocale())) as text
end toUpper
