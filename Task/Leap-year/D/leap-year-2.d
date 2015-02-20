import std.datetime;

void main() {
    assert(yearIsLeapYear(1724));
    assert(!yearIsLeapYear(1973));
    assert(!Date(1900, 1, 1).isLeapYear);
    assert(DateTime(2000, 1, 1).isLeapYear);
}
