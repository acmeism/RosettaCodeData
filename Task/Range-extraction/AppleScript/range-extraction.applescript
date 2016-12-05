on run

    rangeString([0, 1, 2, 4, 6, 7, 8, 11, 12, 14, 15, ¬
        16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 27, ¬
        28, 29, 30, 31, 32, 33, 35, 36, 37, 38, 39])

end run

-- rangeString :: [Int] -> String
on rangeString(xs)
    script addNumberOrRange
        property iLast : length of xs

        -- [[Int]] -> Int -> Int -> [Int] -> [[Int]]
        on lambda(lstAccumulator, x, iPosn, xs)
            if iPosn < iLast then
                if ((item (iPosn + 1) of xs) - x) > 1 then -- rightward gap > 1
                    [[x]] & lstAccumulator --> start of new series
                else
                    -- Prepended to current series
                    -- (if a series-breaker, or start list, is at left)
                    if ((iPosn = 1) or (x - (item (iPosn - 1) of xs)) > 1) then
                        [[x] & (item 1 of lstAccumulator)] & tail(lstAccumulator)
                    else
                        lstAccumulator -- Stet - series continues
                    end if
                end if
            else
                [[x]]
            end if
        end lambda
    end script

    interCalate(",", ¬
        map(my delimitedString, ¬
            foldr(addNumberOrRange, [], xs)))
end rangeString


-- delimitedString :: [Int] -> String
on delimitedString(lstInt)
    set intFirst to item 1 of lstInt

    if length of lstInt > 1 then
        set intSecond to item 2 of lstInt
        set delta to intSecond - intFirst
    else
        set delta to 0
    end if

    if delta > 0 then
        (intFirst as string) & cond(delta > 1, "-", ",") & intSecond as string
    else
        intFirst as string
    end if
end delimitedString


-- GENERIC LIBRARY FUNCTIONS

-- intercalate :: Text -> [Text] -> Text
on interCalate(strText, lstText)
    set {dlm, my text item delimiters} to {my text item delimiters, strText}
    set strJoined to lstText as text
    set my text item delimiters to dlm
    return strJoined
end interCalate

-- foldr :: (a -> b -> a) -> a -> [b] -> a
on foldr(f, startValue, xs)
    set mf to mReturn(f)

    set v to startValue
    set lng to length of xs
    repeat with i from lng to 1 by -1
        set v to mf's lambda(v, item i of xs, i, xs)
    end repeat
    return v
end foldr

-- map :: (a -> b) -> [a] -> [b]
on map(f, xs)
    set mf to mReturn(f)
    set lng to length of xs
    set lst to {}
    repeat with i from 1 to lng
        set end of lst to mf's lambda(item i of xs, i, xs)
    end repeat
    return lst
end map

-- cond :: Bool -> (a -> b) -> (a -> b) -> (a -> b)
on cond(bool, f, g)
    if bool then
        f
    else
        g
    end if
end cond

-- tail :: [a] -> [a]
on tail(xs)
    if class of xs is list and length of xs > 1 then
        items 2 thru -1 of xs
    else
        {}
    end if
end tail

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
