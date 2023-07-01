const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var i: i32 = undefined;
    var address_of_i: *i32 = &i;

    try stdout.print("{x}\n", .{@ptrToInt(address_of_i)});
}
