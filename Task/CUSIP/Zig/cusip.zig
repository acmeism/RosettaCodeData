const std = @import("std");
const print = std.debug.print;

pub fn CusipCheckDigit(cusip: *const [9:0]u8) bool {
    var i: usize = 0;
    var sum: i32 = 0;
    while (i < 8) {
        const c = cusip[i];
        var v: i32 = undefined;
        if (c <= '9' and c >= '0') {
            v = c - 48;
        }
        else if (c <= 'Z' and c >= 'A') {
            v = c - 55;
        }
        else if (c == '*') {
            v = 36;
        }
        else if (c == '@') {
            v = 37;
        }
        else if (c == '#') {
            v = 38;
        }
        else {
            return false;
        }
        if (i % 2 == 1) {
            v *= 2;
        }
        sum = sum + @divFloor(v, 10) + @mod(v, 10);
        i += 1;
    }
    return (cusip[8] - 48 == @mod((10 - @mod(sum, 10)), 10));
}

pub fn main() void {
    const cusips = [_]*const [9:0]u8 {
        "037833100",
        "17275R102",
        "38259P508",
        "594918104",
        "68389X106",
        "68389X105"
    };
    for (cusips) |cusip| {
        print("{s} -> {}\n", .{cusip, CusipCheckDigit(cusip)});
    }
}
