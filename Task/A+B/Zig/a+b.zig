const std = @import("std");

pub fn main() !void {
    var buf: [1024]u8 = undefined;
    const reader = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();
    try stdout.writeAll("Enter two integers separated by a space: ");
    const input = try reader.readUntilDelimiter(&buf, '\n');
    const text = std.mem.trimRight(u8, input, "\r\n");

    var it = std.mem.tokenizeScalar(u8, text, ' ');

    const a = try std.fmt.parseInt(i64, it.next().?, 10);
    const b = try std.fmt.parseInt(i64, it.next().?, 10);


    try stdout.print("{d}\n", .{a + b});
}
