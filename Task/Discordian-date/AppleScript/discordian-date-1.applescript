on gregorianToDiscordian(inputDate) -- Input: AppleScript date object.
    (*
        Discordian years are aligned with, and the same length as, Gregorian years.
        Each has 73 5-day weeks and 5 73-day seasons. (73 * 5 = 365.)
        The first day of a Discordian year is also that of its first week and first season.
        In leap years, an extra day called "St. Tib's Day", is inserted between days 59 and 60.
        It's considered to be outside the calendar, so the day after it is Setting Orange, Chaos 60,
        not Sweetmorn, Chaos 61. Year 1 YOLD is 1166 BC, but this handler takes an AS date object
        as its input and is only good for AD Gregorian dates. Since the Discordian calendar's an
        American invention, the output here's in the US style: "Weekday, Season day, year".
    *)
    -- Calculate the input date's day-of-year number.
    copy inputDate to startOfYear
    tell startOfYear to set {its day, its month} to {1, January}
    set dayOfYear to (inputDate - startOfYear) div days + 1

    -- If it's a leap year, special-case St. Tib's Day, or adjust the day-of-year number if the day comes after that.
    set y to inputDate's year
    if ((y mod 4 is 0) and ((y mod 100 > 0) or (y mod 400 is 0))) then
        if (dayOfYear is 60) then
            set dayOfYear to "St. Tib's Day"
        else if (dayOfYear > 60) then
            set dayOfYear to dayOfYear - 1
        end if
    end if

    -- Start the output text with either "St. Tib's Day" or the weekday, season, and day-of-season number.
    if (dayOfYear is "St. Tib's Day") then
        set outputText to dayOfYear
    else
        tell dayOfYear - 1
            set dayOfWeek to it mod 5 + 1
            set seasonNumber to it div 73 + 1
            set dayOfSeason to it mod 73 + 1
        end tell
        set theWeekdays to {"Sweetmorn", "Boomtime", "Pungenday", "Prickle-Prickle", "Setting Orange"}
        set theSeasons to {"Chaos ", "Discord ", "Confusion ", "Bureaucracy ", "The Aftermath "}
        set outputText to (item dayOfWeek of theWeekdays) & ", " & (item seasonNumber of theSeasons) & dayOfSeason
    end if

    -- Append the Discordian year number and return the result.
    return outputText & ", " & (y + 1166)
end gregorianToDiscordian

set ASDate to (current date)
set gregorianDate to ASDate's date string
set discordianDate to gregorianToDiscordian(ASDate)
return {Gregorian:gregorianDate, Discordian:discordianDate}
