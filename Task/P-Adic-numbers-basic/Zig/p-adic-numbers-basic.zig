const std = @import("std");
const math = std.math;
const stdout = std.io.getStdOut().writer();
const print = std.debug.print;

// Constants
const EMX: i32 = 64;      // exponent maximum (if indexing starts at -EMX)
const DMX: i32 = 100000;  // approximation loop maximum
const AMX: i32 = 1048576; // argument maximum
const PMAX: i32 = 32749;  // prime maximum

// Global variables
var P1: i32 = 0;
var P: i32 = 7;   // default prime
var K: i32 = 11;  // precision

// Helper functions
fn abs(a: i32) i32 {
    return if (a >= 0) a else -a;
}

fn min(a: i32, b: i32) i32 {
    return if (a < b) a else b;
}

const Ratio = struct {
    a: i32,
    b: i32,
};

const Padic = struct {
    v: i32,
    d: [2 * EMX]i32, // add EMX to index to be consistent

    // Create a new Padic with default values
    fn new() Padic {
        return Padic{
            .v = 0,
            .d = [_]i32{0} ** (2 * EMX),
        };
    }

    // (re)initialize receiver from Ratio, set 'sw' to print
    fn r2pa(self: *Padic, q: Ratio, sw: i32) i32 {
        var a = q.a;
        var b = q.b;
        if (b == 0) {
            return 1;
        }
        if (b < 0) {
            b = -b;
            a = -a;
        }
        if (abs(a) > AMX or b > AMX) {
            return -1;
        }

        if (P < 2 or K < 1) {
            return 1;
        }

        // Set P to minimum of P and PMAX
        P = @min(P, PMAX);

        // Set K to minimum of K and EMX-1
        K = @min(K, EMX - 1);

        if (sw != 0) {
            print("{d}/{d} + \n", .{a, b});   // numerator, denominator
            print("0({d}^{d})\n", .{P, K}); // prime, precision
        }

        // (re)initialize
        self.v = 0;
        P1 = P - 1;
        // std.mem.set(i32, &self.d, 0);

        if (a == 0) {
            return 0;
        }

        var i: i32 = 0;

        // find -exponent of p in b
        while (  @rem(b, P) == 0) {
            b = @divTrunc(b, P);
            i -= 1;
        }

        var s: i32 = 0;
        const r = @rem(b, P);

        // modular inverse for small p
        var b1: i32 = 1;
        while (b1 <= P1) {
            s += r;
            if (s > P1) {
                s -= P;
            }
            if (s == 1) {
                break;
            }
            b1 += 1;
        }

        if (b1 == P) {
            print("r2pa: impossible inverse mod\n", .{});
            return -1;
        }

        self.v = EMX;

        while (true) {
            // find exponent of P in a
            while ( @rem(a, P)==0) {
                a = @divTrunc(a, P);
                i += 1;
            }

            // valuation
            if (self.v == EMX) {
                self.v = i;
            }

            // upper bound
            if (i >= EMX) {
                break;
            }

            // check precision
            if ((i - self.v) > K) {
                break;
            }

            // next digit
            self.d[@intCast(i + EMX)] = @mod(a * b1, P);
            if (self.d[@intCast(i + EMX)] < 0) {
                self.d[@intCast(i + EMX)] += P;
            }

            // remainder - digit * divisor
            a -= self.d[@intCast(i + EMX)] * b;
            if (a == 0) {
                break;
            }
        }

        return 0;
    }

    // Horner's rule
    fn dsum(self: *const Padic) i32 {
        const t = @min(self.v, 0);
        var s: i32 = 0;

        var i = K - 1 + t;
        while (i >= t) : (i -= 1) {
            const r = s;
            s *= P;
            if (r != 0 and (@divTrunc(s, r) - P != 0)) {
                // overflow
                s = -1;
                break;
            }
            s += self.d[@intCast(i + EMX)];
        }
        return s;
    }

    // add b to receiver
    fn add(self: *const Padic, b: *const Padic) Padic {
        var c: i32 = 0;
        var r = Padic.new();
        r.v = @min(self.v, b.v);

        var i: i32 = r.v;
        while (i <= K + r.v) : (i += 1) {
            c += self.d[@intCast(i + EMX)] + b.d[@intCast(i + EMX)];
            if (c > P1) {
                r.d[@intCast(i + EMX)] = c - P;
                c = 1;
            } else {
                r.d[@intCast(i + EMX)] = c;
                c = 0;
            }
        }

        return r;
    }

    // complement of receiver
    fn cmpt(self: *const Padic) Padic {
        var c: i32 = 1;
        var r = Padic.new();
        r.v = self.v;

        var i: i32 = self.v;
        while (i <= K + self.v) : (i += 1) {
            c += P1 - self.d[@intCast(i + EMX)];
            if (c > P1) {
                r.d[@intCast(i + EMX)] = c - P;
                c = 1;
            } else {
                r.d[@intCast(i + EMX)] = c;
                c = 0;
            }
        }

        return r;
    }

    // rational reconstruction
    fn crat(self: *const Padic) void {
        var fl = false;
        var s = self.*;
        var j: i32 = 0;
        var i: i32 = 1;

        // denominator count
        while (i <= DMX) : (i += 1) {
            // check for integer
            j = K - 1 + self.v;
            while (j >= self.v) : (j -= 1) {
                if (s.d[@intCast(j + EMX)] != 0) {
                    break;
                }
            }
            fl = ((j - self.v) * 2) < K;
            if (fl) {
                fl = false;
                break;
            }

            // check negative integer
            j = K - 1 + self.v;
            while (j >= self.v) : (j -= 1) {
                if (P1 - s.d[@intCast(j + EMX)] != 0) {
                    break;
                }
            }
            fl = ((j - self.v) * 2) < K;
            if (fl) {
                break;
            }

            // repeatedly add self to s
            s = s.add(self);
        }

        if (fl) {
            s = s.cmpt();
        }

        // numerator: weighted digit sum
        const x = s.dsum();
        var y = i;

        if (x < 0 or y > DMX) {
            print("{d} {d}\n", .{x, y});
            print("crat: fail\n", .{});
        } else {
            // negative powers
            var i_pow = self.v;
            while (i_pow <= -1) : (i_pow += 1) {
                y *= P;
            }

            // negative rational
            const final_x = if (fl) -x else x;
            print("{d}", .{final_x});
            if (y > 1) {
                print("/{d}", .{y});
            }
            print("\n", .{});
        }
    }

    // print expansion
    fn printf(self: *const Padic, sw: i32) void {
        const t = @min(self.v, 0);

        var i = K - 1 + t;
        while (i >= t) : (i -= 1) {
            print("{d}", .{self.d[@intCast(i + EMX)]});
            if (i == 0 and self.v < 0) {
                print(".", .{});
            }
            print(" ", .{});
        }
        print("\n", .{});
        // rational approximation
        if (sw != 0) {
            self.crat();
        }
    }
};

