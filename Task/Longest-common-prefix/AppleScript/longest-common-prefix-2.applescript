------------------- LONGEST COMMON PREFIX ------------------


-- longestCommonPrefix :: [String] -> String
on longestCommonPrefix(xs)
    if 1 < length of xs then
        map(my fst, ¬
            takeWhile(my allSame, my transpose(xs))) as text
    else
        xs as text
    end if
end longestCommonPrefix


---------------------------- TESTS --------------------------
on run
    script test
        on |λ|(xs)
            showList(xs) & " -> '" & longestCommonPrefix(xs) & "'"
        end |λ|
    end script

    unlines(map(test, {¬
        {"interspecies", "interstellar", "interstate"}, ¬
        {"throne", "throne"}, ¬
        {"throne", "dungeon"}, ¬
        {"throne", "", "throne"}, ¬
        {"cheese"}, ¬
        {""}, ¬
        {}, ¬
        {"prefix", "suffix"}, ¬
        {"foo", "foobar"}}))
end run


--------------------- GENERIC FUNCTIONS --------------------

-- all :: (a -> Bool) -> [a] -> Bool
on all(p, xs)
    -- True if p holds for every value in xs
    tell mReturn(p)
        set lng to length of xs
        repeat with i from 1 to lng
            if not |λ|(item i of xs, i, xs) then return false
        end repeat
        true
    end tell
end all


-- allSame :: [a] -> Bool
on allSame(xs)
    if 2 > length of xs then
        true
    else
        script p
            property h : item 1 of xs
            on |λ|(x)
                h = x
            end |λ|
        end script
        all(p, rest of xs)
    end if
end allSame


-- chars :: String -> [Char]
on chars(s)
    characters of s
end chars


-- comparing :: (a -> b) -> (a -> a -> Ordering)
on comparing(f)
    script
        on |λ|(a, b)
            tell mReturn(f)
                set fa to |λ|(a)
                set fb to |λ|(b)
                if fa < fb then
                    -1
                else if fa > fb then
                    1
                else
                    0
                end if
            end tell
        end |λ|
    end script
end comparing


-- concatMap :: (a -> [b]) -> [a] -> [b]
on concatMap(f, xs)
    set lng to length of xs
    set acc to {}
    tell mReturn(f)
        repeat with i from 1 to lng
            set acc to acc & (|λ|(item i of xs, i, xs))
        end repeat
    end tell
    return acc
end concatMap


-- eq (==) :: Eq a => a -> a -> Bool
on eq(a)
    script
        on |λ|(b)
            a = b
        end |λ|
    end script
end eq


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


-- fst :: (a, b) -> a
on fst(tpl)
    if class of tpl is record then
        |1| of tpl
    else
        item 1 of tpl
    end if
end fst


-- intercalate :: String -> [String] -> String
on intercalate(delim, xs)
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, delim}
    set str to xs as text
    set my text item delimiters to dlm
    str
end intercalate


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


-- length :: [a] -> Int
on |length|(xs)
    set c to class of xs
    if list is c or string is c then
        length of xs
    else
        (2 ^ 29 - 1) -- (maxInt - simple proxy for non-finite)
    end if
end |length|


-- map :: (a -> b) -> [a] -> [b]
on map(f, xs)
    -- The list obtained by applying f
    -- to each element of xs.
    tell mReturn(f)
        set lng to length of xs
        set lst to {}
        repeat with i from 1 to lng
            set end of lst to |λ|(item i of xs, i, xs)
        end repeat
        return lst
    end tell
end map


-- maximumBy :: (a -> a -> Ordering) -> [a] -> a
on maximumBy(f, xs)
    set cmp to mReturn(f)
    script max
        on |λ|(a, b)
            if a is missing value or cmp's |λ|(a, b) < 0 then
                b
            else
                a
            end if
        end |λ|
    end script

    foldl(max, missing value, xs)
end maximumBy


-- min :: Ord a => a -> a -> a
on min(x, y)
    if y < x then
        y
    else
        x
    end if
end min


-- mReturn :: First-class m => (a -> b) -> m (a -> b)
on mReturn(f)
    -- 2nd class handler function lifted into 1st class script wrapper.
    if script is class of f then
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
    if 1 > n then return out
    set dbl to {a}

    repeat while (1 < n)
        if 0 < (n mod 2) then set out to out & dbl
        set n to (n div 2)
        set dbl to (dbl & dbl)
    end repeat
    return out & dbl
end replicate


-- showList :: [a] -> String
on showList(xs)
    script show
        on |λ|(x)
            if text is class of x then
                "'" & x & "'"
            else
                x as text
            end if
        end |λ|
    end script
    if {} ≠ xs then
        "[" & intercalate(", ", map(show, xs)) & "]"
    else
        "[]"
    end if
end showList


-- take :: Int -> [a] -> [a]
-- take :: Int -> String -> String
on take(n, xs)
    set c to class of xs
    if list is c then
        if 0 < n then
            items 1 thru min(n, length of xs) of xs
        else
            {}
        end if
    else if string is c then
        if 0 < n then
            text 1 thru min(n, length of xs) of xs
        else
            ""
        end if
    else if script is c then
        set ys to {}
        repeat with i from 1 to n
            set v to |λ|() of xs
            if missing value is v then
                return ys
            else
                set end of ys to v
            end if
        end repeat
        return ys
    else
        missing value
    end if
end take


-- takeWhile :: (a -> Bool) -> [a] -> [a]
-- takeWhile :: (Char -> Bool) -> String -> String
on takeWhile(p, xs)
    if script is class of xs then
        takeWhileGen(p, xs)
    else
        tell mReturn(p)
            repeat with i from 1 to length of xs
                if not |λ|(item i of xs) then ¬
                    return take(i - 1, xs)
            end repeat
        end tell
        return xs
    end if
end takeWhile


-- transpose :: [[a]] -> [[a]]
on transpose(rows)
    set w to length of maximumBy(comparing(|length|), rows)
    set paddedRows to map(justifyLeft(w, "x"), rows)

    script cols
        on |λ|(_, iCol)
            script cell
                on |λ|(row)
                    item iCol of row
                end |λ|
            end script
            concatMap(cell, paddedRows)
        end |λ|
    end script

    map(cols, item 1 of rows)
end transpose


-- unlines :: [String] -> String
on unlines(xs)
    -- A single string formed by the intercalation
    -- of a list of strings with the newline character.
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, linefeed}
    set str to xs as text
    set my text item delimiters to dlm
    str
end unlines
