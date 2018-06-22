use framework "Foundation" -- ( sort )

-- RAREST LETTER IN EACH COLUMN ----------------------------------------------
on run
    intercalate("", ¬
        map(composeAll({¬
            head, ¬
            curry(minimumBy)'s |λ|(comparing(|length|)), ¬
            group, ¬
            sort}), ¬
            transpose(map(chars, ¬
                |words|("ABCD CABD ACDB DACB BCDA ACBD " & ¬
                    "ADCB CDAB DABC BCAD CADB CDBA " & ¬
                    "CBAD ABDC ADBC BDCA DCBA BACD " & ¬
                    "BADC BDAC CBDA DBCA DCAB")))))

    --> "DBAC"
end run

-- GENERIC FUNCTIONS ----------------------------------------------------------

-- chars :: String -> [String]
on chars(s)
    characters of s
end chars

-- Ordering  :: (-1 | 0 | 1)
-- compare :: a -> a -> Ordering
on compare(a, b)
    if a < b then
        -1
    else if a > b then
        1
    else
        0
    end if
end compare

-- comparing :: (a -> b) -> (a -> a -> Ordering)
on comparing(f)
    script
        on |λ|(a, b)
            tell mReturn(f) to compare(|λ|(a), |λ|(b))
        end |λ|
    end script
end comparing

-- composeAll :: [(a -> a)] -> (a -> a)
on composeAll(fs)
    script
        on |λ|(x)
            script
                on |λ|(f, a)
                    mReturn(f)'s |λ|(a)
                end |λ|
            end script

            foldr(result, x, fs)
        end |λ|
    end script
end composeAll

-- curry :: (Script|Handler) -> Script
on curry(f)
    script
        on |λ|(a)
            script
                on |λ|(b)
                    |λ|(a, b) of mReturn(f)
                end |λ|
            end script
        end |λ|
    end script
end curry

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

-- foldr :: (b -> a -> a) -> a -> [b] -> a
on foldr(f, startValue, xs)
    tell mReturn(f)
        set v to startValue
        set lng to length of xs
        repeat with i from lng to 1 by -1
            set v to |λ|(item i of xs, v, i, xs)
        end repeat
        return v
    end tell
end foldr

-- group :: Eq a => [a] -> [[a]]
on group(xs)
    script eq
        on |λ|(a, b)
            a = b
        end |λ|
    end script

    groupBy(eq, xs)
end group

-- groupBy :: (a -> a -> Bool) -> [a] -> [[a]]
on groupBy(f, xs)
    set mf to mReturn(f)

    script enGroup
        on |λ|(a, x)
            if length of (active of a) > 0 then
                set h to item 1 of active of a
            else
                set h to missing value
            end if

            if h is not missing value and mf's |λ|(h, x) then
                {active:(active of a) & x, sofar:sofar of a}
            else
                {active:{x}, sofar:(sofar of a) & {active of a}}
            end if
        end |λ|
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

-- intercalate :: Text -> [Text] -> Text
on intercalate(strText, lstText)
    set {dlm, my text item delimiters} to {my text item delimiters, strText}
    set strJoined to lstText as text
    set my text item delimiters to dlm
    return strJoined
end intercalate

-- length :: [a] -> Int
on |length|(xs)
    length of xs
end |length|

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

-- minimumBy :: (a -> a -> Ordering) -> [a] -> a
on minimumBy(f, xs)
    if length of xs < 1 then return missing value
    tell mReturn(f)
        set v to item 1 of xs
        repeat with x in xs
            if |λ|(x, v) < 0 then set v to x
        end repeat
        return v
    end tell
end minimumBy

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

-- sort :: [a] -> [a]
on sort(xs)
    ((current application's NSArray's arrayWithArray:xs)'s ¬
        sortedArrayUsingSelector:"compare:") as list
end sort

-- tail :: [a] -> [a]
on tail(xs)
    if length of xs > 1 then
        items 2 thru -1 of xs
    else
        {}
    end if
end tail

-- transpose :: [[a]] -> [[a]]
on transpose(xss)
    script column
        on |λ|(_, iCol)
            script row
                on |λ|(xs)
                    item iCol of xs
                end |λ|
            end script

            map(row, xss)
        end |λ|
    end script

    map(column, item 1 of xss)
end transpose

-- words :: String -> [String]
on |words|(s)
    words of s
end |words|
