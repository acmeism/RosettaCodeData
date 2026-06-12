const std = @import("std");
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

const BerlekampMassey = struct {
    source: []const i32,
    modulus: i32,
    allocator: Allocator,

    const Self = @This();

    pub fn init(allocator: Allocator, source: []const i32, modulus: i32) Self {
        return Self{
            .source = source,
            .modulus = modulus,
            .allocator = allocator,
        };
    }

    pub fn computeCoefficients(self: *const Self) !ArrayList(i32) {
        var result = ArrayList(i32).init(self.allocator);
        var previous_result = ArrayList(i32).init(self.allocator);
        defer previous_result.deinit();

        var fail_index: i32 = -1;

        for (self.source, 0..) |_, i| {
            var delta = self.source[i];

            for (1..result.items.len + 1) |j| {
                delta -= result.items[j - 1] * self.source[i - j];
            }

            if (delta == 0) {
                continue;
            }

            if (fail_index == -1) {
                result.clearAndFree();
                try result.appendNTimes(0, i + 1);
                fail_index = @intCast(i);
            } else {
                var previous_result_copy = ArrayList(i32).init(self.allocator);
                defer previous_result_copy.deinit();

                try previous_result_copy.append(1);
                for (previous_result.items) |term| {
                    try previous_result_copy.append(-term);
                }

                var term_fail_index_plus_one: i32 = 0;
                for (1..previous_result_copy.items.len + 1) |j| {
                    const idx = @as(usize, @intCast(fail_index + 1)) - j;
                    term_fail_index_plus_one += previous_result_copy.items[j - 1] * self.source[idx];
                }

                const coeff = @divExact(delta, term_fail_index_plus_one);
                for (previous_result_copy.items) |*item| {
                    item.* *= coeff;
                }

                const shift_count = @as(usize, @intCast(i)) - @as(usize, @intCast(fail_index)) - 1;
                for (0..shift_count) |_| {
                    try previous_result_copy.insert(0, 0);
                }

                const result_copy = try result.clone();
                defer result_copy.deinit();

                while (result.items.len < previous_result_copy.items.len) {
                    try result.append(0);
                }

                for (previous_result_copy.items, 0..) |item, j| {
                    result.items[j] += item;
                }

                const result_len_as_i32: i32 = @intCast(result_copy.items.len);
                const previous_result_len_as_i32: i32 = @intCast(previous_result.items.len);

                if (@as(i32, @intCast(i)) - result_len_as_i32 > fail_index - previous_result_len_as_i32) {
                    previous_result.clearAndFree();
                    try previous_result.appendSlice(result_copy.items);
                    fail_index = @intCast(i);
                }
            }
        }

        return result;
    }

    pub fn computeTerm(self: *const Self, bm_coeffs: []const i32, index: usize) !i32 {
        if (bm_coeffs.len == 0) {
            return 0;
        }

        if (index < self.source.len) {
            return @mod(self.source[index] + self.modulus, self.modulus);
        }

        var coeffs = ArrayList(i32).init(self.allocator);
        defer coeffs.deinit();

        try coeffs.append(self.modulus - 1);
        try coeffs.appendSlice(bm_coeffs);

        const bm_coeffs_size = bm_coeffs.len;
        var f = ArrayList(i32).init(self.allocator);
        var g = ArrayList(i32).init(self.allocator);
        defer f.deinit();
        defer g.deinit();

        try f.appendNTimes(0, bm_coeffs_size);
        try g.appendNTimes(0, bm_coeffs_size);

        f.items[0] = 1;

        if (bm_coeffs_size == 1) {
            g.items[0] = coeffs.items[1];
        } else {
            g.items[1] = 1;
        }

        var power = index - 1;
        while (power > 0) {
            if ((power & 1) == 1) {
                const new_f = try self.polynomialMultiply(f.items, g.items, bm_coeffs_size, coeffs.items);
                defer self.allocator.free(new_f);
                f.clearAndFree();
                try f.appendSlice(new_f);
            }
            const new_g = try self.polynomialMultiply(g.items, g.items, bm_coeffs_size, coeffs.items);
            defer self.allocator.free(new_g);
            g.clearAndFree();
            try g.appendSlice(new_g);
            power >>= 1;
        }

        var result: i32 = 0;
        for (0..bm_coeffs_size) |i| {
            if (i + 1 < self.source.len) {
                result = @mod(result + self.source[i + 1] * f.items[i], self.modulus);
            }
        }
        return @mod(result + self.modulus, self.modulus);
    }

    pub fn polynomial(self: *const Self, bm_coeffs: []const i32) ![]u8 {
        const degree = bm_coeffs.len - 1;
        if (degree == 0) {
            return std.fmt.allocPrint(self.allocator, "{d}", .{bm_coeffs[0]});
        }

        var text = ArrayList(u8).init(self.allocator);
        defer text.deinit();

        var i: usize = degree;
        while (true) {
            const coeff = bm_coeffs[i];
            if (coeff == 0) {
                if (i == 0) break;
                i -= 1;
                continue;
            }

            const sign = if (coeff < 0 and i == degree) "-" else if (coeff < 0) " - " else if (i < degree) " + " else "";
            try text.appendSlice(sign);

            const coeff_abs = @abs(coeff);
            if (coeff_abs > 1) {
                const coeff_str = try std.fmt.allocPrint(self.allocator, "{d}", .{coeff_abs});
                defer self.allocator.free(coeff_str);
                try text.appendSlice(coeff_str);
            }

            const term = if (i > 1) blk: {
                break :blk try std.fmt.allocPrint(self.allocator, "x^{d}", .{i});
            } else if (i == 1) blk: {
                break :blk try std.fmt.allocPrint(self.allocator, "x", .{});
            } else if (coeff_abs == 1) blk: {
                break :blk try std.fmt.allocPrint(self.allocator, "1", .{});
            } else blk: {
                break :blk try std.fmt.allocPrint(self.allocator, "", .{});
            };
            defer self.allocator.free(term);
            try text.appendSlice(term);

            if (i == 0) break;
            i -= 1;
        }

        return text.toOwnedSlice();
    }

    fn polynomialMultiply(self: *const Self, a: []const i32, b: []const i32, degree: usize, coeffs: []const i32) ![]i32 {
        var result = try self.allocator.alloc(i32, 2 * degree);
        @memset(result, 0);

        for (0..degree) |i| {
            if (a[i] == 0) {
                continue;
            }
            for (0..degree) |j| {
                result[i + j] = @mod(result[i + j] + a[i] * b[j], self.modulus);
            }
        }

        var i: usize = 2 * degree - 1;
        while (i >= degree) {
            if (result[i] == 0) {
                if (i == degree) break;
                i -= 1;
                continue;
            }

            const term = result[i];
            result[i] = 0;

            for (0..degree + 1) |j| {
                const index = i - j;
                if (index < result.len) {
                    result[index] = @mod(result[index] + term * coeffs[j], self.modulus);
                }
            }

            if (i == degree) break;
            i -= 1;
        }

        const final_result = try self.allocator.alloc(i32, degree);
        @memcpy(final_result, result[0..degree]);
        self.allocator.free(result);
        return final_result;
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const source = [_]i32{ 0, 1, 1, 2, 3, 5, 8, 13, 21 };
    const bm = BerlekampMassey.init(allocator, &source, 100);

    var bm_coeffs = try bm.computeCoefficients();
    defer bm_coeffs.deinit();

    // Print coefficients
    std.debug.print("Berlekamp-Massey coefficients: [", .{});
    for (bm_coeffs.items, 0..) |coeff, i| {
        if (i > 0) std.debug.print(", ", .{});
        std.debug.print("{d}", .{coeff});
    }
    std.debug.print("] (lowest to highest degree)\n", .{});

    // Print polynomial
    const poly_str = try bm.polynomial(bm_coeffs.items);
    defer allocator.free(poly_str);
    std.debug.print("The connection polynomial is {s} having degree {d}\n\n", .{ poly_str, bm_coeffs.items.len - 1 });

    // Print terms
    std.debug.print("Terms indexed 35 to 40 from the Fibonacci sequence modulo 100:\n", .{});
    const indices = [_]usize{ 35, 36, 37, 38, 39, 40 };

    for (indices, 0..) |idx, i| {
        if (i > 0) std.debug.print(" ", .{});
        const term = try bm.computeTerm(bm_coeffs.items, idx);
        std.debug.print("{d}", .{term});
    }
    std.debug.print("\n", .{});
}
