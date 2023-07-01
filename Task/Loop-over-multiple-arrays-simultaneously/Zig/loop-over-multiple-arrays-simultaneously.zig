const std = @import("std");

const a1: []const u8 = &[_]u8{ 'a', 'b', 'c' };
const a2: []const u8 = &[_]u8{ 'A', 'B', 'C' };
const a3: []const u8 = &[_]u8{ '1', '2', '3' };

pub fn main() !void {
    for (a1) |_, i|
        try std.io.getStdOut().writer().print("{c} {c} {d}\n", .{ a1[i], a2[i], a3[i] });
}
