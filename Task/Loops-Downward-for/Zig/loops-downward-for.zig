const std = @import("std");

pub fn main() !void {
    var i: u8 = 11;
    while (i > 0) {
        i -= 1;
        try std.io.getStdOut().writer().print("{d}\n", .{i});
    }
}
