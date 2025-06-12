const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

const PAdicSquareRoot = struct {
    prime: u32,
    precision: u32,
    digits: ArrayList(u32),
    order: i32,
    allocator: Allocator,

    // Create a PAdicSquareRoot number
    pub fn new(allocator: Allocator, prime: u32, precision: u32, numerator: i32, denominator: i32) !*PAdicSquareRoot {
        if (denominator == 0) {
            return error.DenominatorCannotBeZero;
        }

        const digits_size = precision + 5;
        var self = try allocator.create(PAdicSquareRoot);
        self.* = PAdicSquareRoot{
            .prime = prime,
            .precision = precision,
            .digits = ArrayList(u32).init(allocator),
            .order = 0,
            .allocator = allocator,
        };

        // Process rational zero
        if (numerator == 0) {
            self.order = 1000; // ORDER_MAX from original code
            return self;
        }

        // Handle numerator and denominator
        var num = numerator;
        var denom = denominator;

        // Remove multiples of 'prime' and adjust the order accordingly
        while (modulo(@as(i64, num), @as(i64, prime)) == 0) {
            num = @divTrunc(num, @as(i32, @intCast(prime)));
            self.order += 1;
        }

        while (modulo(@as(i64, denom), @as(i64, prime)) == 0) {
            denom = @divTrunc(denom, @as(i32, @intCast(prime)));
            self.order -= 1;
        }

        if ((self.order & 1) != 0) {
            self.deinit();
            allocator.destroy(self);
            return error.NoSquareRoot;
        }
        self.order >>= 1;

        // Calculate square root based on prime
        if (prime == 2) {
            try self.squareRootEvenPrime(num, denom);
        } else {
            try self.squareRootOddPrime(num, denom);
        }

        // Ensure we have the right number of digits
        while (self.digits.items.len < digits_size) {
            try self.digits.append(0);
        }
        self.digits.shrinkRetainingCapacity(digits_size);

        return self;
    }

    // Create a PAdicSquareRoot directly from a vector of digits
    pub fn fromDigits(allocator: Allocator, prime: u32, precision: u32, digits: []const u32, order: i32) !*PAdicSquareRoot {
        var self = try allocator.create(PAdicSquareRoot);
        self.* = PAdicSquareRoot{
            .prime = prime,
            .precision = precision,
            .digits = ArrayList(u32).init(allocator),
            .order = order,
            .allocator = allocator,
        };

        try self.digits.appendSlice(digits);
        return self;
    }

    // Clean up allocated memory
    pub fn deinit(self: *PAdicSquareRoot) void {
        self.digits.deinit();
    }

    // Return the additive inverse of this PAdicSquareRoot number
    pub fn negate(self: *const PAdicSquareRoot) !*PAdicSquareRoot {
        if (self.digits.items.len == 0) {
            return self.clone();
        }

        var negated = try ArrayList(u32).initCapacity(self.allocator, self.digits.items.len);
        try negated.appendSlice(self.digits.items);
        negateDigits(negated.items, self.prime);

        return fromDigits(self.allocator, self.prime, self.precision, negated.items, self.order);
    }

    // Return a clone of this PAdicSquareRoot
    pub fn clone(self: *const PAdicSquareRoot) !*PAdicSquareRoot {
        var new_digits = try ArrayList(u32).initCapacity(self.allocator, self.digits.items.len);
        try new_digits.appendSlice(self.digits.items);

        const result = try self.allocator.create(PAdicSquareRoot);
        result.* = PAdicSquareRoot{
            .prime = self.prime,
            .precision = self.precision,
            .digits = new_digits,
            .order = self.order,
            .allocator = self.allocator,
        };
        return result;
    }

    // Return the product of this PAdicSquareRoot number and another PAdicSquareRoot number
    pub fn multiply(self: *const PAdicSquareRoot, other: *const PAdicSquareRoot) !*PAdicSquareRoot {
        if (self.prime != other.prime) {
            return error.DifferentPrimes;
        }

        if (self.digits.items.len == 0 or other.digits.items.len == 0) {
            return new(self.allocator, self.prime, self.precision, 0, 1);
        }

        const max_size = @as(usize, @intCast(self.precision + 5));
        const product_digits = try multiplyDigits(
            self.allocator,
            self.digits.items,
            other.digits.items,
            self.prime,
            max_size
        );

        return fromDigits(
            self.allocator,
            self.prime,
            self.precision,
            product_digits.items,
            self.order + other.order,
        );
    }

    // Return a string representation of this PAdicSquareRoot as a rational number
    pub fn convertToRational(self: *const PAdicSquareRoot, allocator: Allocator) ![]u8 {
        if (self.digits.items.len == 0) {
            return try std.fmt.allocPrint(allocator, "0 / 1", .{});
        }

        // Lagrange lattice basis reduction in two dimensions
        var series_sum: i64 = @as(i64, self.digits.items[0]);
        var maximum_prime: i64 = 1;

        var i: u32 = 1;
        while (i < self.precision) : (i += 1) {
            maximum_prime *= @as(i64, self.prime);
            series_sum += @as(i64, self.digits.items[i]) * maximum_prime;
        }

        var one = [_]i64{ maximum_prime, series_sum };
        var two = [_]i64{ 0, 1 };

        var previous_norm = series_sum * series_sum + 1;
        var current_norm = previous_norm + 1;
        var idx_i: usize = 0;
        var idx_j: usize = 1;

        while (previous_norm < current_norm) {
            const numerator = one[idx_i] * one[idx_j] + two[idx_i] * two[idx_j];
            const denominator = previous_norm;
            current_norm = @as(i64, @intFromFloat(@floor(@as(f64, @floatFromInt(numerator)) / @as(f64, @floatFromInt(denominator)) + 0.5)));
            one[idx_i] -= current_norm * one[idx_j];
            two[idx_i] -= current_norm * two[idx_j];

            current_norm = previous_norm;
            previous_norm = one[idx_i] * one[idx_i] + two[idx_i] * two[idx_i];

            if (previous_norm < current_norm) {
                const temp = idx_i;
                idx_i = idx_j;
                idx_j = temp;
            }
        }

        var x = one[idx_j];
        var y = two[idx_j];
        if (y < 0) {
            y = -y;
            x = -x;
        }

        if ( @abs(one[idx_i] * y - x * two[idx_i]) != maximum_prime) {
            return error.RationalReconstructionFailed;
        }

        var i_order = self.order;
        while (i_order < 0) : (i_order += 1) {
            y *= @as(i64, self.prime);
        }

        i_order = 0;
        while (i_order < self.order) : (i_order += 1) {
            x *= @as(i64, self.prime);
        }

        return try std.fmt.allocPrint(allocator, "{} / {}", .{ x, y });
    }

    // Create a 2-adic number which is the square root of the rational 'numerator' / 'denominator'
    fn squareRootEvenPrime(self: *PAdicSquareRoot, numerator: i32, denominator: i32) !void {
        if (modulo(@as(i64, numerator) * @as(i64, denominator), 8) != 1) {
            return error.NoSquareRootInTwoAdic;
        }

        // First digit
        var sum: i64 = 1;
        try self.digits.append(1);

        // Further digits
        const digits_size = self.precision + 5;
        while (self.digits.items.len < digits_size) {
            const factor = @as(i64, denominator) * sum * sum - @as(i64, numerator);
            var valuation: u32 = 0;
            var factor_temp = factor;
            while (modulo(factor_temp, 2) == 0) {
                factor_temp = @divTrunc(factor_temp, 2);
                valuation += 1;
            }

            sum += std.math.pow(i64, 2, valuation - 1);

            while (self.digits.items.len < valuation - 1) {
                try self.digits.append(0);
            }
            try self.digits.append(1);
        }
    }

    // Create a p-adic number, with an odd prime number, p = 'prime',
    // which is the p-adic square root of the given rational 'numerator' / 'denominator'
    fn squareRootOddPrime(self: *PAdicSquareRoot, numerator: i32, denominator: i32) !void {
        // First digit
        var first_digit: u32 = 0;
        var i: u32 = 1;
        while (i < self.prime) : (i += 1) {
            if (modulo(
                @as(i64, denominator) * @as(i64, i) * @as(i64, i) - @as(i64, numerator),
                @as(i64, self.prime)
            ) == 0) {
                first_digit = i;
                break;
            }
        }

        if (first_digit == 0) {
            return error.NoSquareRoot;
        }

        try self.digits.append(first_digit);

        // Further digits
        const coefficient = moduloInverse(
            @intCast(modulo(2 * @as(i64, denominator) * @as(i64, first_digit), @as(i64, self.prime))),
            self.prime
        );

        var sum: i64 = @as(i64, first_digit);
        const digits_size = self.precision + 5;

        var i_digit: u32 = 2;
        while (i_digit < digits_size) : (i_digit += 1) {
            // FIXED: Break down calculation into smaller operations to avoid overflow
            const denom_sum = @as(i128, @as(i128, denominator)) * @as(i128, sum);
            const denom_sum_squared = denom_sum * @as(i128, sum);
            const subtraction = denom_sum_squared - @as(i128, numerator);
            const coef_mul = @as(i128, coefficient) * subtraction;

            var next_sum = @as(i128, sum) - coef_mul;

            // Use modulo with appropriate type
            const pow_prime = std.math.pow(i128, @as(i128, self.prime), @as(i128, i_digit));
            next_sum = @intCast(modulo128(next_sum, pow_prime));
            next_sum -= @as(i128, sum);
            sum = @intCast(next_sum + @as(i128, sum));

            // Calculate power for digit extraction
            const pow_prime_prev = std.math.pow(i128, @as(i128, self.prime), @as(i128, i_digit - 1));
            const digit = @as(u32, @intCast(@divTrunc(next_sum, pow_prime_prev)));
            try self.digits.append(digit);
        }
    }

    // Generate string representation of this PAdicSquareRoot
    pub fn toString(self: *const PAdicSquareRoot, allocator: Allocator) ![]u8 {
        var numbers = try ArrayList(u32).initCapacity(allocator, self.digits.items.len);
        try numbers.appendSlice(self.digits.items);

        // Ensure we have the right number of digits
        while (numbers.items.len < self.precision + 5) {
            try numbers.append(0);
        }

        var result = ArrayList(u8).init(allocator);
        errdefer result.deinit();

        var i: isize = @as(isize, @intCast(numbers.items.len)) - 1;
        while (i >= 0) : (i -= 1) {
            const digit_str = try std.fmt.allocPrint(allocator, "{}", .{numbers.items[@intCast(i)]});
            defer allocator.free(digit_str);
            try result.appendSlice(digit_str);
        }

        if (self.order >= 0) {
            var j: i32 = 0;
            while (j < self.order) : (j += 1) {
                try result.append('0');
            }
            try result.appendSlice(".0");
        } else {
            const insert_pos = @as(i32, @intCast(result.items.len)) + self.order;
            if (insert_pos >= 0) {
                try result.insertSlice(@intCast(insert_pos), ".");
            } else {
                // If we need to insert before the start, pad with zeros
                const zeros_needed = -insert_pos;
                var new_result = try ArrayList(u8).initCapacity(allocator, result.items.len + @as(usize, @intCast(zeros_needed) ) + 2);
                try new_result.appendSlice("0.");
                var j: i32 = 0;
                while (j < zeros_needed) : (j += 1) {
                    try new_result.append('0');
                }
                try new_result.appendSlice(result.items);
                result.deinit();
                result = new_result;
            }

            // Remove trailing zeros
            while (result.items.len > 0 and result.items[result.items.len - 1] == '0') {
                _ = result.pop();
            }
        }

        // Return with ellipsis at the beginning
        const start_pos = if (result.items.len > self.precision + 1)
            result.items.len - self.precision - 1
        else
            0;

        const final_result = try std.fmt.allocPrint(allocator, " ...{s}", .{result.items[start_pos..]});
        result.deinit();
        return final_result;
    }
};

