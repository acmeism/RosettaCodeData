use framework "Foundation"


----------- PRODUCT OF MIN AND MAX PRIME FACTORS ---------

on OEISA066048()
    -- Infinite series of the terms of OEISA066048
    script f
        on |λ|(n)
            set xs to primeFactors(n)
            (item 1 of xs) * (item -1 of xs)
        end |λ|
    end script

    cons(1, fmapGen(f, enumFrom(2)))
end OEISA066048


--------------------------- TEST -------------------------
on run

    table(10, take(100, OEISA066048()))

end run


------------------------- DISPLAY ------------------------

-- table :: Int -> [Int] -> String
on table(n, xs)
    -- A list of strings formatted as
    -- right-justified rows of n columns.
    set w to length of str(maximum(xs))
    unlines(map(my unwords, ¬
        chunksOf(n, ¬
            map(compose(justifyRight(w, space), my str), xs))))
end table


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


-- cons :: a -> [a] -> [a]
on cons(x, xs)
    script
        property pRead : false
        on |λ|()
            if pRead then
                |λ|() of xs
            else
                set pRead to true
                return x
            end if
        end |λ|
    end script
end cons


-- enumFrom :: Enum a => a -> [a]
on enumFrom(x)
    script
        property v : missing value
        property blnNum : class of x is not text
        on |λ|()
            if missing value is not v then
                if blnNum then
                    set v to 1 + v
                else
                    set v to succ(v)
                end if
            else
                set v to x
            end if
            return v
        end |λ|
    end script
end enumFrom


-- fmapGen <$> :: (a -> b) -> Gen [a] -> Gen [b]
on fmapGen(f, gen)
    script
        property g : mReturn(f)
        on |λ|()
            set v to gen's |λ|()
            if v is missing value then
                v
            else
                g's |λ|(v)
            end if
        end |λ|
    end script
end fmapGen


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


-- maximum :: Ord a => [a] -> a
on maximum(xs)
    set ca to current application
    unwrap((ca's NSArray's arrayWithArray:xs)'s ¬
        valueForKeyPath:"@max.self")
end maximum


-- primeFactors :: Int -> [Int]
on primeFactors(n)
    -- A list of the prime factors of n.
    script go
        on |λ|(x)
            set sqroot to (x ^ 0.5) as integer
            if 0 = x mod 2 then
                set {q, r} to {2, 1}
            else
                set {q, r} to {3, 1}
            end if

            repeat until (sqroot < q) or (0 = (x mod q))
                set {q, r} to {1 + (r * 4) - (((r / 2) as integer) * 2), 1 + r}
            end repeat

            if q > sqroot then
                {x}
            else
                {q} & |λ|((x / q) as integer)
            end if
        end |λ|
    end script

    |λ|(n) of go
end primeFactors


-- str :: a -> String
on str(x)
    x as string
end str


-- take :: Int -> [a] -> [a]
-- take :: Int -> String -> String
on take(n, xs)
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
end take


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


-- justifyRight :: Int -> Char -> String -> String
on justifyRight(n, cFiller)
    script go
        on |λ|(s)
            if n > length of s then
                text -n thru -1 of ((replicate(n, cFiller) as text) & s)
            else
                s
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
