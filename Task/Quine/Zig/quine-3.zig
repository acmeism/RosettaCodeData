const std = @import("std");

pub fn main() !void {
    _ = try std.posix.write(std.posix.STDOUT_FILENO, @embedFile(@src().file));
}
