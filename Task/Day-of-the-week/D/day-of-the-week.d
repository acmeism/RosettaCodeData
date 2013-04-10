import std.stdio, std.datetime, std.conv, std.algorithm, std.range;

void main() {
    writeln("Christmas comes on a Sunday in the years:");
    foreach (year; 2008 .. 2122) {
        immutable d = text(year) ~ "-Dec-25";
        if (Date.fromSimpleString(d).dayOfWeek() == DayOfWeek.sun)
            writeln(year);
    }
}
