function isLeapYear (y)
    return (y % 4 == 0 and y % 100 ~=0) or y % 400 == 0
end

function dayOfWeek (y, m, d)
    local t = os.time({year = y, month = m, day = d})
    return os.date("%A", t)
end

function lastWeekdays (wday, year)
    local monthLength, day = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}
    if isLeapYear(year) then monthLength[2] = 29 end
    for month = 1, 12 do
        day = monthLength[month]
        while dayOfWeek(year, month, day) ~= wday do day = day - 1 end
        print(year .. "-" .. month .. "-" .. day)
    end
end

lastWeekdays("Sunday", tonumber(arg[1]))
