const std = @import("std");

pub fn main() !void {
    const content = @embedFile(@src().file);
    try std.fs.File.stdout().writeAll(content);
}
