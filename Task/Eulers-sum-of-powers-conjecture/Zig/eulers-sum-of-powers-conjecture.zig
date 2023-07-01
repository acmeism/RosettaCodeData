const std = @import("std");
const stdout = std.io.getStdOut().outStream();

pub fn main() !void {
    var pow5: [250]i64 = undefined;
    for (pow5) |*e, i| {
        const n = @intCast(i64, i);
        e.* = n * n * n * n * n;
    }
    var x0: u16 = 4;
    while (x0 < pow5.len) : (x0 += 1) {
        var x1: u16 = 3;
        while (x1 < x0) : (x1 += 1) {
            var x2: u16 = 2;
            while (x2 < x1) : (x2 += 1) {
                var x3: u16 = 1;
                while (x3 < x2) : (x3 += 1) {
                    const sum = pow5[x0] + pow5[x1] + pow5[x2] + pow5[x3];
                    var y: u16 = x0 + 1;
                    while (y < pow5.len) : (y += 1) if (sum == pow5[y]) {
                        try stdout.print("{}⁵ + {}⁵ + {}⁵ + {}⁵ = {}⁵\n", .{ x0, x1, x2, x3, y });
                        return;
                    };
                }
            }
        }
    }

    try stdout.print("Sorry, no solution found.\n", .{});
}
