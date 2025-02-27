const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut();

    try stdout.writeAll("Hello world!\n");
}
