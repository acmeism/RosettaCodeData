const std = @import("std");

pub fn main() !void {
    const stdout_wr = std.io.getStdOut().writer();
    var i: u8 = 1;
    while (i < 5) : (i += 1) {
        var j: u8 = 1;
        while (j <= i) : (j += 1)
            try stdout_wr.writeAll("*");
        try stdout_wr.writeAll("\n");
    }
}
