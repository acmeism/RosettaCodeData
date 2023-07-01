const std = @import("std");

pub fn binomial(n: u32) ?[]const u64 {
    if (n >= rmax)
        return null
    else {
        const k = n * (n + 1) / 2;
        return pascal[k .. k + n + 1];
    }
}

pub fn nCk(n: u32, k: u32) ?u64 {
    if (n >= rmax)
        return null
    else if (k > n)
        return 0
    else {
        const j = n * (n + 1) / 2;
        return pascal[j + k];
    }
}

const rmax = 68;

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

test "n choose k" {
    const expect = std.testing.expect;
    try expect(nCk(10, 5).? == 252);
    try expect(nCk(10, 11).? == 0);
    try expect(nCk(10, 10).? == 1);
    try expect(nCk(67, 33).? == 14226520737620288370);
    try expect(nCk(68, 34) == null);
}
