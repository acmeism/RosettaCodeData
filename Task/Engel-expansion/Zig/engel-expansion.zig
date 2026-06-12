const std = @import("std");
const print = std.debug.print;
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

fn gcd(a: u64, b: u64) u64 {
    var x = a;
    var y = b;
    while (y != 0) {
        const temp = y;
        y = x % y;
        x = temp;
    }
    return x;
}

const Rational = struct {
    numerator: u64,
    denominator: u64,

    const Self = @This();

    pub fn new(numerator: u64, denominator: u64) Self {
        const gcd_val = gcd(numerator, denominator);
        return Self{
            .numerator = numerator / gcd_val,
            .denominator = denominator / gcd_val,
        };
    }

    pub fn fromInteger(value: u64) Self {
        return Self{
            .numerator = value,
            .denominator = 1,
        };
    }

    pub fn fromDecimal(decimal: []const u8) !Self {
        const dot_index = std.mem.indexOf(u8, decimal, ".") orelse return error.InvalidDecimalFormat;

        const decimal_places = decimal.len - 1 - dot_index;

        const integer_part = decimal[0..dot_index];
        const fractional_part = decimal[dot_index + 1..];

        // Combine integer and fractional parts
        var combined = ArrayList(u8).init(std.heap.page_allocator);
        defer combined.deinit();

        try combined.appendSlice(integer_part);
        try combined.appendSlice(fractional_part);

        const numerator = try std.fmt.parseInt(u64, combined.items, 10);
        const denominator = std.math.pow(u64, 10, @as(u32, @intCast(decimal_places)));

        return Self.new(numerator, denominator);
    }

    pub fn toDecimal(self: Self, allocator: Allocator, decimal_places: u32) ![]u8 {
        var result = ArrayList(u8).init(allocator);
        var numer = self.numerator;
        const denom = self.denominator;
        var quotient = numer / denom;

        var i: u32 = 0;
        while (i <= decimal_places) : (i += 1) {
            const quotient_str = try std.fmt.allocPrint(allocator, "{d}", .{quotient});
            defer allocator.free(quotient_str);
            try result.appendSlice(quotient_str);

            numer -= denom * quotient;

            if (numer == 0) break;

            numer *= 10;
            quotient = numer / denom;

            if (i == 0) {
                try result.append('.');
            }
        }

        return result.toOwnedSlice();
    }

    pub fn equals(self: Self, other: Self) bool {
        return self.numerator == other.numerator and self.denominator == other.denominator;
    }

    pub fn add(self: Self, other: Self) Self {
        const numer = (self.numerator * other.denominator) + (self.denominator * other.numerator);
        const denom = self.denominator * other.denominator;
        return Self.new(numer, denom);
    }

    pub fn subtract(self: Self, other: Self) Self {
        const numer = (self.numerator * other.denominator) - (self.denominator * other.numerator);
        const denom = self.denominator * other.denominator;
        return Self.new(numer, denom);
    }

    pub fn multiply(self: Self, other: Self) Self {
        return Self.new(
            self.numerator * other.numerator,
            self.denominator * other.denominator,
        );
    }

    pub fn inverse(self: Self) Self {
        return Self.new(self.denominator, self.numerator);
    }

    pub fn ceiling(self: Self) i64 {
        if (self.numerator % self.denominator == 0) {
            return @as(i64, @intCast(self.numerator / self.denominator));
        } else {
            return @as(i64, @intCast(self.numerator / self.denominator + 1));
        }
    }

    pub fn format(self: Self, comptime fmt: []const u8, options: std.fmt.FormatOptions, writer: anytype) !void {
        _ = fmt;
        _ = options;
        try writer.print("{d}/{d}", .{ self.numerator, self.denominator });
    }
};

const RATIONAL_ZERO = Rational{ .numerator = 0, .denominator = 1 };
const RATIONAL_ONE = Rational{ .numerator = 1, .denominator = 1 };

fn toEngel(allocator: Allocator, decimal: []const u8) ![]u64 {
    var engel = ArrayList(u64).init(allocator);
    var rational = try Rational.fromDecimal(decimal);

    while (!rational.equals(RATIONAL_ZERO)) {
        const term = rational.inverse().ceiling();
        try engel.append(@as(u64, @intCast(term)));
        rational = rational.multiply(Rational.fromInteger(@as(u64, @intCast(term)))).subtract(RATIONAL_ONE);
    }

    return engel.toOwnedSlice();
}

fn fromEngel(engel: []const u64) Rational {
    var sum = RATIONAL_ZERO;
    var product = RATIONAL_ONE;

    for (engel) |element| {
        const rational = Rational.fromInteger(element).inverse();
        product = product.multiply(rational);
        sum = sum.add(product);
    }

    return sum;
}

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    const rationals = [_][]const u8{
        "3.14159265358979",
        "2.71828182845904",
        "1.414213562373095",
    };

    for (rationals) |rational_str| {
        const engel = try toEngel(allocator, rational_str);
        defer allocator.free(engel);

        print("Rational number : {s}\n", .{rational_str});
        print("Engel expansion : ", .{});
        for (engel) |element| {
            print("{d} ", .{element});
        }
        print("\n", .{});
        print("Number of terms : {d}\n", .{engel.len});

        // Due to integer overflow,
        // Zig can only reconstruct the decimal numbers to a limited number of decimal places.

        const dot_index = std.mem.indexOf(u8, rational_str, ".") orelse 0;
        const decimal_places = rational_str.len - dot_index;

        const reduced_engel = engel[0..@min(9, engel.len)];

        const back_to_rational = fromEngel(reduced_engel);
        const decimal_result = try back_to_rational.toDecimal(allocator, @as(u32, @intCast(decimal_places / 2)));
        defer allocator.free(decimal_result);

        print("Back to rational: {s}\n", .{decimal_result});
        print("\n", .{});
    }
}
