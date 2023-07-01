import std.stdio, std.datetime, std.algorithm, std.range;

Date[] m5w(in Date start, in Date end) pure /*nothrow*/ {
    typeof(return) res;
    // adjust to 1st day
    for (Date when = Date(start.year, start.month, 1);
         when < end;
         when.add!"months"(1))
        // Such month must have 3+4*7 days and start at friday
        // for 5 FULL weekends.
        if (when.daysInMonth == 31 &&
            when.dayOfWeek == DayOfWeek.fri)
            res ~= when;
    return res;
}

bool noM5wByYear(in int year) pure {
    return m5w(Date(year, 1, 1), Date(year, 12, 31)).empty;
}

void main() {
    immutable m = m5w(Date(1900, 1, 1), Date(2100, 12, 31));
    writeln("There are ", m.length,
            " months of which the first and last five are:");
    foreach (d; m[0 .. 5] ~ m[$ - 5 .. $])
        writeln(d.toSimpleString()[0 .. $ - 3]);

    immutable n = iota(1900, 2101).filter!noM5wByYear().walkLength();
    writefln("\nThere are %d years in the range that do not have " ~
             "months with five weekends.", n);
}
