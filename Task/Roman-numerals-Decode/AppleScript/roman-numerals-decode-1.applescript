------------- INTEGER VALUE OF A ROMAN STRING ------------

-- romanValue :: String -> Int
on romanValue(s)
    script roman
        property mapping : [["M", 1000], ["CM", 900], ["D", 500], ["CD", 400], ¬
            ["C", 100], ["XC", 90], ["L", 50], ["XL", 40], ["X", 10], ["IX", 9], ¬
            ["V", 5], ["IV", 4], ["I", 1]]

        -- Value of first Roman glyph + value of remaining glyphs
        -- toArabic :: [Char] -> Int
        on toArabic(xs)
            -- transcribe :: (String, Number) -> Maybe (Number, [String])
            script transcribe
                on |λ|(pair)
                    set {r, v} to pair
                    if isPrefixOf(characters of r, xs) then

                        -- Value of this matching glyph, with any remaining glyphs
                        {v, drop(length of r, xs)}
                    else
                        {}
                    end if
                end |λ|
            end script

            if 0 < length of xs then
                set parsed to concatMap(transcribe, mapping)
                (item 1 of parsed) + toArabic(item 2 of parsed)
            else
                0
            end if
        end toArabic
    end script

    toArabic(characters of s) of roman
end romanValue

--------------------------- TEST -------------------------
on run
    map(romanValue, {"MCMXC", "MDCLXVI", "MMVIII"})

    --> {1990, 1666, 2008}
end run


-------------------- GENERIC FUNCTIONS -------------------

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


-- drop :: Int -> [a] -> [a]
-- drop :: Int -> String -> String
on drop(n, xs)
    set c to class of xs
    if script is not c then
        if string is not c then
            if n < length of xs then
                items (1 + n) thru -1 of xs
            else
                {}
            end if
        else
            if n < length of xs then
                text (1 + n) thru -1 of xs
            else
                ""
            end if
        end if
    else
        take(n, xs) -- consumed
        return xs
    end if
end drop


-- isPrefixOf :: [a] -> [a] -> Bool
-- isPrefixOf :: String -> String -> Bool
on isPrefixOf(xs, ys)
    -- isPrefixOf takes two lists or strings and returns
    --  true if and only if the first is a prefix of the second.
    script go
        on |λ|(xs, ys)
            set intX to length of xs
            if intX < 1 then
                true
            else if intX > length of ys then
                false
            else if class of xs is string then
                (offset of xs in ys) = 1
            else
                set {xxt, yyt} to {uncons(xs), uncons(ys)}
                ((item 1 of xxt) = (item 1 of yyt)) and ¬
                    |λ|(item 2 of xxt, item 2 of yyt)
            end if
        end |λ|
    end script
    go's |λ|(xs, ys)
end isPrefixOf


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
    set lng to |length|(xs)
    if 0 = lng then
        missing value
    else
        if (2 ^ 29 - 1) as integer > lng then
            if class of xs is string then
                set cs to text items of xs
                {item 1 of cs, rest of cs}
            else
                {item 1 of xs, rest of xs}
            end if
        else
            set nxt to take(1, xs)
            if {} is nxt then
                missing value
            else
                {item 1 of nxt, xs}
            end if
        end if
    end if
end uncons
