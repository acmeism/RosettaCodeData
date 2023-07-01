use AppleScript version "2.4"
use framework "Foundation"
use scripting additions


-- selfDescribes :: Int -> Bool
on selfDescribes(x)
    set s to str(x)
    set descripn to my str(|λ|(my groupBy(my eq, my sort(characters of s))) of my ¬
        described(characters of "0123456789"))
    1 = (offset of descripn in s) and ¬
        0 = ((items ((length of descripn) + 1) thru -1 of s) as string as integer)
end selfDescribes


-- described :: [Char] -> [[Char]] -> [Char]
on described(digits)
    script
        on |λ|(groups)
            if 0 < length of digits and 0 < length of groups then
                set grp to item 1 of groups
                set go to described(rest of digits)
                if item 1 of digits = item 1 of (item 1 of grp) then
                    {item 1 of my str(length of grp)} & |λ|(rest of groups) of go
                else
                    {"0"} & |λ|(groups) of go
                end if
            else
                {}
            end if
        end |λ|
    end script
end described


-------------------------- TEST ---------------------------
on run
    script test
        on |λ|(n)
            str(n) & " -> " & str(selfDescribes(n))
        end |λ|
    end script

    unlines(map(test, ¬
        {1210, 1211, 2020, 2022, 21200, 21203, 3211000, 3211004}))


end run


-------------------- GENERIC FUNCTIONS --------------------

-- True if every value in the list is true.
-- and :: [Bool] -> Bool
on |and|(xs)
    repeat with x in xs
        if not (contents of x) then return false
    end repeat
    return true
end |and|


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


-- eq (==) :: Eq a => a -> a -> Bool
on eq(a, b)
    a = b
end eq


-- filter :: (a -> Bool) -> [a] -> [a]
on filter(p, xs)
    tell mReturn(p)
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


-- Typical usage: groupBy(on(eq, f), xs)
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
                {active:(active of a) & {x}, sofar:sofar of a}
            else
                {active:{x}, sofar:(sofar of a) & {active of a}}
            end if
        end |λ|
    end script

    if length of xs > 0 then
        set dct to foldl(enGroup, {active:{item 1 of xs}, sofar:{}}, rest of xs)
        if length of (active of dct) > 0 then
            sofar of dct & {active of dct}
        else
            sofar of dct
        end if
    else
        {}
    end if
end groupBy


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


-- sort :: Ord a => [a] -> [a]
on sort(xs)
    ((current application's NSArray's arrayWithArray:xs)'s ¬
        sortedArrayUsingSelector:"compare:") as list
end sort


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
