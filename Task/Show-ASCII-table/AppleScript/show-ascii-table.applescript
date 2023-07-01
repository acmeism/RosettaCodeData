-- asciiTable :: () -> String
on asciiTable()
    script row
        on |λ|(x)
            concat(map(justifyLeft(12, space), x))
        end |λ|
    end script

    unlines(map(row, ¬
        transpose(chunksOf(16, map(my asciiEntry, ¬
            enumFromTo(32, 127))))))
end asciiTable


-------------------------- TEST ---------------------------
on run

    asciiTable()

end run


------------------------- DISPLAY -------------------------

-- asciiEntry :: Int -> String
on asciiEntry(n)
    set k to asciiName(n)
    if "" ≠ k then
        justifyRight(4, space, n as string) & " : " & k
    else
        k
    end if
end asciiEntry

-- asciiName :: Int -> String
on asciiName(n)
    if 32 > n or 127 < n then
        ""
    else if 32 = n then
        "Spc"
    else if 127 = n then
        "Del"
    else
        chr(n)
    end if
end asciiName


-------------------- GENERIC FUNCTIONS --------------------

-- chr :: Int -> Char
on chr(n)
    character id n
end chr


-- chunksOf :: Int -> [a] -> [[a]]
on chunksOf(k, xs)
    script
        on go(ys)
            set ab to splitAt(k, ys)
            set a to |1| of ab
            if {} ≠ a then
                {a} & go(|2| of ab)
            else
                a
            end if
        end go
    end script
    result's go(xs)
end chunksOf


-- concat :: [[a]] -> [a]
-- concat :: [String] -> String
on concat(xs)
    set lng to length of xs
    if 0 < lng and string is class of (item 1 of xs) then
        set acc to ""
    else
        set acc to {}
    end if
    repeat with i from 1 to lng
        set acc to acc & item i of xs
    end repeat
    acc
end concat


-- concatMap :: (a -> [b]) -> [a] -> [b]
on concatMap(f, xs)
    set lng to length of xs
    if 0 < lng and class of xs is string then
        set acc to ""
    else
        set acc to {}
    end if
    tell mReturn(f)
        repeat with i from 1 to lng
            set acc to acc & |λ|(item i of xs, i, xs)
        end repeat
    end tell
    return acc
end concatMap


-- enumFromTo :: Int -> Int -> [Int]
on enumFromTo(m, n)
    if m ≤ n then
        set lst to {}
        repeat with i from m to n
            set end of lst to i
        end repeat
        return lst
    else
        return {}
    end if
end enumFromTo


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


-- justifyLeft :: Int -> Char -> String -> String
on justifyLeft(n, cFiller)
    script
        on |λ|(strText)
            if n > length of strText then
                text 1 thru n of (strText & replicate(n, cFiller))
            else
                strText
            end if
        end |λ|
    end script
end justifyLeft


-- justifyRight :: Int -> Char -> String -> String
on justifyRight(n, cFiller, strText)
    if n > length of strText then
        text -n thru -1 of ((replicate(n, cFiller) as text) & strText)
    else
        strText
    end if
end justifyRight


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
-- mReturn :: First-class m => (a -> b) -> m (a -> b)
on mReturn(f)
    if class of f is script then
        f
    else
        script
            property |λ| : f
        end script
    end if
end mReturn


-- Egyptian multiplication - progressively doubling a list, appending
-- stages of doubling to an accumulator where needed for binary
-- assembly of a target length
-- replicate :: Int -> a -> [a]
on replicate(n, a)
    set out to {}
    if n < 1 then return out
    set dbl to {a}

    repeat while (n > 1)
        if (n mod 2) > 0 then set out to out & dbl
        set n to (n div 2)
        set dbl to (dbl & dbl)
    end repeat
    return out & dbl
end replicate


-- splitAt :: Int -> [a] -> ([a],[a])
on splitAt(n, xs)
    if n > 0 and n < length of xs then
        if class of xs is text then
            Tuple(items 1 thru n of xs as text, items (n + 1) thru -1 of xs as text)
        else
            Tuple(items 1 thru n of xs, items (n + 1) thru -1 of xs)
        end if
    else
        if n < 1 then
            Tuple({}, xs)
        else
            Tuple(xs, {})
        end if
    end if
end splitAt


-- Tuple (,) :: a -> b -> (a, b)
on Tuple(a, b)
    {type:"Tuple", |1|:a, |2|:b, length:2}
end Tuple


-- Simplified version - assuming rows of unvarying length.
-- transpose :: [[a]] -> [[a]]
on transpose(rows)
    script cols
        on |λ|(_, iCol)
            script cell
                on |λ|(row)
                    item iCol of row
                end |λ|
            end script
            concatMap(cell, rows)
        end |λ|
    end script
    map(cols, item 1 of rows)
end transpose


-- unlines :: [String] -> String
on unlines(xs)
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, linefeed}
    set str to xs as text
    set my text item delimiters to dlm
    str
end unlines
