-- TEST -----------------------------------------------------------------------
on run

    fiveWeekends(1900, 2100)

end run

-- FIVE WEEKENDS --------------------------------------------------------------

-- fiveWeekends :: Int -> Int -> Record
on fiveWeekends(fromYear, toYear)
    set lstYears to enumFromTo(fromYear, toYear)

    -- yearMonthString :: (Int, Int) -> String
    script yearMonthString
        on |λ|(lstYearMonth)
            ((item 1 of lstYearMonth) as string) & " " & ¬
                item (item 2 of lstYearMonth) of ¬
                {"January", "", "March", "", "May", "", ¬
                    "July", "August", "", "October", "", "December"}
        end |λ|
    end script

    -- addLongMonthsOfYear :: [(Int, Int)] -> [(Int, Int)]
    script addLongMonthsOfYear
        on |λ|(lstYearMonth, intYear)

            -- yearMonth :: Int -> (Int, Int)
            script yearMonth
                on |λ|(intMonth)
                    {intYear, intMonth}
                end |λ|
            end script

            lstYearMonth & ¬
                map(yearMonth, my longMonthsStartingFriday(intYear))
        end |λ|
    end script

    -- leanYear :: Int -> Bool
    script leanYear
        on |λ|(intYear)
            0 = length of longMonthsStartingFriday(intYear)
        end |λ|
    end script

    set lstFullMonths to map(yearMonthString, ¬
        foldl(addLongMonthsOfYear, {}, lstYears))

    set lstLeanYears to filter(leanYear, lstYears)

    {{|number|:length of lstFullMonths}, ¬
        {firstFive:(items 1 thru 5 of lstFullMonths)}, ¬
        {lastFive:(items -5 thru -1 of lstFullMonths)}, ¬
        {leanYearCount:length of lstLeanYears}, ¬
        {leanYears:lstLeanYears}}
end fiveWeekends

-- longMonthsStartingFriday :: Int -> [Int]
on longMonthsStartingFriday(intYear)

    --     startIsFriday :: Int -> Bool
    script startIsFriday
        on |λ|(iMonth)
            weekday of calendarDate(intYear, iMonth, 1) is Friday
        end |λ|
    end script

    filter(startIsFriday, [1, 3, 5, 7, 8, 10, 12])
end longMonthsStartingFriday

-- calendarDate :: Int -> Int -> Int -> Date
on calendarDate(intYear, intMonth, intDay)
    tell (current date)
        set {its year, its month, its day, its time} to ¬
            {intYear, intMonth, intDay, 0}
        return it
    end tell
end calendarDate

-- GENERIC FUNCTIONS ----------------------------------------------------------

-- enumFromTo :: Enum a => a -> a -> [a]
on enumFromTo(m, n)
    set {intM, intN} to {fromEnum(m), fromEnum(n)}

    if intM > intN then
        set d to -1
    else
        set d to 1
    end if
    set lst to {}
    if class of m is text then
        repeat with i from intM to intN by d
            set end of lst to chr(i)
        end repeat
    else
        repeat with i from intM to intN by d
            set end of lst to i
        end repeat
    end if
    return lst
end enumFromTo

-- fromEnum :: Enum a => a -> Int
on fromEnum(x)
    set c to class of x
    if c is boolean then
        if x then
            1
        else
            0
        end if
    else if c is text then
        if x ≠ "" then
            id of x
        else
            missing value
        end if
    else
        x as integer
    end if
end fromEnum

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
