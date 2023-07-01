const std = @import("std");
const stdout = std.io.getStdOut().outStream();
const assert = std.debug.assert;

pub fn main() !void {
    const primes = [_]u7{
        2,   3,  5,  7,  11, 13,  17,  19,  23,  29,
        31,  37, 41, 43, 47, 53,  59,  61,  67,  71,
        73,  79, 83, 89, 97, 101, 103, 107, 109, 113,
        127,
    };
    try stdout.print("These Mersenne numbers are prime: ", .{});
    for (primes) |p|
        if (isMersennePrime(p))
            try stdout.print("M{} ", .{p});
    try stdout.print("\n", .{});
}

inline fn M(n: u7) u128 {
    return (@as(u128, 1) << n) - 1;
}

fn isMersennePrime(p: u7) bool {
    if (p < 3)
        return p == 2
    else {
        const n = M(p);
        var s: u128 = 4;
        var i: u7 = p - 2;
        while (i > 0) : (i -= 1) {
            s = modmul(s, s, n);
            s = if (s >= 2) s - 2 else n - 2 + s;
        }
        return s == 0;
    }
}

fn modmul(a0: u128, b0: u128, m: u128) u128 {
    var r: u128 = 0;
    var a = a0 % m;
    var b = b0 % m;
    while (b > 0) {
        if (b & 1 == 1)
            r = if ((m - r) > a) r + a else r + a - m;
        b >>= 1;
        if (b > 0)
            a = if ((m - a) > a) a + a else a + a - m;
    }
    return r;
}
