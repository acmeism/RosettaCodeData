on daysBetweenDates(date1, date2)
    considering numeric strings -- Allows for leading zeros having been omitted.
        if (date1 = date2) then return date1 & " and " & date2 & " are the same date"
    end considering

    -- Get the components of each date.
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to "-"
    set {y1, m1, d1} to date1's text items
    set {y2, m2, d2} to date2's text items
    set AppleScript's text item delimiters to astid

    -- Derive AppleScript date objects.
    -- The best way to do this generally is to use the 'current date' function to obtain a date object
    -- and then to set the properties of the result (or of a copy) to the required values.
    -- The initial setting of the day values to 1 is to prevent overflow due to possibly
    -- incompatible day and month values during the sequential setting of the properties.
    -- The integer values set here are automatically coerced from the text values obtained above.
    tell (current date) to set {its day, its year, its month, its day, its time, firstDate} to {1, y1, m1, d1, 0, it}
    copy firstDate to secondDate
    tell secondDate to set {its day, its year, its month, its day} to {1, y2, m2, d2}

    -- Do the math.
    set daysDifference to (firstDate - secondDate) div days

    -- Format some output.
    if (daysDifference > 0) then
        return date1 & " comes " & daysDifference & " day" & item (((daysDifference is 1) as integer) + 1) of {"s", ""} & ¬
            " after " & date2
    else
        return date1 & " comes " & -daysDifference & " day" & item (((daysDifference is -1) as integer) + 1) of {"s", ""} & ¬
            " before " & date2
    end if
end daysBetweenDates

return daysBetweenDates("2020-04-11", "2001-01-01") & linefeed & ¬
    daysBetweenDates("2020-04-11", "2020-04-12") & linefeed & ¬
    daysBetweenDates("2020-04-11", "2020-04-11")
