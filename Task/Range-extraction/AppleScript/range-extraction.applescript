-- rangeFormat :: [Int] -> String
on rangeFormat(xs)
    script rangeString
        on |λ|(xs)
            if length of xs > 2 then
                (item 1 of xs as string) & "-" & (item -1 of xs as string)
            else
                intercalate(",", xs)
            end if
        end |λ|
    end script

    script nonConsec
        on |λ|(a, b)
            b - a > 1
        end |λ|
    end script

    intercalate(",", map(rangeString, splitBy(nonConsec, xs)))
end rangeFormat


--TEST ------------------------------------------------------------------------
on run
    set xs to {0, 1, 2, 4, 6, 7, 8, 11, 12, 14, 15, 16, ¬
        17, 18, 19, 20, 21, 22, 23, 24, 25, 27, 28, 29, 30, 31, 32, ¬
        33, 35, 36, 37, 38, 39}

    rangeFormat(xs)

    --> "0-2,4,6-8,11,12,14-25,27-33,35-39"
end run


-- GENERIC FUNCTIONS ----------------------------------------------------------

-- splitBy :: (a -> a -> Bool) -> [a] -> [[a]]
on splitBy(f, xs)
    set mf to mReturn(f)

    if length of xs < 2 then
        {xs}
    else
        script p
            on |λ|(a, x)
                set {acc, active, prev} to a
                if mf's |λ|(prev, x) then
                    {acc & {active}, {x}, x}
                else
                    {acc, active & x, x}
                end if
            end |λ|
        end script

        set h to item 1 of xs
        set lstParts to foldl(p, {{}, {h}, h}, items 2 thru -1 of xs)
        item 1 of lstParts & {item 2 of lstParts}
    end if
end splitBy

-- foldl :: (a -> b -> a) -> a -> [b] -> a
on foldl(f, startValue, xs)
    tell mReturn(f)
        set v to startValue
        set lng to length of xs
        repeat with i from 1 to lng
            set v to |λ|(v, item i of xs, i, xs)
        end repeat
        return v
    end tell
end foldl

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
