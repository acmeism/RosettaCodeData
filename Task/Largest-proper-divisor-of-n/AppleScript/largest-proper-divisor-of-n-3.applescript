use framework "Foundation"


--------------- LARGEST PROPER DIVISOR OF N --------------

-- maxProperDivisors :: Int -> Int
on maxProperDivisors(n)
    script p
        on |λ|(x)
            0 = n mod x
        end |λ|
    end script

    set mb to find(p, enumFromTo(2, sqrt(n)))

    if missing value is mb then
        1
    else
        n div mb
    end if
end maxProperDivisors


--------------------------- TEST -------------------------
on run
    set xs to map(maxProperDivisors, enumFromTo(1, 100))
    set w to length of (maximum(xs) as string)

    unlines(map(unwords, ¬
        chunksOf(10, ¬
            map(compose(justifyRight(w, space), str), xs))))
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


-- compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
on compose(f, g)
    script
        property mf : mReturn(f)
        property mg : mReturn(g)
        on |λ|(x)
            mf's |λ|(mg's |λ|(x))
        end |λ|
    end script
end compose


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


-- find :: (a -> Bool) -> [a] -> (a | missing value)
on find(p, xs)
    tell mReturn(p)
        set lng to length of xs
        repeat with i from 1 to lng
            if |λ|(item i of xs) then return item i of xs
        end repeat
        missing value
    end tell
end find


-- justifyRight :: Int -> Char -> String -> String
on justifyRight(n, cFiller)
    script
        on |λ|(strText)
            if n > length of strText then
                text -n thru -1 of ((replicate(n, cFiller) as text) & strText)
            else
                strText
            end if
        end |λ|
    end script
end justifyRight


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


-- maximum :: Ord a => [a] -> a
on maximum(xs)
    set ca to current application
    unwrap((ca's NSArray's arrayWithArray:(xs))'s ¬
        valueForKeyPath:"@max.self")
end maximum


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


-- sqrt :: Num -> (Num | missing value)
on sqrt(n)
    if 0 ≤ n then
        n ^ (1 / 2)
    else
        missing value
    end if
end sqrt


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


-- unwords :: [String] -> String
on unwords(xs)
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, space}
    set s to xs as text
    set my text item delimiters to dlm
    return s
end unwords


-- unwrap :: NSValue -> a
on unwrap(nsValue)
    if nsValue is missing value then
        missing value
    else
        set ca to current application
        item 1 of ((ca's NSArray's arrayWithObject:nsValue) as list)
    end if
end unwrap
