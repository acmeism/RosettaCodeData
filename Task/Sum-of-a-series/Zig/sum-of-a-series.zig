const std = @import("std");

fn f(x: i64) f64 {
    return 1/@intToFloat(f64, x*x);
}

fn S(fun: fn(i64) f64, n: i64) f64 {
    var s: f64 = 0.0;
    var i: i64 = n;

    while (i > 0) : (i -= 1) {
        s += fun(i);
    }
    return s;
}

pub fn main() !void
{
    const stdout = std.io.getStdOut().writer();
    try stdout.print("S_1000 = {d:.15}\n", .{S(f, 1000)});
}
