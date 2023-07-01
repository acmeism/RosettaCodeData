-- jewelCount :: String -> String -> Int
on jewelCount(jewels, stones)
    set js to chars(jewels)
    script
        on |λ|(a, c)
            if elem(c, jewels) then
                a + 1
            else
                a
            end if
        end |λ|
    end script
    foldl(result, 0, chars(stones))
end jewelCount

-- OR in terms of filter
-- jewelCount :: String -> String -> Int
on jewelCount2(jewels, stones)
    script
        on |λ|(c)
            elem(c, jewels)
        end |λ|
    end script
    length of filter(result, stones)
end jewelCount2

-- TEST --------------------------------------------------
on run

    unlines(map(uncurry(jewelCount), ¬
        {Tuple("aA", "aAAbbbb"), Tuple("z", "ZZ")}))

end run


-- GENERIC FUNCTIONS -------------------------------------

-- Tuple (,) :: a -> b -> (a, b)
on Tuple(a, b)
    {type:"Tuple", |1|:a, |2|:b}
end Tuple

-- chars :: String -> [Char]
on chars(s)
    characters of s
end chars

-- elem :: Eq a => a -> [a] -> Bool
on elem(x, xs)
    considering case
        xs contains x
    end considering
end elem

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
    tell mReturn(f)
        set lng to length of xs
        set lst to {}
        repeat with i from 1 to lng
            set end of lst to |λ|(item i of xs, i, xs)
        end repeat
        return lst
    end tell
end map

-- Lift 2nd class handler function into 1st class script wrapper
-- mReturn :: First-class m => (a -> b) -> m (a -> b)
on mReturn(f)
    if class of f is script then
        f
    else
        script
            property |λ| : f
        end script
    end if
end mReturn

-- Returns a function on a single tuple (containing 2 arguments)
-- derived from an equivalent function with 2 distinct arguments
-- uncurry :: (a -> b -> c) -> ((a, b) -> c)
on uncurry(f)
    script
        property mf : mReturn(f)'s |λ|
        on |λ|(pair)
            mf(|1| of pair, |2| of pair)
        end |λ|
    end script
end uncurry

-- unlines :: [String] -> String
on unlines(xs)
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, linefeed}
    set str to xs as text
    set my text item delimiters to dlm
    str
end unlines
