use framework "Foundation"

----------- INTEGER VALUE OF ROMAN NUMBER STRING ---------

-- fromRoman :: String -> Int
on fromRoman(s)
    script subtractIfLower
        on |λ|(l, rn)
            set {r, n} to rn
            if l ≥ r then -- Digit values that increase (L to R),
                {l, n + l} -- (added)
            else
                {l, n - l} -- Digit values that go down: subtracted.
            end if
        end |λ|
    end script

    item 2 of foldr(subtractIfLower, {0, 0}, ¬
        map(my charVal, characters of s))
end fromRoman


-- charVal :: Char -> Int
on charVal(C)
    set v to lookup(toUpper(C), ¬
        {I:1, |V|:5, X:10, |L|:50, C:100, D:500, M:1000})
    if missing value is v then
        0
    else
        v
    end if
end charVal


--------------------------- TEST -------------------------
on run
    map(fromRoman, ¬
        {"MDCLXVI", "MCMXC", "MMVIII", "MMXVI", "MMXXI"})

    --> {1666, 1990, 2008, 2016, 2021}
end run


-------------------- GENERIC FUNCTIONS -------------------

-- foldr :: (a -> b -> b) -> b -> [a] -> b
on foldr(f, startValue, xs)
    tell mReturn(f)
        set v to startValue
        set lng to length of xs
        repeat with I from lng to 1 by -1
            set v to |λ|(item I of xs, v)
        end repeat
        return v
    end tell
end foldr


-- lookup :: a -> Dict -> Maybe b
on lookup(k, dct)
    -- Just the value of k in the dictionary,
    -- or missing value if k is not found.
    set ca to current application
    set v to (ca's NSDictionary's dictionaryWithDictionary:dct)'s ¬
        objectForKey:k
    if missing value ≠ v then
        item 1 of ((ca's NSArray's arrayWithObject:v) as list)
    else
        missing value
    end if
end lookup


-- map :: (a -> b) -> [a] -> [b]
on map(f, xs)
    -- The list obtained by applying f
    -- to each element of xs.
    tell mReturn(f)
        set lng to length of xs
        set lst to {}
        repeat with I from 1 to lng
            set end of lst to |λ|(item I of xs, I, xs)
        end repeat
        return lst
    end tell
end map


-- Lift 2nd class handler function into 1st class
-- script wrapper
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


-- toUpper :: String -> String
on toUpper(str)
    tell current application
        ((its (NSString's stringWithString:(str)))'s ¬
            uppercaseStringWithLocale:¬
                (its NSLocale's currentLocale())) as text
    end tell
end toUpper
