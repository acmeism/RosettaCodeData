-- SUBSTRING PRIMITIVES

--  take :: Int -> Text -> Text
on take(n, s)
    text 1 thru n of s
end take

--  drop :: Int -> Text -> Text
on drop(n, s)
    text (n + 1) thru -1 of s
end drop

-- breakOn :: Text -> Text -> (Text, Text)
on breakOn(strPattern, s)
    set {dlm, my text item delimiters} to {my text item delimiters, strPattern}
    set lstParts to text items of s
    set my text item delimiters to dlm
    {item 1 of lstParts, strPattern & (item 2 of lstParts)}
end breakOn

--  init :: Text -> Text
on init(s)
    if length of s > 0 then
        text 1 thru -2 of s
    else
        missing value
    end if
end init


-- TEST

on run
    set str to "一二三四五六七八九十"

    set legends to {¬
        "from n in, of n length", ¬
        "from n in, up to end", ¬
        "all but last", ¬
        "from matching char, of m length", ¬
        "from matching string, of m length"}

    set parts to {¬
        take(3, drop(4, str)), ¬
        drop(3, str), ¬
        init(str), ¬
        take(3, item 2 of breakOn("五", str)), ¬
        take(4, item 2 of breakOn("六七", str))}

    script tabulate
        property strPad : "                                        "

        on lambda(l, r)
            l & drop(length of l, strPad) & r
        end lambda
    end script

    linefeed & intercalate(linefeed, ¬
        zipWith(tabulate, ¬
            legends, parts)) & linefeed
end run



-- GENERIC LIBRARY FUNCTIONS – FOR FORMATTING RESULTS

-- zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
on zipWith(f, xs, ys)
    set lng to length of xs
    if lng is not length of ys then
        missing value
    else
        tell mReturn(f)
            set lst to {}
            repeat with i from 1 to lng
                set end of lst to lambda(item i of xs, item i of ys)
            end repeat
            return lst
        end tell
    end if
end zipWith

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
            property lambda : f
        end script
    end if
end mReturn
