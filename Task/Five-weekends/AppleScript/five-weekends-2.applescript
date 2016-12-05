on run

    fiveWeekends(1900, 2100)

end run

-- fiveWeekends :: Int -> Int -> Record
on fiveWeekends(fromYear, toYear)
    set lstYears to range(fromYear, toYear)

    -- yearMonthString :: (Int, Int) -> String
    script yearMonthString
        on lambda(lstYearMonth)
            ((item 1 of lstYearMonth) as string) & " " & ¬
                item (item 2 of lstYearMonth) of ¬
                {"January", "", "March", "", "May", "", ¬
                    "July", "August", "", "October", "", "December"}
        end lambda
    end script

    -- addLongMonthsOfYear :: [(Int, Int)] -> [(Int, Int)]
    script addLongMonthsOfYear
        on lambda(lstYearMonth, intYear)

            -- yearMonth :: Int -> (Int, Int)
            script yearMonth
                on lambda(intMonth)
                    return {intYear, intMonth}
                end lambda
            end script

            lstYearMonth & ¬
                map(yearMonth, my longMonthsStartingFriday(intYear))
        end lambda
    end script

    -- leanYear :: Int -> Bool
    script leanYear
        on lambda(intYear)
            0 = length of longMonthsStartingFriday(intYear)
        end lambda
    end script

    set lstFullMonths to map(yearMonthString, ¬
        foldl(addLongMonthsOfYear, {}, lstYears))

    set lstLeanYears to filter(leanYear, lstYears)

    return {{|number|:length of lstFullMonths}, ¬
        {firstFive:(items 1 thru 5 of lstFullMonths)}, ¬
        {lastFive:(items -5 thru -1 of lstFullMonths)}, ¬
        {leanYearCount:length of lstLeanYears}, ¬
        {leanYears:lstLeanYears}}
end fiveWeekends


-- longMonthsStartingFriday :: Int -> [Int]
on longMonthsStartingFriday(intYear)

    --     startIsFriday :: Int -> Bool
    script startIsFriday
        on lambda(iMonth)
            weekday of calendarDate(intYear, iMonth, 1) is Friday
        end lambda
    end script

    filter(startIsFriday, [1, 3, 5, 7, 8, 10, 12])
end longMonthsStartingFriday


---------------------------------------------------------------------------

-- GENERIC FUNCTIONS

-- calendarDate :: Int -> Int -> Int -> Date
on calendarDate(intYear, intMonth, intDay)
    tell (current date)
        set {its year, its month, its day, its time} to ¬
            {intYear, intMonth, intDay, 0}
        return it
    end tell
end calendarDate

-- filter :: (a -> Bool) -> [a] -> [a]
on filter(f, xs)
    tell mReturn(f)
        set lst to {}
        set lng to length of xs
        repeat with i from 1 to lng
            set v to item i of xs
            if lambda(v, i, xs) then set end of lst to v
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
            set v to lambda(v, item i of xs, i, xs)
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
            set end of lst to lambda(item i of xs, i, xs)
        end repeat
        return lst
    end tell
end map

-- range :: Int -> Int -> [Int]
on range(m, n)
    if n < m then
        set d to -1
    else
        set d to 1
    end if
    set lst to {}
    repeat with i from m to n by d
        set end of lst to i
    end repeat
    return lst
end range

-- Lift 2nd class handler function into 1st class script wrapper
-- mReturn :: Handler -> Script
on mReturn(f)
    if class of f is script then
        f
    else
        script
            property lambda : f
        end script
    end if
end mReturn
