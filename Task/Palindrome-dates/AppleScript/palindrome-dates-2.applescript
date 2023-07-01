use AppleScript version "2.4"
use framework "Foundation"
use scripting additions


-- palinYearsInRange :: Int -> Int -> [String]
on palinYearsInRange(fromYear, toYear)

    concatMap(palinDay(iso8601Formatter()), ¬
        enumFromTo(fromYear, toYear))

end palinYearsInRange


-- palinDay :: DateFormatter -> Int -> [String]
on palinDay(formatter)
    script
        property fmtr : formatter
        on |λ|(y)
            -- Either an empty list or a list containing a valid
            -- palindromic date for a year in the range [1000 .. 9999]
            if 10000 > y and 999 < y then
                set s to y as string
                set {m, m1, d, d1} to reverse of characters of s
                set mbDate to s & "-" & m & m1 & "-" & d & d1

                if missing value is not ¬
                    (fmtr's dateFromString:(mbDate & ¬
                        "T00:00:00+00:00")) then
                    {mbDate}
                else
                    {}
                end if
            else
                {}
            end if
        end |λ|
    end script
end palinDay


--------------------------- TEST ---------------------------
on run
    set xs to palinYearsInRange(2021, 9999)

    unlines({¬
        "Count of palindromic dates [2021..9999]: " & ¬
        ((length of xs) as string), ¬
        "", ¬
        "First 15:", unlines(items 1 thru 15 of xs), "", ¬
        "Last 15:", unlines(items -15 thru -1 of xs)})
end run


-------------------- GENERIC FUNCTIONS ---------------------

-- concatMap :: (a -> [b]) -> [a] -> [b]
on concatMap(f, xs)
    set lng to length of xs
    set acc to {}
    tell mReturn(f)
        repeat with i from 1 to lng
            set acc to acc & (|λ|(item i of xs, i, xs))
        end repeat
    end tell
    return acc
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


-- iso8601Formatter :: () -> NSISO8601DateFormatter
on iso8601Formatter()
    tell current application
        set formatter to its NSISO8601DateFormatter's alloc's init()
        set formatOptions of formatter to ¬
            (its NSISO8601DateFormatWithInternetDateTime as integer)
        return formatter
    end tell
end iso8601Formatter


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
