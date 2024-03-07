const std = @import("std");

fn f(x: u64) f64 {
    return 1 / @as(f64, @floatFromInt(x * x));
}

fn sum(comptime func: fn (u64) f64, n: u64) f64 {
    var s: f64 = 0.0;
    var i: u64 = n;

    while (i != 0) : (i -= 1)
        s += func(i);

    return s;
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("S_1000 = {d:.15}\n", .{sum(f, 1000)});
}
