import std.datetime.date;
import std.stdio;

void main() {
    auto fromDate = Date.fromISOExtString("2019-01-01");
    auto toDate = Date.fromISOExtString("2019-10-07");
    auto diff = toDate - fromDate;
    writeln("Number of days between ", fromDate, " and ", toDate, ": ", diff.total!"days");
}
