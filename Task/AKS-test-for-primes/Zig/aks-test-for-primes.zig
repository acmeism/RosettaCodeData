const std = @import("std");
const assert = std.debug.assert;
const stdout = std.io.getStdOut().writer();

pub fn main() !void {
    var i: u6 = 0;
    while (i < 8) : (i += 1)
        try showBinomial(i);

    try stdout.print("\nThe primes upto 50 (via AKS) are: ", .{});
    i = 2;
    while (i <= 50) : (i += 1) if (aksPrime(i))
        try stdout.print("{} ", .{i});
    try stdout.print("\n", .{});
}

fn showBinomial(n: u6) !void {
    const row = binomial(n).?;
    var sign: u8 = '+';
    var exp = row.len;
    try stdout.print("(x - 1)^{} =", .{n});
    for (row) |coef| {
        try stdout.print(" ", .{});
        if (exp != row.len)
            try stdout.print("{c} ", .{sign});
        exp -= 1;
        if (coef != 1 or exp == 0)
            try stdout.print("{}", .{coef});
        if (exp >= 1) {
            try stdout.print("x", .{});
            if (exp > 1)
                try stdout.print("^{}", .{exp});
        }
        sign = if (sign == '+') '-' else '+';
    }
    try stdout.print("\n", .{});
}

fn aksPrime(n: u6) bool {
    return for (binomial(n).?) |coef| {
        if (coef > 1 and coef % n != 0)
            break false;
    } else true;
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
