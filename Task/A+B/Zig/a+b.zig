const std = @import("std");
const stdout = std.io.getStdOut().writer();

const Input = enum { a, b };

pub fn main() !void {
    var buf: [1024]u8 = undefined;
    const reader = std.io.getStdIn().reader();
    const input = try reader.readUntilDelimiter(&buf, '\n');
    const values = std.mem.trim(u8, input, "\x20");

    var count: usize = 0;
    var split: usize = 0;
    for (values, 0..) |c, i| {
        if (!std.ascii.isDigit(c)) {
            count += 1;
            if (count == 1) split = i;
        }
    }

    const a = try std.fmt.parseInt(u64, values[0..split], 10);
    const b = try std.fmt.parseInt(u64, values[split + count ..], 10);

    try stdout.print("{d}\n", .{a + b});
}
