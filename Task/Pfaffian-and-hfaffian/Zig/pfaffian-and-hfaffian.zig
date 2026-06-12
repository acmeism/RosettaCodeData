const std = @import("std");
const print = std.debug.print;
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

const Faffian = enum {
    Pfaffian,
    Hfaffian,

    pub fn toString(self: Faffian) []const u8 {
        return switch (self) {
            .Pfaffian => "Pfaffian",
            .Hfaffian => "Hfaffain",
        };
    }
};

const SignedPerm = struct {
    permutation: []u32,
    sign: i32,
    allocator: Allocator,

    pub fn init(allocator: Allocator, permutation: []const u32, sign: i32) !SignedPerm {
        const perm_copy = try allocator.dupe(u32, permutation);
        return SignedPerm{
            .permutation = perm_copy,
            .sign = sign,
            .allocator = allocator,
        };
    }

    pub fn deinit(self: *SignedPerm) void {
        self.allocator.free(self.permutation);
    }
};

fn printMatrix(matrix: []const []const i32) void {
    for (matrix) |row| {
        print("|", .{});
        for (row, 0..) |val, i| {
            if (i < row.len - 1) {
                print("{d:2}, ", .{val});
            } else {
                print("{d:2}", .{val});
            }
        }
        print("|\n", .{});
    }
}

fn factorial(n: u32) u32 {
    if (n == 0) return 1;
    var result: u32 = 1;
    var i: u32 = 1;
    while (i <= n) : (i += 1) {
        result *= i;
    }
    return result;
}

fn isAntisymmetric(matrix: []const []const i32) bool {
    for (matrix, 0..) |row, i| {
        if (row[i] != 0) {
            return false;
        }
        for (row, 0..) |_, j| {
            if (j > i) {
                if (matrix[i][j] != -matrix[j][i]) {
                    return false;
                }
            }
        }
    }
    return true;
}

fn signedPermutations(allocator: Allocator, n: u32) ![]SignedPerm {
    var perms = try allocator.alloc(u32, n + 1);
    defer allocator.free(perms);

    for (perms, 0..) |*perm, i| {
        perm.* = @intCast(i);
    }

    var signed_perms = ArrayList(SignedPerm).init(allocator);
    errdefer {
        for (signed_perms.items) |*sp| {
            sp.deinit();
        }
        signed_perms.deinit();
    }

    try signed_perms.append(try SignedPerm.init(allocator, perms, 1));
    var sign: i32 = 1;

    const fact = factorial(n + 1);
    var count: u32 = 1;
    while (count < fact) : (count += 1) {
        var i: usize = n - 1;
        var j: usize = n;

        while (perms[i] > perms[i + 1]) {
            i -= 1;
        }

        while (perms[j] < perms[i]) {
            j -= 1;
        }

        std.mem.swap(u32, &perms[i], &perms[j]);
        sign = -sign;

        i += 1;
        j = n;

        while (i < j) {
            std.mem.swap(u32, &perms[i], &perms[j]);
            sign = -sign;
            i += 1;
            j -= 1;
        }

        try signed_perms.append(try SignedPerm.init(allocator, perms, sign));
    }

    return signed_perms.toOwnedSlice();
}

fn computeFaffian(allocator: Allocator, matrix: []const []const i32, faffian: Faffian) !?i32 {
    if (matrix.len % 2 != 0) {
        print("Matrix size must be even for {s}\n", .{faffian.toString()});
        return null;
    }

    if (!isAntisymmetric(matrix)) {
        print("The {s} does not support non-antisymmetric matrices\n", .{faffian.toString()});
        return null;
    }

    const n = matrix.len / 2;
    var sum: i32 = 0;
    const signed_perms = try signedPermutations(allocator, @as(u32, @intCast(2 * n - 1)));
    defer {
        for (signed_perms) |*sp| {
            var sp_mut = sp.*;
            sp_mut.deinit();
        }
        allocator.free(signed_perms);
    }

    for (signed_perms) |signed_perm| {
        const sigma = signed_perm.permutation;
        const sign = switch (faffian) {
            .Pfaffian => signed_perm.sign,
            .Hfaffian => 1,
        };

        var product: i32 = 1;
        for (0..n) |i| {
            product *= matrix[sigma[2 * i]][sigma[2 * i + 1]];
        }
        sum += sign * product;
    }

    const normalisation = 1.0 / @as(f64, @floatFromInt(factorial(@as(u32, @intCast(n))))) / std.math.pow(f64, 2.0, @as(f64, @floatFromInt(n)));
    return @as(i32, @intFromFloat(@round(@as(f64, @floatFromInt(sum)) * normalisation)));
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Define matrices using comptime for cleaner initialization
    const matrix1 = [_][]const i32{
        &[_]i32{ 0, 1 },
        &[_]i32{ -1, 0 },
    };

    const matrix2 = [_][]const i32{
        &[_]i32{ 0, 1, -1, 2 },
        &[_]i32{ -1, 0, 3, -4 },
        &[_]i32{ 1, -3, 0, 5 },
        &[_]i32{ -2, 4, -5, 0 },
    };

    const matrix3 = [_][]const i32{
        &[_]i32{ 1, 2, 3, 4, 5, 6 },
        &[_]i32{ 2, 7, 8, 9, 10, 11 },
        &[_]i32{ 3, 8, 12, 13, 14, 15 },
        &[_]i32{ 4, 9, 13, 16, 17, 18 },
        &[_]i32{ 5, 10, 14, 17, 19, 20 },
        &[_]i32{ 6, 11, 15, 18, 20, 21 },
    };

    const matrix4 = [_][]const i32{
        &[_]i32{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 },
        &[_]i32{ -1, 0, 8, 7, 6, 5, 4, 3, 2, 1 },
        &[_]i32{ -2, -8, 0, 1, 2, 3, 4, 5, 6, 7 },
        &[_]i32{ -3, -7, -1, 0, 6, 5, 4, 3, 2, 1 },
        &[_]i32{ -4, -6, -2, -6, 0, 1, 2, 3, 4, 5 },
        &[_]i32{ -5, -5, -3, -5, -1, 0, 4, 3, 2, 1 },
        &[_]i32{ -6, -4, -4, -4, -2, -4, 0, 1, 2, 3 },
        &[_]i32{ -7, -3, -5, -3, -3, -3, -1, 0, 2, 1 },
        &[_]i32{ -8, -2, -6, -2, -4, -2, -2, -2, 0, 1 },
        &[_]i32{ -9, -1, -7, -1, -5, -1, -3, -1, -1, 0 },
    };

    const matrices = [_][]const []const i32{
        &matrix1,
        &matrix2,
        &matrix3,
        &matrix4,
    };

    for (matrices) |matrix| {
        printMatrix(matrix);
        const faffians = [_]Faffian{ .Pfaffian, .Hfaffian };
        for (faffians) |faffian| {
            if (try computeFaffian(allocator, matrix, faffian)) |result| {
                print("{s}: {d}\n", .{ faffian.toString(), result });
            }
        }
        print("\n", .{});
    }
}
