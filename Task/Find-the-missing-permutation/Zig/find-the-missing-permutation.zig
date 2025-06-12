const std = @import("std");

pub fn main() !void {
    const N: usize = 4;
    const perms = [_][]const u8{
        "ABCD", "CABD", "ACDB", "DACB", "BCDA", "ACBD", "ADCB", "CDAB",
        "DABC", "BCAD", "CADB", "CDBA", "CBAD", "ABDC", "ADBC", "BDCA",
        "DCBA", "BACD", "BADC", "BDAC", "CBDA", "DBCA", "DCAB",
    };

    // Calculate n = (N-1)!, the expected number of occurrences
    var n: usize = 1;
    var i: usize = 1;
    while (i < N) : (i += 1) {
        n *= i;
    }

    var miss: [N]u8 = undefined;
    var stdout = std.io.getStdOut().writer();

    i = 0;
    while (i < N) : (i += 1) {
        var cnt = [_]usize{0} ** N;

        // Count how many times each letter occurs at position i
        for (perms) |perm| {
            const position = perm[i] - 'A';
            cnt[position] += 1;
        }

        // Find letter not occurring (N-1)! times - that's the missing one
        var j: usize = 0;
        while (j < N and cnt[j] == n) : (j += 1) {}

        miss[i] = @as(u8, @intCast(j)) + 'A';
    }

    try stdout.print("Missing: {s}\n", .{miss});
}