pub fn main() !void {
    const data = [_][6]i32{
        // rational reconstruction depends on the precision
        // until the dsum-loop overflows
        [_]i32{ 2, 1, 2, 4, 1, 1 },
        [_]i32{ 4, 1, 2, 4, 3, 1 },
        [_]i32{ 4, 1, 2, 5, 3, 1 },
        [_]i32{ 4, 9, 5, 4, 8, 9 },
        [_]i32{ 26, 25, 5, 4, -109, 125 },
        [_]i32{ 49, 2, 7, 6, -4851, 2 },
        [_]i32{ -9, 5, 3, 8, 27, 7 },
        [_]i32{ 5, 19, 2, 12, -101, 384 },
        // two decadic pairs
        [_]i32{ 2, 7, 10, 7, -1, 7 },
        [_]i32{ 34, 21, 10, 9, -39034, 791 },
        // familiar digits
        [_]i32{ 11, 4, 2, 43, 679001, 207 },
        [_]i32{ -8, 9, 23, 9, 302113, 92 },
        [_]i32{ -22, 7, 3, 23, 46071, 379 },
        [_]i32{ -22, 7, 32749, 3, 46071, 379 },
        [_]i32{ 35, 61, 5, 20, 9400, 109 },
        [_]i32{ -101, 109, 61, 7, 583376, 6649 },
        [_]i32{ -25, 26, 7, 13, 5571, 137 },
        [_]i32{ 1, 4, 7, 11, 9263, 2837 },
        [_]i32{ 122, 407, 7, 11, -517, 1477 },
        // more subtle
        [_]i32{ 5, 8, 7, 11, 353, 30809 },
    };

    var sw: i32 = 0;
    var a = Padic.new();
    var b = Padic.new();

    for (data) |d| {
        const q = Ratio{ .a = d[0], .b = d[1] };

        P = d[2];
        K = d[3];

        sw = a.r2pa(q, 1);
        if (sw == 1) {
            break;
        }
        a.printf(0);

        const q_b = Ratio{ .a = d[4], .b = d[5] };
        sw = sw | b.r2pa(q_b, 1);
        if (sw == 1) {
            break;
        }

        if (sw == 0) {
            b.printf(0);
            const c = a.add(&b);
            print("+ =\n", .{});
            c.printf(1);
        }
        print("\n", .{});
    }
}
