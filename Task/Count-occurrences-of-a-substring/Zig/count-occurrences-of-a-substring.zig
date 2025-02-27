const std = @import("std");

pub fn main() void {
    std.debug.print("{d}\n", .{
        std.mem.count(u8, "the three truths", "th")
    });
}
