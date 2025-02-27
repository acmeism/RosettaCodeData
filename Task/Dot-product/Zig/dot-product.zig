const std = @import("std");

pub fn main() !void {
    const a = @Vector(3, i32){ 1, 3, -5 };
    const b = @Vector(3, i32){ 4, -2, -1 };
    const dot: i32 = @reduce(.Add, a * b);

    try std.io.getStdOut().writer().print("{d}\n", .{dot});
}
