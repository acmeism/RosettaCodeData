const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const size: u16 = 1 << 4;
    var y = size;
    while (y > 0) {
        y -= 1;
        for (0..y) |_| _ = try stdout.writeByte(' ');
        for (0..size - y) |x| _ = try stdout.writeAll(if (x & y != 0) "  " else "* ");
        _ = try stdout.writeByte('\n');
    }
}
