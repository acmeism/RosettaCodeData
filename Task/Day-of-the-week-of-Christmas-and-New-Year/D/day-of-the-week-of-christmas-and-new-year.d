import std.stdio, std.datetime;

immutable dayNames = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];

void main() {
    writeln("25th of December 2021 is a ", dayNames[Date(2021, 12, 25).dayOfWeek]);
    writeln("1st of January 2022 is a ", dayNames[Date(2022, 1, 1).dayOfWeek]);
}
