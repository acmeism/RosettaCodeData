use framework "Foundation" -- ( sort )

-- RAREST LETTER IN EACH COLUMN -----------------------------------------------
on run
    intercalate("", ¬
        map(compose({¬
            sort, ¬
            group, ¬
            curry(minimumBy)'s lambda(comparing(_length)), ¬
            head}), ¬
            transpose(map(stringChars, (splitOn(space, ¬
                "ABCD CABD ACDB DACB BCDA ACBD " & ¬
                "ADCB CDAB DABC BCAD CADB CDBA " & ¬
                "CBAD ABDC ADBC BDCA DCBA BACD " & ¬
                "BADC BDAC CBDA DBCA DCAB"))))))

    --> "DBAC"
end run


-- GENERIC FUNCTIONS ----------------------------------------------------------

-- compose :: [(a -> a)] -> (a -> a)
on compose(fs)
    script
        on lambda(x)
            script
                on lambda(a, f)
                    mReturn(f)'s lambda(a)
                end lambda
            end script

            foldl(result, x, fs)
        end lambda
    end script
end compose

-- transpose :: [[a]] -> [[a]]
on transpose(xss)
    script column
        on lambda(_, iCol)
            script row
                on lambda(xs)
                    item iCol of xs
                end lambda
            end script

            map(row, xss)
        end lambda
    end script

    map(column, item 1 of xss)
end transpose

-- sort :: [a] -> [a]
on sort(lst)
    ((current application's NSArray's arrayWithArray:lst)'s ¬
        sortedArrayUsingSelector:"compare:") as list
end sort

-- group :: Eq a => [a] -> [[a]]
on group(xs)
    script eq
        on lambda(a, b)
            a = b
        end lambda
    end script

    groupBy(eq, xs)
end group

-- minimumBy :: (a -> a -> Ordering) -> [a] -> a
on minimumBy(f, xs)
    set mf to mReturn(f)
    script min
        on lambda(a, b)
            if a is missing value then
                b
            else if mf's lambda(a, b) < 0 then
                a
            else
                b
            end if
        end lambda
    end script

    foldl(min, missing value, xs)
end minimumBy

-- comparing :: (a -> b) -> (a -> a -> Ordering)
on comparing(f)
    set mf to mReturn(f)
    script
        on lambda(a, b)
            set x to mf's lambda(a)
            set y to mf's lambda(b)
            if x < y then
                -1
            else
                if x > y then
                    1
                else
                    0
                end if
            end if
        end lambda
    end script
end comparing

-- curry :: (Script|Handler) -> Script
on curry(f)
    script
        on lambda(a)
            script
                on lambda(b)
                    lambda(a, b) of mReturn(f)
                end lambda
            end script
        end lambda
    end script
end curry

-- groupBy :: (a -> a -> Bool) -> [a] -> [[a]]
on groupBy(f, xs)
    set mf to mReturn(f)

    script enGroup
        on lambda(a, x)
            if length of (active of a) > 0 then
                set h to item 1 of active of a
            else
                set h to missing value
            end if

            if h is not missing value and mf's lambda(h, x) then
                {active:(active of a) & x, sofar:sofar of a}
            else
                {active:{x}, sofar:(sofar of a) & {active of a}}
            end if
        end lambda
    end script

    if length of xs > 0 then
        set dct to foldl(enGroup, {active:{item 1 of xs}, sofar:{}}, tail(xs))
        if length of (active of dct) > 0 then
            sofar of dct & {active of dct}
        else
            sofar of dct
        end if
    else
        {}
    end if
end groupBy

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

-- splitOn :: Text -> Text -> [Text]
on splitOn(strDelim, strMain)
    set {dlm, my text item delimiters} to {my text item delimiters, strDelim}
    set xs to text items of strMain
    set my text item delimiters to dlm
    return xs
end splitOn

-- stringChars :: String -> [Char]
on stringChars(s)
    characters of s
end stringChars

-- length :: [a] -> Int
on _length(xs)
    length of xs
end _length

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

-- foldl :: (a -> b -> a) -> a -> [b] -> a
on foldl(f, startValue, xs)
    tell mReturn(f)
        set v to startValue
        set lng to length of xs
        repeat with i from 1 to lng
            set v to lambda(v, item i of xs, i, xs)
        end repeat
        return v
    end tell
end foldl

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
