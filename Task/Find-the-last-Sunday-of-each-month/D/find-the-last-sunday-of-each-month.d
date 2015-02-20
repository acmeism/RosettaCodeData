void lastSundays(in uint year) {
    import std.stdio, std.datetime;

    foreach (immutable month; 1 .. 13) {
        auto date = Date(year, month, 1);
        date.day(date.daysInMonth);
        date.roll!"days"(-(date.dayOfWeek + 7) % 7);
        date.writeln;
    }
}

void main() {
    lastSundays(2013);
}
