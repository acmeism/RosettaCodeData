const std = @import("std");
const stdout = std.io.getStdOut().outStream();

pub fn main() !void {
    try stdout.print("The first 8 happy numbers are: ", .{});
    var n: u32 = 1;
    var c: u4 = 0;
    while (c < 8) {
        if (isHappy(n)) {
            c += 1;
            try stdout.print("{} ", .{n});
        }
        n += 1;
    }
    try stdout.print("\n", .{});
}

fn isHappy(n: u32) bool {
    var t = n;
    var h = sumsq(n);
    while (t != h) {
        t = sumsq(t);
        h = sumsq(sumsq(h));
    }
    return t == 1;
}

fn sumsq(n0: u32) u32 {
    var s: u32 = 0;
    var n = n0;
    while (n > 0) : (n /= 10) {
        const m = n % 10;
        s += m * m;
    }
    return s;
}
