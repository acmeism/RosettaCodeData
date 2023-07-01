const std = @import("std");
pub fn main() !void {
    try std.io.getStdErr().writer().writeAll("Goodbye, World!\n");
    // debug messages are also printed to stderr
    //std.debug.print("Goodbye, World!\n");
}
