-- comb :: Int -> [a] -> [[a]]
on comb(n, lst)
    set h to head(lst)

    script headPrepended
        on lambda(t)
            h & t
        end lambda
    end script

    if n < 1 then
        [[]]
    else if length of lst = 0 then
        []
    else
        set xs to tail(lst)

        map(headPrepended, ¬
            comb(n - 1, xs)) & comb(n, xs)
    end if
end comb


-- TEST

-- spaced :: [a] -> String
on spaced(lst)
    intercalate(space, lst)
end spaced

on run

    intercalate(linefeed, ¬
        map(spaced, comb(3, range(0, 4))))

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

-- intercalate :: Text -> [Text] -> Text
on intercalate(strText, lstText)
    set {dlm, my text item delimiters} to {my text item delimiters, strText}
    set strJoined to lstText as text
    set my text item delimiters to dlm
    return strJoined
end intercalate

-- range :: Int -> Int -> [Int]
on range(m, n)
    if n < m then
        set d to -1
    else
        set d to 1
    end if
    set lst to {}
    repeat with i from m to n by d
        set end of lst to i
    end repeat
    return lst
end range

-- head :: [a] -> a
on head(xs)
    if length of xs > 0 then
        item 1 of xs
    else
        missing value
    end if
end head

-- tail :: [a] -> [a]
on tail(xs)
    if length of xs > 1 then
        items 2 thru -1 of xs
    else
        {}
    end if
end tail
