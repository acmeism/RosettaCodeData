void main() {
    import std.stdio, std.datetime, std.traits;

    enum first_year = 1900;
    enum last_year = 2100;

    uint totalNo5Weekends;
    immutable(Date)[] fiveWeekendMonths;
    foreach (immutable year; first_year .. last_year + 1) {
        bool has5Weekends = false;

        foreach (immutable month; EnumMembers!Month) {
            immutable firstDay = Date(year, month, 1);
            if (firstDay.daysInMonth == 31 &&
                firstDay.dayOfWeek == DayOfWeek.fri) {
                has5Weekends = true;
                fiveWeekendMonths ~= firstDay;
            }
        }

        if (!has5Weekends)
            totalNo5Weekends++;
    }

    writefln("Total 5-weekend months between %d and %d: %d",
             first_year, last_year, fiveWeekendMonths.length);
    foreach (immutable date; fiveWeekendMonths[0 .. 5])
        writeln(date.month, ' ', date.year);
    "...".writeln;
    foreach (immutable date; fiveWeekendMonths[$ - 5 .. $])
        writeln(date.month, ' ', date.year);

    writeln("\nTotal number of years with no 5-weekend months: ",
            totalNo5Weekends);
}
