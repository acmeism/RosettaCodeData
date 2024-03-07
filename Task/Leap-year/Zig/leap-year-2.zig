/// The type that holds the current year, i.e. 2016
pub const Year = u16;

/// Returns true for years with 366 days
/// and false for years with 365 days.
pub fn isLeapYear(year: Year) bool {
    // In the western Gregorian Calendar leap a year is
    // a multiple of 4, excluding multiples of 100, and
    // adding multiples of 400. In code:
    //
    // if (@mod(year, 4) != 0)
    //     return false;
    // if (@mod(year, 100) != 0)
    //     return true;
    // return (0 == @mod(year, 400));

    // The following is equivalent to the above
    // but uses bitwise operations when testing
    // for divisibility, masking with 3 as test
    // for multiples of 4 and with 15 as a test
    // for multiples of 16. Multiples of 16 and
    // 100 are, conveniently, multiples of 400.
    const mask: Year = switch (year % 100) {
        0 => 0b1111,
        else => 0b11,
    };
    return 0 == year & mask;
}

test "isLeapYear" {
    try testing.expectEqual(false, isLeapYear(2095));
    try testing.expectEqual(true, isLeapYear(2096));
    try testing.expectEqual(false, isLeapYear(2100));
    try testing.expectEqual(true, isLeapYear(2400));
}
