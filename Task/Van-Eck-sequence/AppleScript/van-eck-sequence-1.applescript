use AppleScript version "2.4"
use scripting additions


-- vanEck :: Int -> [Int]
on vanEck(n)
    -- First n terms of the vanEck sequence.

    script go
        on |λ|(xns, i)
            set {x, ns} to xns
            set prev to item (1 + x) of ns

            if 0 ≠ prev then
                set v to i - prev
            else
                set v to 0
            end if

            {{v, insert(ns, x, i)}, v}
        end |λ|
    end script


    {0} & item 2 of mapAccumL(go, ¬
        {0, replicate(n, 0)}, enumFromTo(1, n - 1))
end vanEck


--------------------------- TEST ---------------------------
on run
    unlines({¬
        "First 10 terms:", ¬
        showList(vanEck(10)), ¬
        "", ¬
        "Terms 990 to 1000:", ¬
        showList(items -10 thru -1 of vanEck(1000))})
end run



------------------------- GENERIC --------------------------

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


-- insert :: [Int] -> Int -> Int -> [Int]
on insert(xs, i, v)
    -- A list updated at position i with value v.
    set item (1 + i) of xs to v
    xs
end insert


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


-- 'The mapAccumL function behaves like a combination of map and foldl;
-- it applies a function to each element of a list, passing an
-- accumulating parameter from |Left| to |Right|, and returning a final
-- value of this accumulator together with the new list.' (see Hoogle)
-- mapAccumL :: (acc -> x -> (acc, y)) -> acc -> [x] -> (acc, [y])
on mapAccumL(f, acc, xs)
    script
        on |λ|(a, x, i)
            tell mReturn(f) to set pair to |λ|(item 1 of a, x, i)
            {item 1 of pair, (item 2 of a) & {item 2 of pair}}
        end |λ|
    end script

    foldl(result, {acc, []}, xs)
end mapAccumL


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
    "[" & intercalate(", ", map(my str, xs)) & "]"
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