// Transform the given vector of digits representing a p-adic number
// into a vector which represents the negation of the p-adic number
fn negateDigits(numbers: []u32, prime: u32) void {
    if (numbers.len == 0) return;

    numbers[0] = @intCast(modulo(@as(i64, prime) - @as(i64, numbers[0]), @as(i64, prime)));
    var i: usize = 1;
    while (i < numbers.len) : (i += 1) {
        numbers[i] = prime - 1 - numbers[i];
    }
}

// Return the list obtained by multiplying the digits of the given two lists
fn multiplyDigits(
    allocator: Allocator,
    one: []const u32,
    two: []const u32,
    prime: u32,
    max_size: usize
) !ArrayList(u32) {
    var product = try ArrayList(u32).initCapacity(allocator, one.len + two.len);
    var i: usize = 0;
    while (i < one.len + two.len) : (i += 1) {
        try product.append(0);
    }

    var b: usize = 0;
    while (b < two.len) : (b += 1) {
        var carry: u32 = 0;
        var a: usize = 0;
        while (a < one.len) : (a += 1) {
            product.items[a + b] += one[a] * two[b] + carry;
            carry = product.items[a + b] / prime;
            product.items[a + b] %= prime;
        }
        if (b + one.len < product.items.len) {
            product.items[b + one.len] = carry;
        }
    }

    // Truncate to max_size
    if (product.items.len > max_size) {
        product.shrinkRetainingCapacity(max_size);
    }

    return product;
}

