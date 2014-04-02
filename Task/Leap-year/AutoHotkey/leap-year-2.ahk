IsLeapYear(Year)
{
    return !Mod(Year, 4) && Mod(Year, 100) || !Mod(Year, 400)
}

MsgBox % "The year 1604 was " (IsLeapYear(1604) ? "" : "not ") "a leap year"
