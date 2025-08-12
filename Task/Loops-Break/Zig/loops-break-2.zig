const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var prng = std.Random.DefaultPrng.init(blk: {
        var seed: u64 = undefined;
        try std.posix.getrandom(std.mem.asBytes(&seed));
        break :blk seed;
    });
    const rand = prng.random();

    while (true) {
        const n1 = rand.intRangeAtMost(u8, 0, 19);
        try stdout.print("{d:2}  ", .{n1});

        if (n1 == 10) {
            break;
        }

        const n2 = rand.intRangeAtMost(u8, 0, 19);
        try stdout.print("{d:2}\n", .{n2});
    }

    try stdout.print("\n", .{});
}
