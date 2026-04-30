function isLeapYear(integer year)
    return remainder(year,4)=0 and remainder(year,100)!=0 or remainder(year,400)=0
end function

constant YEAR = 1, MONTH = 2, DAY = 3, DAY_OF_YEAR = 8

constant month_lengths = {31,28,31,30,31,30,31,31,30,31,30,31}
function dayOfYear(sequence Date)
    integer d
    if length(Date) = DAY_OF_YEAR then
        d = Date[DAY_OF_YEAR]
    else
        d = Date[DAY]
        for i = Date[MONTH]-1 to 1 by -1 do
            d += month_lengths[i]
            if i = 2 and isLeapYear(Date[YEAR]) then
                d += 1
            end if
        end for
    end if
    return d
end function

constant seasons = {"Chaos", "Discord", "Confusion", "Bureaucracy", "The Aftermath"}
constant weekday = {"Sweetmorn", "Boomtime", "Pungenday", "Prickle-Prickle", "Setting Orange"}
constant apostle = {"Mungday", "Mojoday", "Syaday", "Zaraday", "Maladay"}
constant holiday = {"Chaoflux", "Discoflux", "Confuflux", "Bureflux", "Afflux"}

function discordianDate(sequence Date)
    sequence dyear, dseas, dwday
    integer  leap, doy, dsday
    dyear = sprintf("%d",Date[YEAR]+1166)
    leap = isLeapYear(Date[YEAR])
    if leap and Date[MONTH] = 2 and Date[DAY] = 29 then
        return "St. Tib's Day, in the YOLD " & dyear
    end if

    doy = dayOfYear(Date)
    if leap and doy >= 60 then
        doy -= 1
    end if

    dsday = remainder(doy,73)
    if dsday = 5 then
        return apostle[doy/73+1] & ", in the YOLD " & dyear
    elsif dsday = 50 then
        return holiday[doy/73+1] & ", in the YOLD " & dyear
    end if

    dseas = seasons[doy/73+1]
    dwday = weekday[remainder(doy-1,5)+1]

    return sprintf("%s, day %d of %s in the YOLD %s", {dwday, dsday, dseas, dyear})
end function

sequence today
today = date()
today[YEAR] += 1900
puts(1, discordianDate(today))
