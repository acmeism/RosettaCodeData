const std = @import("std");

fn cholesky(mat: []const f64, n: usize, allocator: std.mem.Allocator) ![]f64 {
    const res = try allocator.alloc(f64, mat.len);
    @memset(res, 0.0);

    for (0..n) |i| {
        for (0..i+1) |j| {
            var s: f64 = 0.0;
            for (0..j) |k| {
                s += res[i * n + k] * res[j * n + k];
            }

            res[i * n + j] = if (i == j)
                std.math.sqrt(mat[i * n + i] - s)
            else
                (1.0 / res[j * n + j] * (mat[i * n + j] - s));
        }
    }
    return res;
}

fn showMatrix(matrix: []const f64, n: usize) void {
    for (0..n) |i| {
        for (0..n) |j| {
            std.debug.print("{d:.4}\t", .{matrix[i * n + j]});
        }
        std.debug.print("\n", .{});
    }
    std.debug.print("\n", .{});
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    {
        const dimension: usize = 3;
        const m1 = [_]f64{
            25.0, 15.0, -5.0,
            15.0, 18.0,  0.0,
            -5.0,  0.0, 11.0
        };

        const res1 = try cholesky(&m1, dimension, allocator);
        defer allocator.free(res1);
        showMatrix(res1, dimension);
    }

    {
        const dimension: usize = 4;
        const m2 = [_]f64{
            18.0, 22.0,  54.0,  42.0,
            22.0, 70.0,  86.0,  62.0,
            54.0, 86.0, 174.0, 134.0,
            42.0, 62.0, 134.0, 106.0
        };

        const res2 = try cholesky(&m2, dimension, allocator);
        defer allocator.free(res2);
        showMatrix(res2, dimension);
    }
}
