const std = @import("std");
const print = std.debug.print;

const max_pairs = 256;

pub fn is_balanced(buf: []u8) bool {
    var count: usize = 0;
    for (buf) |ch| switch (ch) {
        '[' => count += 1,
        ']' => {
            if (count == 0) return false;
            count -= 1;
        },
        else => return false,
    };
    return count == 0;
}

pub fn main() !void {
    for (0..10) |n_pairs| {
        if (n_pairs > max_pairs)
            return error.MaximumNumberOfPairsExceded;

        var buf: [2 * max_pairs]u8 = undefined;
        for (0..n_pairs) |i| buf[i] = '[';
        for (n_pairs..n_pairs * 2) |i| buf[i] = ']';

        const rand = std.crypto.random;
        const len = n_pairs * 2;
        const reps = 2;
        for (0..len * reps) |i_rep| {
            const i = i_rep % len;
            const j = rand.int(usize) % len;
            const temp = buf[i];
            buf[i] = buf[j];
            buf[j] = temp;
        }
        const s = buf[0..len];
        print("'{s}': {}\n", .{ s, is_balanced(s) });
    }
}
