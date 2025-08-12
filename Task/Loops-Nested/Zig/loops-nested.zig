const std = @import("std");

const ARR_ROWS = 10;
const ARR_COLS = 10;

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var prng = std.Random.DefaultPrng.init(blk: {
        var seed: u64 = undefined;
        try std.posix.getrandom(std.mem.asBytes(&seed));
        break :blk seed;
    });
    const rand = prng.random();
    var bi_arr: [ARR_ROWS][ARR_COLS]u8 = undefined;

    // generate values for the bi-dimensional array
    for (0..ARR_ROWS) |row| {
        for (0..ARR_COLS) |col| {
            bi_arr[row][col] = rand.intRangeAtMost(u8, 0, 20);
        }
    }

    // search for the value 20 in the bi-dimensional array
    const target: u8 = 20;
    search: for (0..ARR_ROWS) |row| {
        for (0..ARR_COLS) |col| {
            try stdout.print("{d:2} ", .{bi_arr[row][col]});

            if (bi_arr[row][col] == target) {
                break :search;
            }
        }

        try stdout.print("\n", .{});
    }

    try stdout.print("\n", .{});
}
