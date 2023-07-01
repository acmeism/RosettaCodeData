const std = @import("std");

pub fn main() !void {
    const cnt_lower = 26;
    var lower: [cnt_lower]u8 = undefined;
    comptime var i = 0;
    inline while (i < cnt_lower) : (i += 1)
        lower[i] = i + 'a';

    const stdout_wr = std.io.getStdOut().writer();
    for (lower) |l|
        try stdout_wr.print("{c} ", .{l});
    try stdout_wr.writeByte('\n');
}
