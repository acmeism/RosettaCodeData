const std = @import("std");
const math = std.math;

pub fn main() !void {
    const stdout = std.io.getStdOut().outStream();
    try stdout.print("{d:.12}\n", .{H("1223334444")});
}

fn H(s: []const u8) f64 {
    var counts = [_]u16{0} ** 256;
    for (s) |ch|
        counts[ch] += 1;

    var h: f64 = 0;
    for (counts) |c|
        if (c != 0) {
            const p = @intToFloat(f64, c) / @intToFloat(f64, s.len);
            h -= p * math.log2(p);
        };

    return h;
}
