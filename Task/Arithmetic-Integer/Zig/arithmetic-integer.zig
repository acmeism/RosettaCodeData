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

    try stdout.print("Values: a {d} b {d}\n", .{a, b});
    try stdout.print("Sum: a + b = {d}\n", .{a + b});
    try stdout.print("Difference: a - b = {d}\n", .{a - b});
    try stdout.print("Product: a * b = {d}\n", .{a * b});
    try stdout.print("Integer quotient: a / b = {d}\n", .{@divTrunc(a, b)}); //truncates towards 0
    try stdout.print("Remainder: a % b = {d}\n", .{@rem(a, b)}); // same sign as first operand
    try stdout.print("Exponentiation: math.pow = {d}\n", .{std.math.pow(i64, a, b)}); //no exponentiation operator
}
