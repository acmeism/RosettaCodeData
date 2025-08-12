const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    const bool1: bool = true;
    const bool2: bool = false;
    const bool3 = 2 + 2 == 4;
    const bool4 = 2 + 2 == 5;

    try stdout.print("{any}\n", .{bool1});
    try stdout.print("{any}\n", .{bool2});
    try stdout.print("{any} {any}\n", .{@TypeOf(bool3), bool3});
    try stdout.print("{any} {any}\n", .{@TypeOf(bool4), bool4});
}
