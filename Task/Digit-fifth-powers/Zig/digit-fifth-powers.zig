const std = @import("std");

fn sum5(n: u32) u32 {
    var i = n;
    var r: u32 = 0;
    while (i != 0) : (i /= 10)
       r += std.math.pow(u32, i%10, 5);
    return r;
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const max = std.math.pow(u32,9,5) * 6;

    var n: u32 = 2;
    var total: u32 = 0;
    while (n <= max) : (n += 1) {
        if (sum5(n) == n) {
            try stdout.print("{d:6}\n", .{n});
            total += n;
        }
    }

    try stdout.print("Total: {d:6}\n", .{total});
}
