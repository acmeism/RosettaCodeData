on palindromeDates(startYear, targetNumber)
    script o
        property output : {}
    end script

    set counter to 0
    set y to startYear
    repeat until ((counter = targetNumber) or (y > 9999))
        -- Derive a month number from the last two digits of the current year number. It's valid if it's in the range 1 to 12.
        set m to y mod 10 * 10 + y mod 100 div 10
        if ((m > 0) and (m < 13)) then
            -- Derive a day number from the first two digits of the year number.
            set d to y div 100 mod 10 * 10 + y div 1000
            -- It's valid if it's between 1 and 28. Otherwise, if it's between 29 and 31, check that it fits the month and year.
            -- In fact though, it'll only ever be 2 or 12 in the period containing the 15 palindromic dates after 2020.
            if ((d > 0) and ¬
                ((d < 29) ¬
                    or ((d < 31) and ((m is not 2) or ((d is 29) and (y mod 4 is 0) and ((y mod 100 > 0) or (y mod 400 is 0))))) ¬
                    or ((d is 31) and (m is not in {2, 4, 9, 6, 11})))) then
                -- If the figures represent a valid date, add a yyyy-mm-dd format text to the end of the output list.
                tell ((100000000 + y * 10000 + m * 100 + d) as text) to ¬
                    set end of o's output to text 2 thru 5 & ("-" & text 6 thru 7) & ("-" & text 8 thru 9)
                set counter to counter + 1
            end if
        end if
        set y to y + 1
    end repeat

    return o's output
end palindromeDates

palindromeDates(2021, 15)
