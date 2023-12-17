const std = @import("std");

pub fn main() void {
    // Silently returns if writing to stderr fails.
    std.debug.print("Goodbye, World!\n", .{});
}
