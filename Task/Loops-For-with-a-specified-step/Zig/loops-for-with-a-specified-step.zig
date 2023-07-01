const std = @import("std");

pub fn main() !void {
    const stdout_wr = std.io.getStdOut().writer();
    var i: u8 = 1;
    while (i < 10) : (i += 2)
        try stdout_wr.print("{d}\n", .{i});
}
