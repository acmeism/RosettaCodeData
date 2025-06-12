const std = @import("std");

pub fn main() !void {
    var a: u32 = 1;
    var b: u32 = 1;
    const target: u32 = 48;

    for (3..target + 1) |n| {
        const fib = a + b;
        std.debug.print("F({}) = {}\n", .{n, fib});
        a = b;
        b = fib;
    }
}
