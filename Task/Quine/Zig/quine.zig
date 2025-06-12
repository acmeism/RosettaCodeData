const std = @import("std");

pub fn main() !void {
    const content = @embedFile(@src().file);
    try std.io.getStdOut().writer().print("{s}", .{content});
}
