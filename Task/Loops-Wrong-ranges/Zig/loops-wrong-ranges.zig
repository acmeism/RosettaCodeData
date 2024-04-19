const std = @import("std");
const stdout = @import("std").io.getStdOut().writer();

const limit = 10;

fn printRange(start: isize, stop: isize, step: isize, comment: []const u8) !void {
    try stdout.print("{s}\r\x1b[43C: ", .{comment});
    var c: u8 = 0;
    var n = start;
    while (n <= stop) : (n += step) {
        c += 1;
        if (c > limit) break;
        try stdout.print("{d}  ", .{n});
    }
    try stdout.print("\n", .{});
}

pub fn main() !void {
    try printRange(-2, 2, 1, "Normal");
    try printRange(-2, 2, 0, "Zero increment");
    try printRange(-2, 2, -1, "Increments away from stop value");
    try printRange(-2, 2, 10, "First increment is beyond stop value");
    try printRange(2, -2, 1, "Start more than stop: positive increment");
    try printRange(2, 2, 1, "Start equal stop: positive increment");
    try printRange(2, 2, -1, "Start equal stop: negative increment");
    try printRange(2, 2, 0, "Start equal stop: zero increment");
    try printRange(0, 0, 0, "Start equal stop equal zero: zero increment");
}
