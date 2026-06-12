-------- INTEGERS NEEDING HEX DIGITS HIGHER THAN 9 -------

-- p :: Int -> Bool
on p(n)
    9 < n and (9 < (n mod 16) or p(n div 16))
end p


--------------------------- TEST -------------------------
on run
    set upperLimit to 500
    set w to length of (upperLimit as string)

    set xs to filter(p, enumFromTo(0, upperLimit))

    unlines(map(intercalate("  "), ¬
        {{length of xs as string, ¬
            "matches for the predicate:", linefeed}} & ¬
        chunksOf(6, map(justifyRight(w, space), xs))))
end run


------------------------- GENERIC ------------------------

-- chunksOf :: Int -> [a] -> [[a]]
on chunksOf(k, xs)
    script
        on go(ys)
            set ab to splitAt(k, ys)
            set a to item 1 of ab
            if {} ≠ a then
                {a} & go(item 2 of ab)
            else
                a
            end if
        end go
    end script
    result's go(xs)
end chunksOf


-- enumFromTo :: Int -> Int -> [Int]
on enumFromTo(m, n)
    if m ≤ n then
        set lst to {}
        repeat with i from m to n
            set end of lst to i
        end repeat
        lst
    else
        {}
    end if
end enumFromTo


-- filter :: (a -> Bool) -> [a] -> [a]
on filter(p, xs)
    tell mReturn(p)
        set lst to {}
        set lng to length of xs
        repeat with i from 1 to lng
            set v to item i of xs
            if |λ|(v, i, xs) then set end of lst to v
        end repeat
        if {text, string} contains class of xs then
            lst as text
        else
            lst
        end if
    end tell
end filter


-- intercalate :: String -> [String] -> String
on intercalate(delim)
    script
        on |λ|(xs)
            set {dlm, my text item delimiters} to ¬
                {my text item delimiters, delim}
            set s to xs as text
            set my text item delimiters to dlm
            s
        end |λ|
    end script
end intercalate


-- justifyRight :: Int -> Char -> String -> String
on justifyRight(n, cFiller)
    script
        on |λ|(x)
            set s to x as string
            if n > length of s then
                text -n thru -1 of ((replicate(n, cFiller) as text) & s)
            else
                s
            end if
        end |λ|
    end script
end justifyRight


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


-- Egyptian multiplication - progressively doubling a list, appending
-- stages of doubling to an accumulator where needed for binary
-- assembly of a target length
-- replicate :: Int -> String -> String
on replicate(n, s)
    -- Egyptian multiplication - progressively doubling a list,
    -- appending stages of doubling to an accumulator where needed
    -- for binary assembly of a target length
    script p
        on |λ|({n})
            n ≤ 1
        end |λ|
    end script

    script f
        on |λ|({n, dbl, out})
            if (n mod 2) > 0 then
                set d to out & dbl
            else
                set d to out
            end if
            {n div 2, dbl & dbl, d}
        end |λ|
    end script

    set xs to |until|(p, f, {n, s, ""})
    item 2 of xs & item 3 of xs
end replicate


-- splitAt :: Int -> [a] -> ([a], [a])
on splitAt(n, xs)
    if n > 0 and n < length of xs then
        if class of xs is text then
            {items 1 thru n of xs as text, ¬
                items (n + 1) thru -1 of xs as text}
        else
            {items 1 thru n of xs, items (n + 1) thru -1 of xs}
        end if
    else
        if n < 1 then
            {{}, xs}
        else
            {xs, {}}
        end if
    end if
end splitAt


-- unlines :: [String] -> String
on unlines(xs)
    -- A single string formed by the intercalation
    -- of a list of strings with the newline character.
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, linefeed}
    set s to xs as text
    set my text item delimiters to dlm
    s
end unlines


-- until :: (a -> Bool) -> (a -> a) -> a -> a
on |until|(p, f, x)
    set v to x
    set mp to mReturn(p)
    set mf to mReturn(f)
    repeat until mp's |λ|(v)
        set v to mf's |λ|(v)
    end repeat
    v
end |until|
