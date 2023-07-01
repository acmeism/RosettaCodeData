on isLongYear(y)
    -- ISO8601 weeks begin on Mondays and belong to the year in which they have the most days.
    -- A year which begins on a Thursday, or which begins on a Wednesday and is a leap year,
    -- has majority stakes in the weeks it overlaps at *both* ends and so has 53 weeks instead of 52.
    -- Leap years divisible by 400 begin on Saturdays and so don't so need to be considered in the leap year check.

    tell (current date) to set {Jan1, its day, its month, its year} to {it, 1, January, y}
    set startWeekday to Jan1's weekday

    return ((startWeekday is Thursday) or ((startWeekday is Wednesday) and (y mod 4 is 0) and (y mod 100 > 0)))
end isLongYear

set longYears to {}
repeat with y from 2001 to 2100
    if (isLongYear(y)) then set end of longYears to y
end repeat

return longYears
