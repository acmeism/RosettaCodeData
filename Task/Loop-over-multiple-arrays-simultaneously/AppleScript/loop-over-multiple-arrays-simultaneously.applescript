-- zipListsWith :: ([a] -> b) -> [[a]] -> [[b]]
on zipListsWith(f, xss)
    set lngLists to length of xss

    -- appliedToNths :: a -> Int -> [b]
    script appliedToNths
        on lambda(_, i)
            -- nthItem :: [a] -> a
            script nthItem
                on lambda(xs)
                    item i of xs
                end lambda
            end script

            if i ≤ lngLists then
                apply(f, (map(nthItem, xss)))
            else
                {}
            end if
        end lambda
    end script

    if lngLists > 0 then
        map(appliedToNths, item 1 of xss)
    else
        []
    end if
end zipListsWith



-- TEST

-- Function to apply:

-- concatList [String] -> String
on concatList(lst)
    intercalate("", lst)
end concatList

on run
    -- Application:

    intercalate(linefeed, ¬
        zipListsWith(concatList, ¬
            [["a", "b", "c"], ["A", "B", "C"], [1, 2, 3]]))

end run



-- GENERIC FUNCTIONS

-- apply (a -> b) -> a -> b
on apply(f, a)
    mReturn(f)'s lambda(a)
end apply

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
