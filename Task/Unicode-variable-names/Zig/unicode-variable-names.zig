const std = @import("std");

pub fn main() void {
    var @"Δ": i32 = 1;
    @"Δ" += 1;
    std.debug.print("{d}\n", .{@"Δ"});
}
