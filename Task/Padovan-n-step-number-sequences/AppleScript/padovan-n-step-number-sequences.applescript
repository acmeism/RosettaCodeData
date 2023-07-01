use AppleScript version "2.4"
use framework "Foundation"
use scripting additions

------------------ PADOVAN N-STEP NUMBERS ----------------

-- padovans :: [Int]
on padovans(n)
    script recurrence
        on |λ|(xs)
            {item 1 of xs, ¬
                rest of xs & {sum(take(n, xs)) as integer}}
        end |λ|
    end script

    if 3 > n then
        set seed to |repeat|(1)
    else
        set seed to padovans(n - 1)
    end if

    if 0 > n then
        {}
    else
        unfoldr(recurrence, take(1 + n, seed))
    end if
end padovans


--------------------------- TEST -------------------------
on run
    script nSample
        on |λ|(n)
            take(15, padovans(n))
        end |λ|
    end script

    script justified
        on |λ|(ns)
            concatMap(justifyRight(4, space), ns)
        end |λ|
    end script

    fTable("Padovan N-step Series:", str, justified, ¬
        nSample, enumFromTo(2, 8))
end run


------------------------ FORMATTING ----------------------

-- fTable :: String -> (a -> String) -> (b -> String) ->
-- (a -> b) -> [a] -> String
on fTable(s, xShow, fxShow, f, xs)
    set ys to map(xShow, xs)
    set w to maximum(map(my |length|, ys))
    script arrowed
        on |λ|(a, b)
            |λ|(a) of justifyRight(w, space) & " ->" & b
        end |λ|
    end script
    s & linefeed & unlines(zipWith(arrowed, ¬
        ys, map(compose(fxShow, f), xs)))
end fTable


------------------------- GENERIC ------------------------

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


-- concatMap :: (a -> [b]) -> [a] -> [b]
on concatMap(f, xs)
    set lng to length of xs
    set acc to {}
    tell mReturn(f)
        repeat with i from 1 to lng
            set acc to acc & (|λ|(item i of xs, i, xs))
        end repeat
    end tell
    if {text, string} contains class of xs then
        acc as text
    else
        acc
    end if
end concatMap


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


-- intercalate :: String -> [String] -> String
on intercalate(delim, xs)
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, delim}
    set s to xs as text
    set my text item delimiters to dlm
    s
end intercalate


-- justifyRight :: Int -> Char -> String -> String
on justifyRight(n, cFiller)
    script
        on |λ|(v)
            set strText to v as text
            if n > length of strText then
                text -n thru -1 of ¬
                    ((replicate(n, cFiller) as text) & strText)
            else
                strText
            end if
        end |λ|
    end script
end justifyRight


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


-- maximum :: Ord a => [a] -> a
on maximum(xs)
    set ca to current application
    unwrap((ca's NSArray's arrayWithArray:xs)'s ¬
        valueForKeyPath:"@max.self")
end maximum


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
    -- 2nd class handler function lifted
    -- into 1st class script wrapper.
    if script is class of f then
        f
    else
        script
            property |λ| : f
        end script
    end if
end mReturn


-- repeat :: a -> Generator [a]
on |repeat|(x)
    script
        on |λ|()
            return x
        end |λ|
    end script
end |repeat|


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


-- str :: a -> String
on str(x)
    x as string
end str


-- sum :: [Num] -> Num
on sum(xs)
    set ca to current application
    ((ca's NSArray's arrayWithArray:xs)'s ¬
        valueForKeyPath:"@sum.self") as real
end sum


-- take :: Int -> [a] -> [a]
-- take :: Int -> String -> String
on take(n, xs)
    set c to class of xs
    if list is c then
        set lng to length of xs
        if 0 < n and 0 < lng then
            items 1 thru min(n, lng) of xs
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


-- unfoldr :: (b -> Maybe (a, b)) -> b -> [a]
on unfoldr(f, v)
    -- A lazy (generator) list unfolded from a seed value
    -- by repeated application of f to a value until no
    -- residue remains. Dual to fold/reduce.
    -- f returns either nothing (missing value),
    -- or just (value, residue).
    script
        property valueResidue : {v, v}
        property g : mReturn(f)
        on |λ|()
            set valueResidue to g's |λ|(item 2 of (valueResidue))
            if missing value ≠ valueResidue then
                item 1 of (valueResidue)
            else
                missing value
            end if
        end |λ|
    end script
end unfoldr


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


-- unwrap :: NSValue -> a
on unwrap(nsValue)
    if nsValue is missing value then
        missing value
    else
        set ca to current application
        item 1 of ((ca's NSArray's arrayWithObject:nsValue) as list)
    end if
end unwrap


-- zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
on zipWith(f, xs, ys)
    set lng to min(length of xs, length of ys)
    set lst to {}
    if 1 > lng then
        return {}
    else
        tell mReturn(f)
            repeat with i from 1 to lng
                set end of lst to |λ|(item i of xs, item i of ys)
            end repeat
            return lst
        end tell
    end if
end zipWith
