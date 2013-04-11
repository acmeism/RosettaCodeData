MsgBox % "The year 1600 was " . (IsLeapYear(1600) ? "" : "not ") . "a leap year"

IsLeapYear(Year)
{
 Return, !Mod(Year, 100) && !Mod(Year, 400) && !Mod(Year, 4)
}
