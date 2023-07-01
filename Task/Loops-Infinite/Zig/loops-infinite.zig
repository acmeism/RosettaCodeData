const std = @import("std");
pub fn main() !void {
    const stdout_wr = std.io.getStdOut().writer();
    while (true) try stdout_wr.writeAll("SPAM\n");
}
