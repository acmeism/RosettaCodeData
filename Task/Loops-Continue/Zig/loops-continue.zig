const std = @import("std");

pub fn main() !void {
    const stdout_wr = std.io.getStdOut().writer();
    var i: i8 = 1;
    while (i <= 10) : (i += 1) {
        try stdout_wr.print("{d}", .{i});
        if (i == 5) {
            try stdout_wr.writeAll("\n");
            continue;
        }
        try stdout_wr.writeAll(", ");
    }
}
