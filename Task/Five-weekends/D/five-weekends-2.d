import std.stdio, std.datetime, std.traits;

void main() {
    enum first_year = 1900;
    enum last_year = 2100;

    int totalNo5Weekends;
    const(Date)[] fiveWeekendMonths;
    foreach (year; first_year .. last_year + 1) {
        bool has5Weekends = false;

        foreach (month; [EnumMembers!Month]) {
            const firstDay = Date(year, month, 1);
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
    foreach (date; fiveWeekendMonths[0 .. 5])
        writeln(date.month, " ", date.year);
    writeln("...");
    foreach (date; fiveWeekendMonths[$ - 5 .. $])
        writeln(date.month, " ", date.year);

    writeln("\nTotal number of years with no 5-weekend months: ",
            totalNo5Weekends);
}
