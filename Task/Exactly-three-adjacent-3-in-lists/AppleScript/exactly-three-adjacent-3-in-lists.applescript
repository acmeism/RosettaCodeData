------- EXACTLY N INSTANCES OF N AND ALL CONTIGUOUS ------

-- nnPeers :: Int -> [Int] -> Bool
on nnPeers(n)
    script p
        on |λ|(x)
            n = x
        end |λ|
    end script

    script notP
        on |λ|(x)
            n ≠ x
        end |λ|
    end script

    script
        on |λ|(xs)
            set {contiguous, residue} to ¬
                span(p, dropWhile(notP, xs))

            n = length of contiguous and ¬
                all(notP, residue)
        end |λ|
    end script
end nnPeers


--------------------------- TEST -------------------------
on run
    set xs to [¬
        [9, 3, 3, 3, 2, 1, 7, 8, 5], ¬
        [5, 2, 9, 3, 3, 7, 8, 4, 1], ¬
        [1, 4, 3, 6, 7, 3, 8, 3, 2], ¬
        [1, 2, 3, 4, 5, 6, 7, 8, 9], ¬
        [4, 6, 8, 7, 2, 3, 3, 3, 1]]

    set p to nnPeers(3)

    script test
        on |λ|(x)
            showList(x) & " -> " & p's |λ|(x)
        end |λ|
    end script

    unlines(map(test, xs))
end run


------------------------- GENERIC ------------------------

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


-- dropWhile :: (a -> Bool) -> [a] -> [a]
-- dropWhile :: (Char -> Bool) -> String -> String
on dropWhile(p, xs)
    set lng to length of xs
    set i to 1
    tell mReturn(p)
        repeat while i ≤ lng and |λ|(item i of xs)
            set i to i + 1
        end repeat
    end tell
    items i thru -1 of xs
end dropWhile


-- intercalate :: String -> [String] -> String
on intercalate(delim, xs)
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, delim}
    set s to xs as text
    set my text item delimiters to dlm
    s
end intercalate


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


-- showList :: [a] -> String
on showList(xs)
    "[" & intercalate(", ", map(my str, xs)) & "]"
end showList


-- span :: (a -> Bool) -> [a] -> ([a], [a])
on span(p, xs)
    -- The longest (possibly empty) prefix of xs
    -- that contains only elements satisfying p,
    -- tupled with the remainder of xs.
    -- span(p, xs) eq (takeWhile(p, xs), dropWhile(p, xs))
    script go
        property mp : mReturn(p)
        on |λ|(vs)
            if {} ≠ vs then
                set x to item 1 of vs
                if |λ|(x) of mp then
                    set {ys, zs} to |λ|(rest of vs)
                    {{x} & ys, zs}
                else
                    {{}, vs}
                end if
            else
                {{}, {}}
            end if
        end |λ|
    end script
    |λ|(xs) of go
end span


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
    set s to xs as text
    set my text item delimiters to dlm
    s
end unlines
