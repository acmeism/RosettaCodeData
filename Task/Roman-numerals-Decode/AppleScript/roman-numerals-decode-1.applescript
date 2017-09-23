-- romanValue :: String -> Int
on romanValue(s)
    script roman
        property mapping : [["M", 1000], ["CM", 900], ["D", 500], ["CD", 400], ¬
            ["C", 100], ["XC", 90], ["L", 50], ["XL", 40], ["X", 10], ["IX", 9], ¬
            ["V", 5], ["IV", 4], ["I", 1]]

        -- Value of first Roman glyph + value of remaining glyphs
        -- toArabic :: [Char] -> Int
        on toArabic(xs)
            script transcribe
                -- If this glyph:value pair matches the head of the list
                -- return the value and the tail of the list
                -- transcribe :: (String, Number) -> Maybe (Number, [String])
                on |λ|(lstPair)
                    set lstR to characters of (item 1 of lstPair)
                    if isPrefixOf(lstR, xs) then
                        -- Value of this matching glyph, with any remaining glyphs
                        {item 2 of lstPair, drop(length of lstR, xs)}
                    else
                        {}
                    end if
                end |λ|
            end script

            if length of xs > 0 then
                set lstParse to concatMap(transcribe, mapping)
                (item 1 of lstParse) + toArabic(item 2 of lstParse)
            else
                0
            end if
        end toArabic
    end script

    toArabic(characters of s) of roman
end romanValue

-- TEST -----------------------------------------------------------------------
on run
    map(romanValue, {"MCMXC", "MDCLXVI", "MMVIII"})

    --> {1990, 1666, 2008}
end run


-- GENERIC FUNCTIONS ----------------------------------------------------------

-- concatMap :: (a -> [b]) -> [a] -> [b]
on concatMap(f, xs)
    set lst to {}
    set lng to length of xs
    tell mReturn(f)
        repeat with i from 1 to lng
            set lst to (lst & |λ|(item i of xs, i, xs))
        end repeat
    end tell
    return lst
end concatMap

--  drop :: Int -> a -> a
on drop(n, a)
    if n < length of a then
        if class of a is text then
            text (n + 1) thru -1 of a
        else
            items (n + 1) thru -1 of a
        end if
    else
        {}
    end if
end drop

-- isPrefixOf :: [a] -> [a] -> Bool
on isPrefixOf(xs, ys)
    if length of xs = 0 then
        true
    else
        if length of ys = 0 then
            false
        else
            set {x, xt} to uncons(xs)
            set {y, yt} to uncons(ys)
            (x = y) and isPrefixOf(xt, yt)
        end if
    end if
end isPrefixOf

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

-- uncons :: [a] -> Maybe (a, [a])
on uncons(xs)
    if length of xs > 0 then
        {item 1 of xs, rest of xs}
    else
        missing value
    end if
end uncons
