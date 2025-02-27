const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const i: i32 = 76;
    try stdout.print("{x} {*}\n", .{
        @intFromPtr(&i),
        &i
    });
}
