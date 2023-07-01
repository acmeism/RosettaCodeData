const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const size: u16 = 1 << 4;
    var y = size;
    while (y > 0) {
        y -= 1;
        for (0..y) |_| try stdout.writeByte(' ');
        for (0..size - y) |x| try stdout.writeAll(if (x & y != 0) "  " else "* ");
        try stdout.writeByte('\n');
    }
}
