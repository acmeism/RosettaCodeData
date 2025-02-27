const std = @import("std");

pub fn main() void {
    for(0..255) |i| {
        std.debug.print("{o}\n", .{i});
    }
}
