const std = @import("std");
const print = std.debug.print;
const Random = std.Random;

// --- Constants ---
const MAX_MODULUS: i64 = 1_073_741_789;
const MAX_ORDER_G: i64 = MAX_MODULUS + 65536;

// --- Structures ---
const Point = struct {
    x: i64,
    y: i64,

    // Represents the point at infinity (identity element)
    const ZERO = Point{ .x = std.math.maxInt(i64), .y = 0 };

    const Self = @This();

    fn new(x: i64, y: i64) Self {
        return Point{ .x = x, .y = y };
    }

    fn isZero(self: Self) bool {
        return self.x == ZERO.x and self.y == ZERO.y;
    }
};

const Pair = struct {
    // Often represents (c, d) in ECDSA signature
    c: i64, // Renamed 'a' to 'c' for clarity in ECDSA context
    d: i64, // Renamed 'b' to 'd' for clarity in ECDSA context

    const Self = @This();

    fn new(c: i64, d: i64) Self {
        return Pair{ .c = c, .d = d };
    }
};

const Parameter = struct {
    a: i64,
    b: i64,
    n: i64, // Modulus
    g: Point, // Base point
    r: i64, // Order of G

    const Self = @This();

    fn new(a: i64, b: i64, n: i64, g: Point, r: i64) Self {
        return Parameter{ .a = a, .b = b, .n = n, .g = g, .r = r };
    }
};

// --- Helper Functions ---

// Consistent floor modulus (handles negative numbers)
fn floorMod(num: i64, modulus: i64) i64 {
    if (modulus <= 0) {
        @panic("Modulus must be positive for floor_mod in this context.");
    }
    const rem = @mod(num, modulus);
    if (rem < 0) {
        return rem + modulus;
    } else {
        return rem;
    }
}

// Extended Euclidean Algorithm to find modular multiplicative inverse.
// Returns `x` such that `(a * x) % m == 1`.
// Returns error if gcd(a, m) != 1 (no inverse exists).
fn extendedGcd(a: i64, m: i64) !i64 {
    if (m <= 0) {
        return error.InvalidModulus;
    }
    var v = floorMod(a, m); // Ensure v is in [0, m-1]
    var u = m;
    var result: i64 = 0;
    var s: i64 = 1;

    while (v != 0) {
        const quotient = @divTrunc(u, v);
        u = @mod(u, v);

        // Swap u and v
        const temp = u;
        u = v;
        v = temp;

        // Update Bezout coefficients
        const next_result = result -% (quotient *% s);
        result = s;
        s = next_result;
    }

    if (u != 1) {
        print("Cannot inverse modulo N={}, gcd({}, {}) = {}\n", .{ m, a, m, u });
        return error.NoInverse;
    } else {
        // Ensure the result is positive
        return floorMod(result, m);
    }
}

