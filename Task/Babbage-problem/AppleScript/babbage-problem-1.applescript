------------------------- BABBAGE ------------------------

-- babbage :: Int -> [Int]
on babbage(intTests)

    script test
        on toSquare(x)
            (1000000 * x) + 269696
        end toSquare

        on |λ|(x)
            hasIntRoot(toSquare(x))
        end |λ|
    end script

    script toRoot
        on |λ|(x)
            ((1000000 * x) + 269696) ^ (1 / 2)
        end |λ|
    end script

    set xs to filter(test, enumFromTo(1, intTests))
    zip(map(toRoot, xs), map(test's toSquare, xs))
end babbage


--------------------------- TEST -------------------------
on run
    -- Try 1000 candidates

    unlines(map(intercalate(" -> "), babbage(1000)))

    --> "2.5264E+4 -> 6.38269696E+8"
end run


-------------------- GENERIC FUNCTIONS -------------------


-- enumFromTo :: Int -> Int -> [Int]
on enumFromTo(m, n)
    if m > n then
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


-- hasIntRoot :: Int -> Bool
on hasIntRoot(n)
    set r to n ^ 0.5
    r = (r as integer)
end hasIntRoot


-- intercalate :: String -> [String] -> String
on intercalate(sep)
    script
        on |λ|(xs)
            set {dlm, my text item delimiters} to ¬
                {my text item delimiters, sep}
            set s to xs as text
            set my text item delimiters to dlm
            s
        end |λ|
    end script
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


-- min :: Ord a => a -> a -> a
on min(x, y)
    if y < x then
        y
    else
        x
    end if
end min


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


-- zip :: [a] -> [b] -> [(a, b)]
on zip(xs, ys)
    set lng to min(length of xs, length of ys)
    set lst to {}
    repeat with i from 1 to lng
        set end of lst to {item i of xs, item i of ys}
    end repeat
    return lst
end zip
