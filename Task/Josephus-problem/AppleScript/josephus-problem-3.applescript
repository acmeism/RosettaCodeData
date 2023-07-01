-- josephusSurvivor :: Int -> Int -> Int
on josephusSurvivor(n, k)
    script go
        on |λ|(x, a)
            (k + x) mod a
        end |λ|
    end script

    foldl(go, 0, enumFromTo(1, n))
end josephusSurvivor


-- josephusSequence :: Int -> Int -> [Int]
on josephusSequence(n, k)
    script josephus
        on |λ|(m, xs)
            if 0 ≠ m then
                set {l, r} to splitAt((k - 1) mod m, xs)
                {item 1 of r} & |λ|(m - 1, rest of r & l)
            else
                {}
            end if
        end |λ|
    end script

    |λ|(n, enumFromTo(0, n - 1)) of josephus
end josephusSequence


--------------------------- TEST ---------------------------
on run
    unlines({"Josephus survivor -> " & str(josephusSurvivor(41, 3)), ¬
        "Josephus sequence ->" & linefeed & tab & ¬
        showList(josephusSequence(41, 3))})
end run


---------------- REUSABLE GENERIC FUNCTIONS ----------------

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

-- intercalate :: String -> [String] -> String
on intercalate(delim, xs)
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, delim}
    set str to xs as text
    set my text item delimiters to dlm
    str
end intercalate

-- showList :: [a] -> String
on showList(xs)
    script show
        on |λ|(x)
            x as text
        end |λ|
    end script
    "[" & intercalate(",", map(show, xs)) & "]"
end showList

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

-- str :: a -> String
on str(x)
    x as string
end str

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