// --- Elliptic Curve Logic ---
const EllipticCurve = struct {
    a: i64,
    b: i64,
    n: i64, // Modulus
    r: i64, // Order of G
    g: Point, // Base point

    const Self = @This();

    // Constructor with validation
    fn new(param: Parameter) !Self {
        if (param.n < 5 or param.n > MAX_MODULUS) {
            print("Invalid value for modulus: {}\n", .{param.n});
            return error.InvalidModulus;
        }
        if (param.r < 5 or param.r > MAX_ORDER_G) {
            print("Invalid value for the order of g: {}\n", .{param.r});
            return error.InvalidOrder;
        }

        const a = floorMod(param.a, param.n);
        const b = floorMod(param.b, param.n);

        const curve = EllipticCurve{
            .a = a,
            .b = b,
            .n = param.n,
            .r = param.r,
            .g = param.g,
        };

        print("\nElliptic curve: y^2 = x^3 + {}x + {} (mod {})\n", .{ a, b, param.n });
        curve.printPointWithPrefix(curve.g, "base point G");
        print("order(G, E) = {}\n", .{curve.r});

        // Basic check: Base point must be on the curve
        if (!param.g.isZero() and !curve.contains(param.g)) {
            print("Base point G ({}, {}) is not on the curve\n", .{ param.g.x, param.g.y });
            return error.InvalidBasePoint;
        }

        // Basic check: Order * G should be Zero
        const order_check = curve.multiply(curve.g, curve.r) catch |err| {
            print("Failed order check multiplication: {}\n", .{err});
            return error.OrderCheckFailed;
        };

        if (!order_check.isZero()) {
            print("Order r={} is invalid for G: r*G is not Zero\n", .{curve.r});
            return error.InvalidOrder;
        }

        // Basic check: Discriminant non-zero (for non-singular curve)
        const disc = curve.discriminant() catch |err| {
            print("Failed to compute discriminant: {}\n", .{err});
            return error.DiscriminantError;
        };

        if (disc == 0) {
            print("Curve discriminant is zero (singular curve)\n", .{});
            return error.SingularCurve;
        }

        return curve;
    }

    // Point addition (P + Q)
    fn add(self: Self, p: Point, q: Point) !Point {
        if (p.isZero()) {
            return q;
        }
        if (q.isZero()) {
            return p;
        }

        var lambda: i64 = undefined;
        if (p.x != q.x) {
            // P != Q
            const dy = p.y -% q.y;
            const dx = p.x -% q.x;
            const dx_inv = try extendedGcd(dx, self.n);
            lambda = floorMod(dy *% dx_inv, self.n);
        } else if (p.y == q.y and p.y != 0) {
            // P == Q (Point doubling)
            // lambda = (3*x^2 + a) / (2*y) mod n
            const x_sq = floorMod(p.x *% p.x, self.n);
            const numerator = floorMod(x_sq *% 3 +% self.a, self.n);
            const denominator = floorMod(p.y *% 2, self.n);
            const denominator_inv = try extendedGcd(denominator, self.n);
            lambda = floorMod(numerator *% denominator_inv, self.n);
        } else {
            // P == -Q (p.x == q.x but p.y == -q.y mod n) or P == Q == (x, 0)
            return Point.ZERO;
        }

        // x_r = lambda^2 - x_p - x_q mod n
        const lambda_sq = floorMod(lambda *% lambda, self.n);
        const x_r = floorMod(lambda_sq -% p.x -% q.x, self.n);

        // y_r = lambda * (x_p - x_r) - y_p mod n
        const x_p_sub_x_r = p.x -% x_r;
        const term1 = floorMod(lambda *% x_p_sub_x_r, self.n);
        const y_r = floorMod(term1 -% p.y, self.n);

        return Point.new(x_r, y_r);
    }

    // Scalar multiplication (k * P) using double-and-add
    fn multiply(self: Self, point: Point, k: i64) !Point {
        var result = Point.ZERO;
        var current_point = point;
        var scalar = k;

        if (scalar < 0) {
            print("Negative scalar multiplication not directly supported\n", .{});
            return error.NegativeScalar;
        }
        if (scalar == 0) {
            return Point.ZERO;
        }

        while (scalar > 0) {
            if ((scalar & 1) == 1) {
                result = try self.add(result, current_point);
            }
            current_point = try self.add(current_point, current_point); // Double the point
            scalar >>= 1; // Halve the scalar
        }
        return result;
    }

    // Check if a point lies on the curve y^2 = x^3 + ax + b (mod n)
    fn contains(self: Self, point: Point) bool {
        if (point.isZero()) {
            return true; // Point at infinity is always on the curve
        }

        // y^2 mod n
        const lhs = floorMod(point.y *% point.y, self.n);

        // x^3 + ax + b mod n
        const x_sq = floorMod(point.x *% point.x, self.n);
        const x_cubed = floorMod(x_sq *% point.x, self.n);
        const ax = floorMod(self.a *% point.x, self.n);
        const rhs = floorMod(x_cubed +% ax +% self.b, self.n);

        return lhs == rhs;
    }

    // Calculate discriminant: -16 * (4a^3 + 27b^2) mod n
    fn discriminant(self: Self) !i64 {
        const a_sq = floorMod(self.a *% self.a, self.n);
        const a_cubed = floorMod(a_sq *% self.a, self.n);
        const term1 = floorMod(a_cubed *% 4, self.n); // 4a^3

        const b_sq = floorMod(self.b *% self.b, self.n);
        const term2 = floorMod(b_sq *% 27, self.n); // 27b^2

        const inner_sum = floorMod(term1 +% term2, self.n); // 4a^3 + 27b^2
        const result = floorMod(inner_sum *% (-16), self.n);

        return result;
    }

    // Helper to print points
    fn printPointWithPrefix(self: Self, point: Point, prefix: []const u8) void {
        if (point.isZero()) {
            print("{s} (0 - Point at Infinity)\n", .{prefix});
        } else {
            // Optionally represent y with the smaller absolute value coordinate
            var y_repr = point.y;
            if (y_repr > @divTrunc(self.n, 2)) { // Simplified check assuming n > 0
                y_repr = y_repr -% self.n;
            }
            print("{s} ({}, {})\n", .{ prefix, point.x, y_repr });
        }
    }
};

