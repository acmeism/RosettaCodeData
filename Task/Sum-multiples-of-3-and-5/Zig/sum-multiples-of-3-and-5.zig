const std = @import("std");
const stdout = std.io.getStdOut().writer();

fn sumdiv(n: i64, d: i64) i128 {
    var m: i128 = @divFloor(n, d);
    return @divExact(m * (m + 1), 2) * d;
}

fn sum3or5(n: i64) i128 {
    return sumdiv(n, 3) + sumdiv(n, 5) - sumdiv(n, 15);
}

pub fn main() !void {
    try stdout.print("The sum of the multiples of 3 and 5 below 1000 is {}\n", .{sum3or5(999)});
    try stdout.print("The sum of the multiples of 3 and 5 below 1e18 is {}\n", .{sum3or5(999_999_999_999_999_999)});
}
