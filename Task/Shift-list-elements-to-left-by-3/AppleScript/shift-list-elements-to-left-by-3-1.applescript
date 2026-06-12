------------- SHIFT LIST ELEMENTS TO LEFT BY 3 -----------

-- rotated :: Int -> [a] -> [a]
on rotated(n, xs)
    if 0 ≠ n then
        set m to |mod|(n, length of xs)

        (items (1 + m) thru -1 of xs) & ¬
            (items 1 thru m of xs)
    else
        xs
    end if
end rotated


--------------------------- TEST -------------------------
on run
    set xs to {1, 2, 3, 4, 5, 6, 7, 8, 9}

    unlines({"     Input list: " & showList(xs), ¬
        " Rotated 3 left: " & showList(rotated(3, xs)), ¬
        "Rotated 3 right: " & showList(rotated(-3, xs))})
end run


------------------------- GENERIC ------------------------

-- mod :: Int -> Int -> Int
on |mod|(n, d)
    -- The built-in infix `mod` inherits the sign of the
    -- *dividend* for non zero results.
    -- (i.e. the 'rem' pattern in some languages).
    --
    -- This version inherits the sign of the *divisor*.
    -- (A more typical 'mod' pattern, and useful,
    -- for example, with biredirectional list rotations).
    if signum(n) = signum(-d) then
        (n mod d) + d
    else
        (n mod d)
    end if
end |mod|


-- signum :: Num -> Num
on signum(x)
    if x < 0 then
        -1
    else if x = 0 then
        0
    else
        1
    end if
end signum


------------------------ FORMATTING ----------------------

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
    "{" & intercalate(", ", map(my str, xs)) & "}"
end showList


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
