const std = @import("std");

pub fn main() !void {
    const stdout_wr = std.io.getStdOut().writer();
    for (1..6) |n| {
        for (0..n) |_| {
            try stdout_wr.writeAll("*");
        }
        try stdout_wr.writeAll("\n");
    }
}
