on monthsWithFiveWeekends(startYear, endYear)
    set Dec1 to (current date)
    tell Dec1 to set {its day, its month, its year} to {1, December, startYear - 1}
    set daysFromBaseFriday to (Dec1's weekday as integer) - Friday
    set longMonths to {"January", "March", "May", "July", "August", "October", "December"}
    set daysBetween to {31, 59, 61, 61, 31, 61, 61} -- Days since starts of preceding long months.
    set hits to {}
    set hitlessYears to {}
    repeat with y from startYear to endYear
        set noHIts to true
        -- Find long months that begin on Fridays.
        repeat with i from 1 to 7
            set daysFromBaseFriday to daysFromBaseFriday + (daysBetween's item i)
            if ((i = 2) and (y mod 4 = 0) and ((y mod 100 > 0) or (y mod 400 = 0))) then ¬
                set daysFromBaseFriday to daysFromBaseFriday + 1 -- Leap year.
            if (daysFromBaseFriday mod 7 = 0) then
                set end of hits to (longMonths's item i) & (space & y)
                set noHIts to false
            end if
        end repeat
        if (noHIts) then set end of hitlessYears to y
    end repeat

    return {hits:hits, hitlessYears:hitlessYears}
end monthsWithFiveWeekends

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

on task()
    set {startYear, endYear} to {1900, 2100}
    set theResults to monthsWithFiveWeekends(startYear, endYear)
    set output to {((count theResults's hits) as text) & " of the months from " & startYear & ¬
        " to " & endYear & " have five weekends,", ¬
        "the first and last five of these months being:"}
    set end of output to join(theResults's hits's items 1 thru 5, ", ") & " …"
    set end of output to "… " & join(theResults's hits's items -5 thru -1, ", ")
    set hitlessCount to (count theResults's hitlessYears)
    set end of output to linefeed & hitlessCount & " of the years have no such months:"
    set cut to (hitlessCount + 1) div 2
    set end of output to join(theResults's hitlessYears's items 1 thru cut, ", ")
    set end of output to join(theResults's hitlessYears's items (cut + 1) thru -1, ", ")
    return join(output, linefeed)
end task

task()
