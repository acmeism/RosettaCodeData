const std = @import("std");

pub fn main() !void {
    var i: u64 = 0;
    var result: u64 = 99_736;
    while (i < 99_736) : (i += 1) {
        if (i * i % 1_000_000 == 269_696) {
            result = i;
            break;
        }
    }
    std.debug.print("The smallest number whose square ends in 269696 is {}\n", .{i});
    std.debug.print("The square is {}\n", .{i * i});
}
