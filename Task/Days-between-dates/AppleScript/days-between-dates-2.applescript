use AppleScript version "2.4"
use framework "Foundation"
use scripting additions


-- daysBetween :: String -> String -> Int
on daysBetween(iso8601From, iso8601To)
    set midnight to "T00:00:00+00:00"
    ((dateFromISO8601(iso8601To & midnight) - ¬
        dateFromISO8601(iso8601From & midnight)) / 86400) as integer
end daysBetween


-- dateFromISO8601 :: String -> Date
on dateFromISO8601(isoDateString)
    set ca to current application
    tell ca's NSISO8601DateFormatter's alloc's init()
        set its formatOptions to ¬
            (ca's NSISO8601DateFormatWithInternetDateTime as integer)
        (its dateFromString:(isoDateString)) as date
    end tell
end dateFromISO8601


---------------------------TEST----------------------------
on run
    script test
        on |λ|(ab)
            set {a, b} to ab
            set delta to daysBetween(a, b)
            (a & " -> " & b & " -> " & ¬
                justifyRight(5, space, delta as string)) & ¬
                pluralize(delta, " day")
        end |λ|
    end script

    unlines(map(test, {¬
        {"2020-04-11", "2001-01-01"}, ¬
        {"2020-04-11", "2020-04-12"}, ¬
        {"2020-04-11", "2020-04-11"}, ¬
        {"2019-01-01", "2019-09-30"}}))
end run



--------------------GENERIC FUNCTIONS ---------------------

-- Absolute value.
-- abs :: Num -> Num
on abs(x)
    if 0 > x then
        -x
    else
        x
    end if
end abs


-- justifyRight :: Int -> Char -> String -> String
on justifyRight(n, cFiller, strText)
    if n > length of strText then
        text -n thru -1 of ((replicate(n, cFiller) as text) & strText)
    else
        strText
    end if
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


-- pluralize :: Int -> String -> String
on pluralize(n, s)
    set m to abs(n)
    if 0 = m or 2 ≤ m then
        s & "s"
    else
        s
    end if
end pluralize


-- replicate :: Int -> String -> String
on replicate(n, s)
    set out to ""
    if n < 1 then return out
    set dbl to s

    repeat while (n > 1)
        if (n mod 2) > 0 then set out to out & dbl
        set n to (n div 2)
        set dbl to (dbl & dbl)
    end repeat
    return out & dbl
end replicate


-- unlines :: [String] -> String
on unlines(xs)
    -- A single string formed by the intercalation
    -- of a list of strings with the newline character.
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, linefeed}
    set str to xs as text
    set my text item delimiters to dlm
    str
end unlines
