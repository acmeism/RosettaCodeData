const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("0^0 = {d:.8}\n", .{std.math.pow(f32, 0, 0)});
}
