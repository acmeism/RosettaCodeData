use framework "Foundation" -- for basic NSArray sort

on run
    unlines({"rings(true, enumFromTo(1, 7))\n", ¬
        map(show, (rings(true, enumFromTo(1, 7)))), ¬
        "\nrings(true, enumFromTo(3, 9))\n", ¬
        map(show, (rings(true, enumFromTo(3, 9)))), ¬
        "\nlength(rings(false, enumFromTo(0, 9)))\n", ¬
        show(|length|(rings(false, enumFromTo(0, 9))))})
end run

-- RINGS -----------------------------------------------------------------------

-- rings :: noRepeatedDigits -> DigitList -> Lists of solutions
-- rings :: Bool -> [Int] -> [[Int]]
on rings(u, digits)
    set ds to reverse_(sort(digits))
    set h to head(ds)

    -- QUEEN -------------------------------------------------------------------
    script queen
        on |λ|(q)
            script
                on |λ|(x)
                    x + q ≤ h
                end |λ|
            end script
            set ts to filter(result, ds)
            if u then
                set bs to delete_(q, ts)
            else
                set bs to ds
            end if

            -- LEFT BISHOP and its ROOK-----------------------------------------
            script leftBishop
                on |λ|(lb)
                    set lRook to lb + q
                    if lRook > h then
                        {}
                    else
                        if u then
                            set rbs to difference(ts, {q, lb, lRook})
                        else
                            set rbs to ds
                        end if

                        -- RIGHT BISHOP and its ROOK ---------------------------
                        script rightBishop
                            on |λ|(rb)
                                set rRook to rb + q
                                if (rRook > h) or (u and (rRook = lb)) then
                                    {}
                                else
                                    set rookDelta to lRook - rRook
                                    if u then
                                        set ks to difference(ds, ¬
                                            {q, lb, rb, rRook, lRook})
                                    else
                                        set ks to ds
                                    end if

                                    -- KNIGHTS LEFT AND RIGHT ------------------
                                    script knights
                                        on |λ|(k)
                                            set k2 to k + rookDelta

                                            if elem(k2, ks) and ((not u) or ¬
                                                notElem(k2, ¬
                                                    {lRook, k, lb, q, rb, rRook})) then
                                                {{lRook, k, lb, q, rb, k2, rRook}}
                                            else
                                                {}
                                            end if
                                        end |λ|
                                    end script

                                    concatMap(knights, ks)
                                end if
                            end |λ|
                        end script

                        concatMap(rightBishop, rbs)
                    end if
                end |λ|
            end script

            concatMap(leftBishop, bs)
        end |λ|
    end script

    concatMap(queen, ds)
end rings

-- GENERIC FUNCTIONS -----------------------------------------------------------

-- concatMap :: (a -> [b]) -> [a] -> [b]
on concatMap(f, xs)
    set lst to {}
    set lng to length of xs
    tell mReturn(f)
        repeat with i from 1 to lng
            set lst to (lst & |λ|(contents of item i of xs, i, xs))
        end repeat
    end tell
    return lst
end concatMap

-- delete :: Eq a => a -> [a] -> [a]
on delete_(x, xs)
    set mbIndex to elemIndex(x, xs)
    set lng to length of xs

    if mbIndex is not missing value then
        if lng > 1 then
            if mbIndex = 1 then
                items 2 thru -1 of xs
            else if mbIndex = lng then
                items 1 thru -2 of xs
            else
                tell xs to items 1 thru (mbIndex - 1) & ¬
                    items (mbIndex + 1) thru -1
            end if
        else
            {}
        end if
    else
        xs
    end if
end delete_

-- difference :: [a] -> [a] -> [a]
on difference(xs, ys)
    script mf
        on except(a, y)
            if a contains y then
                my delete_(y, a)
            else
                a
            end if
        end except
    end script

    foldl(except of mf, xs, ys)
end difference

-- elem :: Eq a => a -> [a] -> Bool
on elem(x, xs)
    xs contains x
end elem

-- elemIndex :: a -> [a] -> Maybe Int
on elemIndex(x, xs)
    set lng to length of xs
    repeat with i from 1 to lng
        if x = (item i of xs) then return i
    end repeat
    return missing value
end elemIndex

-- enumFromTo :: Int -> Int -> [Int]
on enumFromTo(m, n)
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
end enumFromTo

-- filter :: (a -> Bool) -> [a] -> [a]
on filter(f, xs)
    tell mReturn(f)
        set lst to {}
        set lng to length of xs
        repeat with i from 1 to lng
            set v to item i of xs
            if |λ|(v, i, xs) then set end of lst to v
        end repeat
        return lst
    end tell
end filter

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

-- notElem :: Eq a => a -> [a] -> Bool
on notElem(x, xs)
    xs does not contain x
end notElem

-- reverse_ :: [a] -> [a]
on |reverse|:xs
    if class of xs is text then
        (reverse of characters of xs) as text
    else
        reverse of xs
    end if
end |reverse|:

-- show :: a -> String
on show(e)
    set c to class of e
    if c = list then
        script serialized
            on |λ|(v)
                show(v)
            end |λ|
        end script

        "[" & intercalate(", ", map(serialized, e)) & "]"
    else if c = record then
        script showField
            on |λ|(kv)
                set {k, ev} to kv
                "\"" & k & "\":" & show(ev)
            end |λ|
        end script

        "{" & intercalate(", ", ¬
            map(showField, zip(allKeys(e), allValues(e)))) & "}"
    else if c = date then
        "\"" & iso8601Z(e) & "\""
    else if c = text then
        "\"" & e & "\""
    else if (c = integer or c = real) then
        e as text
    else if c = class then
        "null"
    else
        try
            e as text
        on error
            ("«" & c as text) & "»"
        end try
    end if
end show

-- sort :: [a] -> [a]
on sort(xs)
    ((current application's NSArray's arrayWithArray:xs)'s ¬
        sortedArrayUsingSelector:"compare:") as list
end sort

-- unlines :: [String] -> String
on unlines(xs)
    intercalate(linefeed, xs)
end unlines
