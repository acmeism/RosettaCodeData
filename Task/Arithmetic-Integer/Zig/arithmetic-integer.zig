const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();
    var buff = [_]u8{0} ** 1024;

    try stdout.print("Value of a: ", .{});
    const input_a: ?[]u8 = try stdin.readUntilDelimiterOrEof(buff[0..], '\n');
    const trimmed_a = std.mem.trimEnd(u8, input_a.?, "\r"); // for Windows
    const a = try std.fmt.parseInt(i32, trimmed_a, 10);

    try stdout.print("Value of b: ", .{});
    const input_b: ?[]u8 = try stdin.readUntilDelimiterOrEof(buff[0..], '\n');
    const trimmed_b = std.mem.trimEnd(u8, input_b.?, "\r"); // for Windows
    const b = try std.fmt.parseInt(i32, trimmed_b, 10);

    try stdout.print("a + b = {d}\n", .{a + b});
    try stdout.print("a - b = {d}\n", .{a - b});
    try stdout.print("a * b = {d}\n", .{a * b});
    try stdout.print("a / b (floor) = {d}\n", .{@divFloor(a, b)});
    try stdout.print("a / b (trunk) = {d}\n", .{@divTrunc(a, b)});
    try stdout.print("a % b (mod) = {d}\n", .{@mod(a, b)});
    try stdout.print("a % b (rem) = {d}\n", .{@rem(a, b)});
    try stdout.print("a ^ b = {d}\n", .{std.math.pow(i32, a, b)});
}
