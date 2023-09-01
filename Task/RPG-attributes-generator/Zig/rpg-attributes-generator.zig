const std = @import("std");

const dice = 6;
const rolls = 4;
const stat_count = 6;

// requirements
const min_stat_sum = 75;
const min_high_stat_count = 2;
const high_stat_threshold = 15;

const RollResult = struct { stats: [stat_count]u16, total: u16 };

fn roll_attribute(rand: std.rand.Random) u16 {
    var min_roll: u16 = dice;
    var total: u16 = 0;

    for (0..rolls) |_| {
        const roll = rand.uintAtMost(u16, dice - 1) + 1;
        if (min_roll > roll) {
            min_roll = roll;
        }
        total += roll;
    }

    return total - min_roll;
}

fn roll_stats(rand: std.rand.Random) RollResult {
    var result: RollResult = RollResult{
        .stats = undefined,
        .total = 0,
    };
    var high_stat_count: u16 = 0;

    var i: u16 = 0;
    while (i < stat_count) {
        // roll a stat
        result.stats[i] = roll_attribute(rand);
        result.total += result.stats[i];
        if (result.stats[i] >= high_stat_threshold) high_stat_count += 1;

        // find the maximum possible total
        const stats_remain = stat_count - i - 1;
        const max_possible_total = result.total + dice * (rolls - 1) * stats_remain;

        // if it is below the minimum or there are not enough stats over 15 reset
        if (max_possible_total < min_stat_sum or high_stat_count + stats_remain < 2) {
            i = 0;
            result.total = 0;
            high_stat_count = 0;
        } else {
            i += 1;
        }
    }

    return result;
}

pub fn main() !void {
    // Create random generator
    var prng = std.rand.DefaultPrng.init(blk: {
        var seed: u64 = undefined;
        try std.os.getrandom(std.mem.asBytes(&seed));
        break :blk seed;
    });
    const rand = prng.random();

    const stats = roll_stats(rand);
    const stdout = std.io.getStdOut().writer();

    try stdout.print("Total: {}\n", .{stats.total});
    try stdout.print("Stats: [ ", .{});
    for (stats.stats) |stat| {
        try stdout.print("{} ", .{stat});
    }
    try stdout.print("]\n", .{});
}
