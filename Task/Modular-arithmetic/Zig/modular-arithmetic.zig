const std = @import("std");
const print = std.debug.print;

// Generic function f that works with any type T
fn f(comptime T: type, x: T) T {
    const pow_result = pow(T, x, 100);
    const temp = pow_result.add(x) catch unreachable; // Same modulus, won't error
    return temp.addInt(1);
}

// ModularInteger struct
const ModularInteger = struct {
    value: i32,
    modulus: i32,

    const Self = @This();

    // Constructor
    pub fn init(v: i32, m: i32) Self {
        return Self{
            .value = @mod(v, m),
            .modulus = m,
        };
    }

    // Getter methods
    pub fn getValue(self: Self) i32 {
        return self.value;
    }

    pub fn getModulus(self: Self) i32 {
        return self.modulus;
    }

    // Validation helper
    fn validateOp(self: Self, rhs: Self) !void {
        if (self.modulus != rhs.modulus) {
            return error.ModulusMismatch;
        }
    }

    // Addition with another ModularInteger
    pub fn add(self: Self, rhs: Self) !Self {
        try self.validateOp(rhs);
        return Self.init(self.value + rhs.value, self.modulus);
    }

    // Addition with integer
    pub fn addInt(self: Self, rhs: i32) Self {
        return Self.init(self.value + rhs, self.modulus);
    }

    // Multiplication with another ModularInteger
    pub fn mul(self: Self, rhs: Self) !Self {
        try self.validateOp(rhs);
        return Self.init(self.value * rhs.value, self.modulus);
    }

    // Format for printing
    pub fn format(
        self: Self,
        comptime fmt: []const u8,
        options: std.fmt.FormatOptions,
        writer: anytype,
    ) !void {
        _ = fmt;
        _ = options;
        try writer.print("ModularInteger({}, {})", .{ self.value, self.modulus });
    }
};

// Power function for ModularInteger
fn pow(comptime T: type, base: T, power: i32) T {
    if (power < 0) {
        @panic("Power must not be negative.");
    }

    var result = T.init(1, base.getModulus());
    var p = power;
    while (p > 0) : (p -= 1) {
        result = result.mul(base) catch unreachable; // Same modulus, won't error
    }
    return result;
}

// Operator overloading using + syntax (though Zig doesn't have true operator overloading)
// We use methods instead, but you could create wrapper functions if desired

pub fn main() !void {
    const input = ModularInteger.init(10, 13);
    const output = f(ModularInteger, input);

    print("f({}) = {}\n", .{ input, output });
}
