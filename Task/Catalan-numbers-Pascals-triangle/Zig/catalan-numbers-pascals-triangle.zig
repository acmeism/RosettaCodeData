const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    var n: u32 = 1;
    while (n <= 15) : (n += 1) {
        const row = binomial(n * 2).?;
        try stdout.print("{d:2}  {d:8}\n", .{ n, row[n] - row[n + 1] });
    }
}

pub fn binomial(n: u32) ?[]const u64 {
    if (n >= rmax)
        return null
    else {
        const k = n * (n + 1) / 2;
        return pascal[k .. k + n + 1];
    }
}

const rmax = 68;

// evaluated and created at compile-time
const pascal = build: {
    @setEvalBranchQuota(100_000);
    var coefficients: [(rmax * (rmax + 1)) / 2]u64 = undefined;
    coefficients[0] = 1;
    var j: u32 = 0;
    var k: u32 = 1;
    var n: u32 = 1;
    while (n < rmax) : (n += 1) {
        var prev = coefficients[j .. j + n];
        var next = coefficients[k .. k + n + 1];
        next[0] = 1;
        var i: u32 = 1;
        while (i < n) : (i += 1)
            next[i] = prev[i] + prev[i - 1];
        next[i] = 1;
        j = k;
        k += n + 1;
    }
    break :build coefficients;
};
