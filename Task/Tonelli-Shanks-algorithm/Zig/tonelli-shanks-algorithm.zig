const std = @import("std");
const stdout = std.io.getStdOut().writer();

const Pair = struct {
    n: u64,
    p: u64,
};

const Solution = struct {
    root1: u64,
    root2: u64,
    is_square: bool,
};

fn multiplyModulus(a: u64, b: u64, modulus: u64) u64 {
    var a_mod = a % modulus;
    var b_mod = b % modulus;

    if (b_mod < a_mod) {
        const temp = a_mod;
        a_mod = b_mod;
        b_mod = temp;
    }

    var result: u64 = 0;
    var a_temp = a_mod;
    var b_temp = b_mod;

    while (a_temp > 0) {
        if (a_temp % 2 == 1) {
            result = (result + b_temp) % modulus;
        }
        b_temp = (b_temp << 1) % modulus;
        a_temp >>= 1;
    }
    return result;
}

fn powerModulus(base: u64, exponent: u64, modulus: u64) u64 {
    if (modulus == 1) {
        return 0;
    }

    var base_mod = base % modulus;
    var result: u64 = 1;
    var exp = exponent;

    while (exp > 0) {
        if ((exp & 1) == 1) {
            result = multiplyModulus(result, base_mod, modulus);
        }
        base_mod = multiplyModulus(base_mod, base_mod, modulus);
        exp >>= 1;
    }
    return result;
}

fn legendre(a: u64, p: u64) u64 {
    return powerModulus(a, (p - 1) / 2, p);
}

fn tonelliShanks(n: u64, p: u64) Solution {
    if (legendre(n, p) != 1) {
        return Solution{ .root1 = 0, .root2 = 0, .is_square = false };
    }

    // Factor out powers of 2 from p - 1
    var q = p - 1;
    var s: u64 = 0;
    while (q % 2 == 0) {
        q /= 2;
        s += 1;
    }

    if (s == 1) {
        const result = powerModulus(n, (p + 1) / 4, p);
        return Solution{ .root1 = result, .root2 = p - result, .is_square = true };
    }

    // Find a non-square z such as ( z | p ) = -1
    var z: u64 = 2;
    while (legendre(z, p) != p - 1) {
        z += 1;
    }

    var c = powerModulus(z, q, p);
    var t = powerModulus(n, q, p);
    var m = s;
    var result = powerModulus(n, (q + 1) >> 1, p);

    while (t != 1) {
        var i: u64 = 1;
        var z_temp = multiplyModulus(t, t, p);
        while (z_temp != 1 and i < m - 1) {
            i += 1;
            z_temp = multiplyModulus(z_temp, z_temp, p);
        }
        const b = powerModulus(c, @as(u64, 1) << @as( u6, @intCast(m - i - 1)), p);
        c = multiplyModulus(b, b, p);
        t = multiplyModulus(t, c, p);
        m = i;
        result = multiplyModulus(result, b, p);
    }

    return Solution{ .root1 = result, .root2 = p - result, .is_square = true };
}

pub fn main() !void {
    const tests = [_]Pair{
        .{ .n = 10, .p = 13 },
        .{ .n = 56, .p = 101 },
        .{ .n = 1030, .p = 1009 },
        .{ .n = 1032, .p = 1009 },
        .{ .n = 44402, .p = 100049 },
        .{ .n = 665820697, .p = 1000000009 },
        .{ .n = 881398088036, .p = 1000000000039 },
    };

    for (tests) |my_test| {
        const solution = tonelliShanks(my_test.n, my_test.p);
        try stdout.print("n = {}, p = {}", .{ my_test.n, my_test.p });
        if (solution.is_square) {
            try stdout.print(" has solutions: {} and {}\n\n", .{ solution.root1, solution.root2 });
        } else {
            try stdout.print(" has no solutions because n is not a square modulo p\n\n", .{});
        }
    }
}
