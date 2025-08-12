const std = @import("std");

pub fn main() !void {
    var m1 = [_][2]f64{
        [_]f64{1.0, 2.0},
        [_]f64{3.0, 4.0},
    };

    var m2 = [_][4]f64{
        [_]f64{1.0, 2.0, 3.0, 4.0},
        [_]f64{4.0, 5.0, 6.0, 7.0},
        [_]f64{7.0, 8.0, 9.0, 10.0},
        [_]f64{10.0, 11.0, 12.0, 13.0},
    };

    var m3 = [_][5]f64{
        [_]f64{0.0, 1.0, 2.0, 3.0, 4.0},
        [_]f64{5.0, 6.0, 7.0, 8.0, 9.0},
        [_]f64{10.0, 11.0, 12.0, 13.0, 14.0},
        [_]f64{15.0, 16.0, 17.0, 18.0, 19.0},
        [_]f64{20.0, 21.0, 22.0, 23.0, 24.0},
    };

    std.debug.print("Determinant of m1: {d}\n", .{determinant(2, &m1)});
    std.debug.print("Permanent of m1: {d}\n", .{permanent(2, &m1)});

    std.debug.print("Determinant of m2: {d}\n", .{determinant(4, &m2)});
    std.debug.print("Permanent of m2: {d}\n", .{permanent(4, &m2)});

    std.debug.print("Determinant of m3: {d}\n", .{determinant(5, &m3)});
    std.debug.print("Permanent of m3: {d}\n", .{permanent(5, &m3)});
}

fn minor(comptime N: usize, a: *const [N][N]f64, x: usize, y: usize) [N - 1][N - 1]f64 {
    var out_mat: [N - 1][N - 1]f64 = undefined;

    var out_i: usize = 0;
    var i: usize = 0;
    while (i < N) : (i += 1) {
        if (i == x) continue;

        var out_j: usize = 0;
        var j: usize = 0;
        while (j < N) : (j += 1) {
            if (j == y) continue;

            out_mat[out_i][out_j] = a[i][j];
            out_j += 1;
        }
        out_i += 1;
    }

    return out_mat;
}

fn determinant(comptime N: usize, matrix: *const [N][N]f64) f64 {
    if (N == 1) {
        return matrix[0][0];
    }

    var sign: f64 = 1.0;
    var sum: f64 = 0.0;

    for (0..N) |i| {
        const m = minor(N, matrix, 0, i);
        sum += sign * matrix[0][i] * determinant(N - 1, &m);
        sign *= -1.0;
    }

    return sum;
}

fn permanent(comptime N: usize, matrix: *const [N][N]f64) f64 {
    if (N == 1) {
        return matrix[0][0];
    }

    var sum: f64 = 0.0;

    for (0..N) |i| {
        const m = minor(N, matrix, 0, i);
        sum += matrix[0][i] * permanent(N - 1, &m);
    }

    return sum;
}
