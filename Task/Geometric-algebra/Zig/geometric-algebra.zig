const std = @import("std");
const print = std.debug.print;
const Random = std.Random;

var rng: Random = undefined;

fn uniform01() f64 {
    return rng.float(f64);
}

fn bitCount(i_param: i32) i32 {
    var i = i_param;
    i -= (i >> 1) & 0x55555555;
    i = (i & 0x33333333) + ((i >> 2) & 0x33333333);
    i = (i + (i >> 4)) & 0x0F0F0F0F;
    i += i >> 8;
    i += i >> 16;
    return i & 0x0000003F;
}

fn reorderingSign(i: usize, j: usize) f64 {
    var k = i >> 1;
    var sum: i32 = 0;
    while (k != 0) {
        sum += bitCount(@as(i32, @intCast(k & j)));
        k >>= 1;
    }
    return if ((sum & 1) == 0) 1.0 else -1.0;
}

const MyVector = struct {
    dims: [32]f64,

    const Self = @This();

    fn init(dims: [32]f64) Self {
        return Self{ .dims = dims };
    }

    fn initZero() Self {
        return Self{ .dims = [_]f64{0.0} ** 32 };
    }

    fn get(self: *const Self, index: usize) f64 {
        return self.dims[index];
    }

    fn set(self: *Self, index: usize, value: f64) void {
        self.dims[index] = value;
    }

    fn dot(self: *const Self, rhs: *const Self) Self {
        const mult = self.mul(rhs);
        const mult_rhs = rhs.mul(self);
        const sum = mult.add(&mult_rhs);
        return sum.scale(0.5);
    }

    fn add(self: *const Self, rhs: *const Self) Self {
        var result = self.dims;
        for (0..32) |i| {
            result[i] += rhs.dims[i];
        }
        return Self.init(result);
    }

    fn mul(self: *const Self, rhs: *const Self) Self {
        var temp = [_]f64{0.0} ** 32;
        for (0..32) |i| {
            if (self.dims[i] != 0.0) {
                for (0..32) |j| {
                    if (rhs.dims[j] != 0.0) {
                        const s = reorderingSign(i, j) * self.dims[i] * rhs.dims[j];
                        const k = i ^ j;
                        temp[k] += s;
                    }
                }
            }
        }
        return Self.init(temp);
    }

    fn scale(self: *const Self, scalar: f64) Self {
        var result = self.dims;
        for (0..32) |i| {
            result[i] *= scalar;
        }
        return Self.init(result);
    }

    fn neg(self: *const Self) Self {
        return self.scale(-1.0);
    }

    fn format(self: Self, comptime fmt: []const u8, options: std.fmt.FormatOptions, writer: anytype) !void {
        _ = fmt;
        _ = options;
        try writer.print("[");
        for (self.dims, 0..) |val, i| {
            if (i > 0) {
                try writer.print(", ");
            }
            try writer.print("{d}", .{val});
        }
        try writer.print("]");
    }
};

fn e(n: usize) !MyVector {
    if (n > 4) {
        return error.InvalidBasisIndex;
    }

    var result = MyVector.initZero();
    result.set(@as(usize, 1) << @intCast(n), 1.0);
    return result;
}

fn randomVector() MyVector {
    var result = MyVector.initZero();
    for (0..5) |i| {
        const basis = e(i) catch unreachable;
        const scalar = uniform01();
        const scaled_basis = basis.scale(scalar);
        result = result.add(&scaled_basis);
    }
    return result;
}

fn randomMultiVector() MyVector {
    var result = MyVector.initZero();
    for (0..32) |i| {
        result.set(i, uniform01());
    }
    return result;
}

pub fn main() !void {
    // Initialize random number generator
    var prng = std.Random.DefaultPrng.init(@as(u64, @intCast(std.time.milliTimestamp())));
    rng = prng.random();

    // Test orthogonality of basis vectors
    for (0..5) |i| {
        for (0..5) |j| {
            if (i < j) {
                const ei = try e(i);
                const ej = try e(j);
                const dot_product = ei.dot(&ej);
                if (dot_product.get(0) != 0.0) {
                    print("Unexpected non-null scalar product.\n" , .{});
                    return error.TestFailed;
                }
            } else if (i == j) {
                const ei = try e(i);
                const dot_product = ei.dot(&ei);
                if (dot_product.get(0) == 0.0) {
                    print("Unexpected null scalar product.\n" , .{});
                }
            }
        }
    }

    const a = randomMultiVector();
    const b = randomMultiVector();
    const c = randomMultiVector();
    const x = randomVector();

    // (ab)c == a(bc) - Associativity test
    const ab_c = a.mul(&b).mul(&c);
    const a_bc = a.mul(&b.mul(&c));
    print("{}\n", .{ab_c});
    print("{}\n\n", .{a_bc});

    // a(b+c) == ab + ac - Left distributivity test
    const b_plus_c = b.add(&c);
    const a_bc_sum = a.mul(&b_plus_c);
    const ab_plus_ac = a.mul(&b).add(&a.mul(&c));
    print("{}\n", .{a_bc_sum});
    print("{}\n\n", .{ab_plus_ac});

    // (a+b)c == ac + bc - Right distributivity test
    const a_plus_b = a.add(&b);
    const ab_c_sum = a_plus_b.mul(&c);
    const ac_plus_bc = a.mul(&c).add(&b.mul(&c));
    print("{}\n", .{ab_c_sum});
    print("{}\n\n", .{ac_plus_bc});

    // x^2 is real (should have only scalar component)
    const x_squared = x.mul(&x);
    print("{}\n", .{x_squared});
}
