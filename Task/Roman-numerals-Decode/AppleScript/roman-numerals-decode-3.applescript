use framework "Foundation"

-- INTEGER VALUE OF ROMAN NUMBER STRING ---------------------------------------

-- fromRoman :: String -> Int
on fromRoman(s)
    script subtractIfLower
        on |λ|(rn, L)
            set {r, n} to rn
            if L ≥ r then  -- Digit values that increase (right to left),
                {L, n + L} -- are added
            else
                {L, n - L} -- Digit values that go down, are subtracted.
            end if
        end |λ|
    end script

    snd(foldr(subtractIfLower, {0, 0}, map(my charVal, characters of s)))
end fromRoman

-- charVal :: Char -> Int
on charVal(C)
    set V to keyValue({I:1, V:5, X:10, L:50, C:100, D:500, M:1000}, ¬
        toUpper(C))
    if nothing of V then
        0
    else
        just of V
    end if
end charVal

-- TEST -----------------------------------------------------------------------
on run
    map(fromRoman, {"MDCLXVI", "MCMXC", "MMVIII", "MMXVI", "MMXVII"})

    --> {1666, 1990, 2008, 2016, 2017}
end run


-- GENERIC FUNCTIONS ----------------------------------------------------------

-- foldr :: (a -> b -> a) -> a -> [b] -> a
on foldr(f, startValue, xs)
    tell mReturn(f)
        set V to startValue
        set lng to length of xs
        repeat with I from lng to 1 by -1
            set V to |λ|(V, item I of xs, I, xs)
        end repeat
        return V
    end tell
end foldr

-- keyValue :: Record -> String -> Maybe String
on keyValue(rec, strKey)
    set ca to current application
    set V to (ca's NSDictionary's dictionaryWithDictionary:rec)'s objectForKey:strKey
    if V is not missing value then
        {nothing:false, just:item 1 of ((ca's NSArray's arrayWithObject:V) as list)}
    else
        {nothing:true}
    end if
end keyValue

-- map :: (a -> b) -> [a] -> [b]
on map(f, xs)
    tell mReturn(f)
        set lng to length of xs
        set lst to {}
        repeat with I from 1 to lng
            set end of lst to |λ|(item I of xs, I, xs)
        end repeat
        return lst
    end tell
end map

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

-- snd :: (a, b) -> b
on snd(xs)
    if class of xs is list and length of xs = 2 then
        item 2 of xs
    else
        missing value
    end if
end snd

-- toUpper :: String -> String
on toUpper(str)
    set ca to current application
    ((ca's NSString's stringWithString:(str))'s ¬
        uppercaseStringWithLocale:(ca's NSLocale's currentLocale())) as text
end toUpper