// --- ECDSA Functions ---

// Generate a random integer 1 <= x < limit
fn randomI64InRange(rng: Random, limit: i64) i64 {
    if (limit <= 1) {
        @panic("Range limit must be greater than 1 for random generation");
    }
    return @as(i64, @intCast(rng.intRangeAtMost(u63, 1, @as(u63, @intCast(limit - 1)))));
}

// Create ECDSA signature (c, d) for message hash f
// s: private key
fn signature(curve: *const EllipticCurve, s: i64, f: i64, rng: Random) !Pair {
    if (curve.r <= 1) {
        print("Curve order 'r' must be greater than 1 for signing.\n", .{});
        return error.InvalidOrder;
    }

    while (true) {
        // 1. Generate random nonce 'u' (called 'k' in many texts) in [1, r-1]
        const u = randomI64InRange(rng, curve.r);

        // 2. Calculate curve point V = u * G
        const v = curve.multiply(curve.g, u) catch continue;
        if (v.isZero()) continue; // Should technically not happen if u in [1, r-1]

        // 3. Calculate c = V.x mod r
        const c = floorMod(v.x, curve.r);
        if (c == 0) continue; // Retry if c is 0

        // 4. Calculate d = u^-1 * (f + s*c) mod r
        const u_inv = extendedGcd(u, curve.r) catch continue; // u^-1 mod r
        const s_times_c = floorMod(s *% c, curve.r);
        const hash_plus_sc = floorMod(f +% s_times_c, curve.r);
        const d = floorMod(u_inv *% hash_plus_sc, curve.r);

        if (d == 0) continue; // Retry if d is 0

        print("one-time u = {}\n", .{u});
        curve.printPointWithPrefix(v, "V = uG");
        return Pair.new(c, d);
    }
}

// Verify ECDSA signature
// point W: public key (W = s*G)
// f: message hash (same as used for signing)
// signature (c, d): the signature to verify
fn verify(curve: *const EllipticCurve, public_key_w: Point, f: i64, sig: Pair) !bool {
    const c = sig.c;
    const d = sig.d;

    // 1. Check if c and d are in the valid range [1, r-1]
    if (c < 1 or c >= curve.r or d < 1 or d >= curve.r) {
        print("Verification fail: c or d out of range [1, r-1]\n", .{});
        return false;
    }

    print("\nSignature verification\n", .{});

    // 2. Calculate h = d^-1 mod r
    const h = try extendedGcd(d, curve.r);

    // 3. Calculate h1 = f * h mod r
    // 4. Calculate h2 = c * h mod r
    const h1 = floorMod(f *% h, curve.r);
    const h2 = floorMod(c *% h, curve.r);
    print("h = d^-1 = {}\n", .{h});
    print("h1 = f*h = {}\n", .{h1});
    print("h2 = c*h = {}\n", .{h2});

    // 5. Calculate point V' = h1*G + h2*W
    const v1 = try curve.multiply(curve.g, h1);
    const v2 = try curve.multiply(public_key_w, h2);
    curve.printPointWithPrefix(v1, "h1*G");
    curve.printPointWithPrefix(v2, "h2*W");

    const v_prime = try curve.add(v1, v2);
    curve.printPointWithPrefix(v_prime, "+ = V'");

    // 6. Check if V' is the point at infinity
    if (v_prime.isZero()) {
        print("Verification fail: V' is point at infinity\n", .{});
        return false;
    }

    // 7. Calculate c' = V'.x mod r
    const c_prime = floorMod(v_prime.x, curve.r);
    print("c' = V'.x mod r = {}\n", .{c_prime});

    // 8. Signature is valid if c' == c
    return c_prime == c;
}

