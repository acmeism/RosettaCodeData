const std = @import("std");

pub fn main() !void {
    // left hand side type can be ommitted
    const fruit: [2][]const u8 = [_][]const u8{ "apples", "oranges" };
    const stdout_wr = std.io.getStdOut().writer();
    // slices and arrays have an len field
    try stdout_wr.print("fruit.len = {d}\n", .{fruit.len});
}
