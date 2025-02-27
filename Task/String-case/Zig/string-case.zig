const std = @import("std");

pub fn main() !void {
    const stdout_wr = std.io.getStdOut().writer();
    const string = "alphaBETA";
    var lower: [string.len]u8 = undefined;
    var upper: [string.len]u8 = undefined;
    for (string, &lower, &upper) |char, *lo, *up| {
        lo.* = std.ascii.toLower(char);
        up.* = std.ascii.toUpper(char);
    }
    try stdout_wr.print("lower: {s}\n", .{lower});
    try stdout_wr.print("upper: {s}\n", .{upper});

    // TODO use https://codeberg.org/dude_the_builder/zigstr
}
