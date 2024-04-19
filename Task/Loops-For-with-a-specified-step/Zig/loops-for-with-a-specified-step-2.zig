const std = @import("std");
const stdout = @import("std").io.getStdOut().writer();

pub fn main() !void {
    for (1..10) |n| {
        if (n % 2 == 0) continue;
        try stdout.print("{d}\n", .{n});
    }
}