// Main ECDSA process: keygen, sign, verify
fn ecdsa(curve: *const EllipticCurve, f_original: i64, d_error: i32, rng: Random) !void {
    print("\nKey generation\n", .{});
    // 1. Generate private key 's' in [1, r-1]
    const s = randomI64InRange(rng, curve.r);
    // 2. Calculate public key W = s * G
    const public_key_w = try curve.multiply(curve.g, s);
    print("private key s = {}\n", .{s});
    curve.printPointWithPrefix(public_key_w, "public key W = sG");

    // Align hash f to be within the bit range related to r
    var f = f_original;
    // Find the next highest power of two minus one for r (rough bit mask)
    var t = curve.r;
    if (t > 0) { // Avoid infinite loop if r is 0 or negative (shouldn't happen)
        // Efficient way to get next power of 2 minus 1 (all lower bits set)
        t |= t >> 1;
        t |= t >> 2;
        t |= t >> 4;
        t |= t >> 8;
        t |= t >> 16;
        t |= t >> 32; // For i64

        // Reduce f if it's larger than the bit mask t
        while (f > 0 and t > 0 and f > t) {
            print("Warning: Hash {} > bitmask {}. Right-shifting hash (non-standard).\n", .{ f, t });
            f >>= 1;
        }
    } else {
        print("Warning: Curve order r ({}) is not positive. Hash alignment skipped.\n", .{curve.r});
        t = std.math.maxInt(i64); // Allow any hash if r is invalid
    }

    print("\nAligned hash f = 0x{x:0>8} ({})\n", .{ f, f });

    // Sign the hash
    const signature_pair = try signature(curve, s, f, rng);
    print("Signature (c, d) = ({}, {})\n", .{ signature_pair.c, signature_pair.d });

    // Simulate data corruption if d_error > 0
    var f_verify = f;
    if (d_error > 0) {
        var error_val = @as(i64, @intCast(d_error));
        // Align the error like the hash was aligned (mimicking C++ again)
        while (error_val > 0 and t > 0 and error_val > t) {
            error_val >>= 1;
        }
        f_verify ^= error_val; // Apply error using XOR
        print("\nCorrupted hash f' = 0x{x:0>8} ({}) (error=0x{x})\n", .{ f_verify, f_verify, d_error });
    }

    // Verify the signature
    const is_valid = try verify(curve, public_key_w, f_verify, signature_pair);
    print("{s}\n", .{if (is_valid) "Valid" else "Invalid"});
    print("-----------------\n", .{});
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    var prng = std.Random.DefaultPrng.init(blk: {
        var seed: u64 = undefined;
        std.posix.getrandom(std.mem.asBytes(&seed)) catch unreachable;
        break :blk seed;
    });
    const rng = prng.random();

    // Test parameters for elliptic curve digital signature algorithm,
    // using the short Weierstrass model: y^2 = x^3 + ax + b (mod N).
    // Parameter: a, b, modulus N, base point G(x, y), order of G.
    const parameters = [_]Parameter{
        Parameter.new(355, 671, 1_073_741_789, Point.new(13693, 10088), 1_073_807_281),
        Parameter.new(0, 7, 67_096_021, Point.new(6580, 779), 16_769_911),
        Parameter.new(-3, 1, 877_073, Point.new(0, 1), 878_159), // SECp256k1 shape (a=0, b=7) is common, this is a=-3
        Parameter.new(0, 14, 22_651, Point.new(63, 30), 151),
        Parameter.new(3, 2, 5, Point.new(2, 1), 5), // Very small curve example
    };

    // The message hash (often SHA-256 output truncated/converted to integer)
    const f_hash: i64 = 0x789abcde;
    // Set d_error > 0 to simulate corrupted data before verification
    const d_error: i32 = 0; // 0 means no error

    for (parameters) |param| {
        const curve = EllipticCurve.new(param) catch |err| {
            print("Failed to create curve with parameters a={}, b={}, n={}, g=({}, {}), r={}: {}\n", .{ param.a, param.b, param.n, param.g.x, param.g.y, param.r, err });
            print("-----------------\n", .{});
            continue;
        };

        ecdsa(&curve, f_hash, d_error, rng) catch |err| {
            print("ECDSA Error for curve a={}, b={}, n={}, r={}: {}\n", .{ param.a, param.b, param.n, param.r, err });
            print("-----------------\n", .{});
        };
    }
}
