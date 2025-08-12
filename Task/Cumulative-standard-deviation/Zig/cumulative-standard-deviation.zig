const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const arr = [_]f32{ 2, 4, 4, 4, 5, 5, 7, 9 };

    var sum: f32 = 0;
    var sum2: f32 = 0;
    var count: f32 = 0;

    for (arr) |n| {
        sum += n;
        sum2 += std.math.pow(f32, n, 2);
        count += 1;

        const cumulative: f32 = count * sum2 - std.math.pow(f32, sum, 2);
        const running_sd: f32 = std.math.sqrt(cumulative) / count;

        try stdout.print("{d} {d}\n", .{n, running_sd});
    }
}
