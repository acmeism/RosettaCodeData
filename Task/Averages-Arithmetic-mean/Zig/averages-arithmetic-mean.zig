const std = @import("std");

fn sum(arr: []const f64) f64 {
    var res: f64 = 0;

    for (arr) |e| res += e;
    return res;
}

fn mean(arr: []const f64) f64 {
    return sum(arr) / @as(f64, @floatFromInt(arr.len));
}

pub fn main() !void {
    const arr = [_]f64{ 4.5, 6.7, 6.9, 1.4, 2.0, 14.12 };
    std.debug.print("mean of {any} = {d:.2}\n", .{ arr, mean(&arr) });
    std.debug.print("mean of {any} = {d:.2}\n", .{ &[_]f64{}, mean(&[_]f64{}) });
}
