-- LAST SUNDAYS OF YEAR ------------------------------------------------------

--  lastSundaysOfYear :: Int -> [Date]
on lastSundaysOfYear(y)

    -- lastWeekDaysOfYear :: Int -> Int -> [Date]
    script lastWeekDaysOfYear
        on |λ|(intYear, iWeekday)

            -- lastWeekDay :: Int -> Int -> Date
            script lastWeekDay
                on |λ|(iLastDay, iMonth)
                    set iYear to intYear

                    calendarDate(iYear, iMonth, iLastDay - ¬
                        (((weekday of calendarDate(iYear, iMonth, iLastDay)) as integer) + ¬
                            (7 - (iWeekday))) mod 7)
                end |λ|
            end script

            map(lastWeekDay, lastDaysOfMonths(intYear))
        end |λ|

        -- isLeapYear :: Int -> Bool
        on isLeapYear(y)
            (0 = y mod 4) and (0 ≠ y mod 100) or (0 = y mod 400)
        end isLeapYear

        -- lastDaysOfMonths :: Int -> [Int]
        on lastDaysOfMonths(y)
            {31, cond(isLeapYear(y), 29, 28), 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}
        end lastDaysOfMonths
    end script

    lastWeekDaysOfYear's |λ|(y, Sunday as integer)
end lastSundaysOfYear


-- TEST ----------------------------------------------------------------------
on run argv

    intercalate(linefeed, ¬
        map(isoRow, ¬
            transpose(map(lastSundaysOfYear, ¬
                apply(cond(class of argv is list and argv ≠ {}, ¬
                    singleYearOrRange, fiveCurrentYears), argIntegers(argv))))))

end run

-- ARGUMENT HANDLING ---------------------------------------------------------

-- Up to two optional command line arguments: [yearFrom], [yearTo]
-- (Default range in absence of arguments: from two years ago, to two years ahead)

-- ~ $ osascript ~/Desktop/lastSundays.scpt
-- ~ $ osascript ~/Desktop/lastSundays.scpt 2013
-- ~ $ osascript ~/Desktop/lastSundays.scpt 2013 2016

-- singleYearOrRange :: [Int] -> [Int]
on singleYearOrRange(argv)
    apply(cond(length of argv > 0, my range, my fiveCurrentYears), argv)
end singleYearOrRange

-- fiveCurrentYears :: () -> [Int]
on fiveCurrentYears(_)
    set intThisYear to year of (current date)
    enumFromTo(intThisYear - 2, intThisYear + 2)
end fiveCurrentYears

-- argIntegers :: maybe [String] -> [Int]
on argIntegers(argv)
    if class of argv is list and argv ≠ {} then
        {map(my parseInt, argv)}
    else
        {}
    end if
end argIntegers


-- GENERIC FUNCTIONS ---------------------------------------------------------

-- apply (a -> b) -> a -> b
on apply(f, a)
    mReturn(f)'s |λ|(a)
end apply

-- calendarDate :: Int -> Int -> Int -> Date
on calendarDate(intYear, intMonth, intDay)
    tell (current date)
        set {its year, its month, its day, its time} to ¬
            {intYear, intMonth, intDay, 0}
        return it
    end tell
end calendarDate

-- cond :: Bool -> (a -> b) -> (a -> b) -> (a -> b)
on cond(bool, f, g)
    if bool then
        f
    else
        g
    end if
end cond

-- enumFromTo :: Int -> Int -> [Int]
on enumFromTo(m, n)
    if m > n then
        set d to -1
    else
        set d to 1
    end if
    set lst to {}
    repeat with i from m to n by d
        set end of lst to i
    end repeat
    return lst
end enumFromTo

-- intercalate :: Text -> [Text] -> Text
on intercalate(strText, lstText)
    set {dlm, my text item delimiters} to ¬
        {my text item delimiters, strText}
    set strJoined to lstText as text
    set my text item delimiters to dlm
    return strJoined
end intercalate

-- isoDateString :: Date -> String
on isoDateString(dte)
    (((year of dte) as string) & ¬
        "-" & text items -2 thru -1 of ¬
        ("0" & ((month of dte) as integer) as string)) & ¬
        "-" & text items -2 thru -1 of ¬
        ("0" & day of dte)
end isoDateString

-- isoRow :: [Date] -> String
on isoRow(lstDate)
    intercalate(tab, map(my isoDateString, lstDate))
end isoRow

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

-- parseInt :: String -> Int
on parseInt(s)
    s as integer
end parseInt

-- transpose :: [[a]] -> [[a]]
on transpose(xss)
    script column
        on |λ|(_, iCol)
            script row
                on |λ|(xs)
                    item iCol of xs
                end |λ|
            end script

            map(row, xss)
        end |λ|
    end script

    map(column, item 1 of xss)
end transpose