// Return the multiplicative inverse of the given number modulo 'prime'
fn moduloInverse(number: u32, prime: u32) u32 {
    var inverse: u32 = 1;
    while (modulo(@as(i64, inverse) * @as(i64, number), @as(i64, prime)) != 1) {
        inverse += 1;
    }
    return inverse;
}

// Return the given number modulo 'prime' in the range 0..'prime' - 1
fn modulo(number: i64, modulus: i64) i64 {
    const div = @mod(number, modulus);
    return if (div >= 0) div else div + modulus;
}

// Added for i128 support
fn modulo128(number: i128, modulus: i128) i128 {
    const div = @mod(number, modulus);
    return if (div >= 0) div else div + modulus;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const tests = [_][4]i32{
        [_]i32{ 2, 20, 497, 10496 },
        [_]i32{ 5, 14, 86, 25 },
        [_]i32{ 7, 10, -19, 1 },
    };

    for (tests) |my_test| {
        const stdout = std.io.getStdOut().writer();
        try stdout.print("Number: {} / {} in {}-adic\n", .{ my_test[2], my_test[3], my_test[0] });

        var square_root = PAdicSquareRoot.new(
            allocator,
            @intCast(my_test[0]),
            @intCast(my_test[1]),
            my_test[2],
            my_test[3]
        ) catch |err| {
            try stdout.print("Error: {}\n\n", .{err});
            continue;
        };
        defer {
            square_root.deinit();
            allocator.destroy(square_root);
        }

        try stdout.print("The two square roots are:\n", .{});

        const sr_string = try square_root.toString(allocator);
        defer allocator.free(sr_string);
        try stdout.print("    {s}\n", .{sr_string});

        var negated = try square_root.negate();
        defer {
            negated.deinit();
            allocator.destroy(negated);
        }

        const neg_string = try negated.toString(allocator);
        defer allocator.free(neg_string);
        try stdout.print("    {s}\n", .{neg_string});

        var square = square_root.multiply(square_root) catch |err| {
            try stdout.print("Error calculating square: {}\n\n", .{err});
            continue;
        };
        defer {
            square.deinit();
            allocator.destroy(square);
        }

        const square_string = try square.toString(allocator);
        defer allocator.free(square_string);
        try stdout.print("The p-adic value is {s}\n", .{square_string});

        const rational = square.convertToRational(allocator) catch |err| {
            try stdout.print("Error converting to rational: {}\n\n", .{err});
            continue;
        };
        defer allocator.free(rational);
        try stdout.print("The rational value is {s}\n\n", .{rational});
    }
}
