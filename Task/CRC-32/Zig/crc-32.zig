const std = @import("std");
const Crc32Ieee = std.hash.Crc32;

pub fn main() !void {
    var res: u32 = Crc32Ieee.hash("The quick brown fox jumps over the lazy dog");
    std.debug.print("{x}\n", .{res});
}
