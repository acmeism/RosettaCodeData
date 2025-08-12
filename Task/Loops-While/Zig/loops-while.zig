const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    var n: u16 = 1024;
    while (n > 0) : (n = @divTrunc(n, 2)) {
        try stdout.print("{d}\n", .{n});
    }
}
