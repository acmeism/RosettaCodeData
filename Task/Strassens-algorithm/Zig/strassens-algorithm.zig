const std = @import("std");
const fmt = std.fmt;
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

const Matrix = struct {
    data: ArrayList(ArrayList(f64)),
    rows: usize,
    cols: usize,
    allocator: Allocator,

    pub fn init(allocator: Allocator, data: ArrayList(ArrayList(f64))) !Matrix {
        const rows = data.items.len;
        const cols = if (rows > 0) data.items[0].items.len else 0;

        return Matrix{
            .data = data,
            .rows = rows,
            .cols = cols,
            .allocator = allocator,
        };
    }

    pub fn deinit(self: *Matrix) void {
        for (self.data.items) |*row| {
            row.deinit();
        }
        self.data.deinit();
    }

    pub fn clone(self: Matrix) !Matrix {
        var new_data = ArrayList(ArrayList(f64)).init(self.allocator);
        try new_data.ensureTotalCapacity(self.rows);

        for (self.data.items) |row| {
            var new_row = ArrayList(f64).init(self.allocator);
            try new_row.ensureTotalCapacity(self.cols);
            try new_row.appendSlice(row.items);
            try new_data.append(new_row);
        }

        return Matrix{
            .data = new_data,
            .rows = self.rows,
            .cols = self.cols,
            .allocator = self.allocator,
        };
    }

    pub fn validateDimensions(self: Matrix, other: Matrix) !void {
        if (self.rows != other.rows or self.cols != other.cols) {
            return error.DimensionMismatch;
        }
    }

    pub fn validateMultiplication(self: Matrix, other: Matrix) !void {
        if (self.cols != other.rows) {
            return error.CannotMultiply;
        }
    }

    pub fn validateSquarePowerOfTwo(self: Matrix) !void {
        if (self.rows != self.cols) {
            return error.NotSquare;
        }
        if (self.rows == 0 or (self.rows & (self.rows - 1)) != 0) {
            return error.NotPowerOfTwo;
        }
    }

    pub fn add(self: Matrix, other: Matrix) !Matrix {
        try self.validateDimensions(other);

        var result_data = ArrayList(ArrayList(f64)).init(self.allocator);
        try result_data.ensureTotalCapacity(self.rows);

        for (0..self.rows) |i| {
            var row = ArrayList(f64).init(self.allocator);
            try row.ensureTotalCapacity(self.cols);

            for (0..self.cols) |j| {
                try row.append(self.data.items[i].items[j] + other.data.items[i].items[j]);
            }
            try result_data.append(row);
        }

        return try Matrix.init(self.allocator, result_data);
    }

    pub fn sub(self: Matrix, other: Matrix) !Matrix {
        try self.validateDimensions(other);

        var result_data = ArrayList(ArrayList(f64)).init(self.allocator);
        try result_data.ensureTotalCapacity(self.rows);

        for (0..self.rows) |i| {
            var row = ArrayList(f64).init(self.allocator);
            try row.ensureTotalCapacity(self.cols);

            for (0..self.cols) |j| {
                try row.append(self.data.items[i].items[j] - other.data.items[i].items[j]);
            }
            try result_data.append(row);
        }

        return try Matrix.init(self.allocator, result_data);
    }

    pub fn mul(self: Matrix, other: Matrix) !Matrix {
        try self.validateMultiplication(other);

        var result_data = ArrayList(ArrayList(f64)).init(self.allocator);
        try result_data.ensureTotalCapacity(self.rows);

        for (0..self.rows) |i| {
            var row = ArrayList(f64).init(self.allocator);
            try row.ensureTotalCapacity(other.cols);

            for (0..other.cols) |j| {
                var sum: f64 = 0.0;
                for (0..self.cols) |k| {
                    sum += self.data.items[i].items[k] * other.data.items[k].items[j];
                }
                try row.append(sum);
            }
            try result_data.append(row);
        }

        return try Matrix.init(self.allocator, result_data);
    }

    pub fn format(self: Matrix, comptime _: []const u8, _: fmt.FormatOptions, writer: anytype) !void {
        for (self.data.items) |row| {
            try writer.print("{any}\n", .{row.items});
        }
    }

    pub fn toStringWithPrecision(self: Matrix, p: usize, allocator: Allocator) ![]u8 {
        var output = ArrayList(u8).init(allocator);
        defer output.deinit();

        const pow = std.math.pow(f64, 10.0, @as(f64, @floatFromInt(p)));

        for (self.data.items) |row| {
            var formatted_row = ArrayList([]const u8).init(allocator);
            defer {
                for (formatted_row.items) |item| {
                    allocator.free(item);
                }
                formatted_row.deinit();
            }

            for (row.items) |val| {
                const r = @round(val * pow) / pow;
                const formatted = try fmt.allocPrint(allocator, "{d}", .{r});

                if (std.mem.eql(u8, formatted, "-0")) {
                    allocator.free(formatted);
                    try formatted_row.append(try allocator.dupe(u8, "0"));
                } else {
                    try formatted_row.append(formatted);
                }
            }

            std.debug.print("{any}\n", .{formatted_row.items});
        }

        return output.toOwnedSlice();
    }

    fn params(r: usize, c: usize) [4][6]usize {
        return [4][6]usize{
            [_]usize{ 0, r, 0, c, 0, 0 },
            [_]usize{ 0, r, c, 2 * c, 0, c },
            [_]usize{ r, 2 * r, 0, c, r, 0 },
            [_]usize{ r, 2 * r, c, 2 * c, r, c },
        };
    }

    pub fn toQuarters(self: Matrix) ![4]Matrix {
        const r = self.rows / 2;
        const c = self.cols / 2;
        const p = Matrix.params(r, c);

        var quarters: [4]Matrix = undefined;

        for (0..4) |k| {
            var q_data = ArrayList(ArrayList(f64)).init(self.allocator);
            try q_data.ensureTotalCapacity(r);

            for (p[k][0]..p[k][1]) |i| {
                var row = ArrayList(f64).init(self.allocator);
                try row.ensureTotalCapacity(c);

                for (p[k][2]..p[k][3]) |j| {
                    try row.append(self.data.items[i].items[j]);
                }
                try q_data.append(row);
            }

            quarters[k] = try Matrix.init(self.allocator, q_data);
        }

        return quarters;
    }

    pub fn fromQuarters(q: [4]Matrix, allocator: Allocator) !Matrix {
        const r = q[0].rows;
        const c = q[0].cols;
        const p = Matrix.params(r, c);
        const rows = r * 2;
        const cols = c * 2;

        var m_data = ArrayList(ArrayList(f64)).init(allocator);
        try m_data.ensureTotalCapacity(rows);

        for (0..rows) |_| {
            var row = ArrayList(f64).init(allocator);
            try row.ensureTotalCapacity(cols);
            for (0..cols) |_| {
                try row.append(0.0);
            }
            try m_data.append(row);
        }

        for (0..4) |k| {
            for (p[k][0]..p[k][1]) |i| {
                for (p[k][2]..p[k][3]) |j| {
                    m_data.items[i].items[j] = q[k].data.items[i - p[k][4]].items[j - p[k][5]];
                }
            }
        }

        return try Matrix.init(allocator, m_data);
    }

    pub fn strassen(self: Matrix, other: Matrix) !Matrix {
        try self.validateSquarePowerOfTwo();
        try other.validateSquarePowerOfTwo();

        if (self.rows != other.rows or self.cols != other.cols) {
            return error.InvalidDimensions;
        }

        if (self.rows == 1) {
            return self.mul(other);
        }

        var qa = try self.toQuarters();
        defer for (&qa) |*q| q.deinit();

        var qb = try other.toQuarters();
        defer for (&qb) |*q| q.deinit();

        var t1 = try qa[1].sub(qa[3]);
        defer t1.deinit();
        var t2 = try qb[2].add(qb[3]);
        defer t2.deinit();
        var p1 = try t1.strassen(t2);
        defer p1.deinit();

        var t3 = try qa[0].add(qa[3]);
        defer t3.deinit();
        var t4 = try qb[0].add(qb[3]);
        defer t4.deinit();
        var p2 = try t3.strassen(t4);
        defer p2.deinit();

        var t5 = try qa[0].sub(qa[2]);
        defer t5.deinit();
        var t6 = try qb[0].add(qb[1]);
        defer t6.deinit();
        var p3 = try t5.strassen(t6);
        defer p3.deinit();

        var t7 = try qa[0].add(qa[1]);
        defer t7.deinit();
        var p4 = try t7.strassen(qb[3]);
        defer p4.deinit();

        var t8 = try qb[1].sub(qb[3]);
        defer t8.deinit();
        var p5 = try qa[0].strassen(t8);
        defer p5.deinit();

        var t9 = try qb[2].sub(qb[0]);
        defer t9.deinit();
        var p6 = try qa[3].strassen(t9);
        defer p6.deinit();

        var t10 = try qa[2].add(qa[3]);
        defer t10.deinit();
        var p7 = try t10.strassen(qb[0]);
        defer p7.deinit();

        var q: [4]Matrix = undefined;

        // q[0] = p1 + p2 - p4 + p6
        var ta = try p1.add(p2);
        defer ta.deinit();
        var tb = try ta.sub(p4);
        defer tb.deinit();
        q[0] = try tb.add(p6);

        // q[1] = p4 + p5
        q[1] = try p4.add(p5);

        // q[2] = p6 + p7
        q[2] = try p6.add(p7);

        // q[3] = p2 - p3 + p5 - p7
        var tc = try p2.sub(p3);
        defer tc.deinit();
        var td = try tc.add(p5);
        defer td.deinit();
        q[3] = try td.sub(p7);

        defer for (&q) |*quarter| quarter.deinit();

        return Matrix.fromQuarters(q, self.allocator);
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    // Matrix A - [1 2; 3 4]
    var a_data = ArrayList(ArrayList(f64)).init(allocator);
    var a_row1 = ArrayList(f64).init(allocator);
    try a_row1.appendSlice(&[_]f64{ 1.0, 2.0 });
    var a_row2 = ArrayList(f64).init(allocator);
    try a_row2.appendSlice(&[_]f64{ 3.0, 4.0 });
    try a_data.append(a_row1);
    try a_data.append(a_row2);
    var a = try Matrix.init(allocator, a_data);
    defer a.deinit();

    // Matrix B - [5 6; 7 8]
    var b_data = ArrayList(ArrayList(f64)).init(allocator);
    var b_row1 = ArrayList(f64).init(allocator);
    try b_row1.appendSlice(&[_]f64{ 5.0, 6.0 });
    var b_row2 = ArrayList(f64).init(allocator);
    try b_row2.appendSlice(&[_]f64{ 7.0, 8.0 });
    try b_data.append(b_row1);
    try b_data.append(b_row2);
    var b = try Matrix.init(allocator, b_data);
    defer b.deinit();

    // Matrix C - 4x4
    var c_data = ArrayList(ArrayList(f64)).init(allocator);
    var c_row1 = ArrayList(f64).init(allocator);
    try c_row1.appendSlice(&[_]f64{ 1.0, 1.0, 1.0, 1.0 });
    var c_row2 = ArrayList(f64).init(allocator);
    try c_row2.appendSlice(&[_]f64{ 2.0, 4.0, 8.0, 16.0 });
    var c_row3 = ArrayList(f64).init(allocator);
    try c_row3.appendSlice(&[_]f64{ 3.0, 9.0, 27.0, 81.0 });
    var c_row4 = ArrayList(f64).init(allocator);
    try c_row4.appendSlice(&[_]f64{ 4.0, 16.0, 64.0, 256.0 });
    try c_data.append(c_row1);
    try c_data.append(c_row2);
    try c_data.append(c_row3);
    try c_data.append(c_row4);
    var c = try Matrix.init(allocator, c_data);
    defer c.deinit();

    // Matrix D - 4x4
    var d_data = ArrayList(ArrayList(f64)).init(allocator);
    var d_row1 = ArrayList(f64).init(allocator);
    try d_row1.appendSlice(&[_]f64{ 4.0, -3.0, 4.0 / 3.0, -1.0 / 4.0 });
    var d_row2 = ArrayList(f64).init(allocator);
    try d_row2.appendSlice(&[_]f64{ -13.0 / 3.0, 19.0 / 4.0, -7.0 / 3.0, 11.0 / 24.0 });
    var d_row3 = ArrayList(f64).init(allocator);
    try d_row3.appendSlice(&[_]f64{ 3.0 / 2.0, -2.0, 7.0 / 6.0, -1.0 / 4.0 });
    var d_row4 = ArrayList(f64).init(allocator);
    try d_row4.appendSlice(&[_]f64{ -1.0 / 6.0, 1.0 / 4.0, -1.0 / 6.0, 1.0 / 24.0 });
    try d_data.append(d_row1);
    try d_data.append(d_row2);
    try d_data.append(d_row3);
    try d_data.append(d_row4);
    var d = try Matrix.init(allocator, d_data);
    defer d.deinit();

    // Matrix E - 4x4
    var e_data = ArrayList(ArrayList(f64)).init(allocator);
    var e_row1 = ArrayList(f64).init(allocator);
    try e_row1.appendSlice(&[_]f64{ 1.0, 2.0, 3.0, 4.0 });
    var e_row2 = ArrayList(f64).init(allocator);
    try e_row2.appendSlice(&[_]f64{ 5.0, 6.0, 7.0, 8.0 });
    var e_row3 = ArrayList(f64).init(allocator);
    try e_row3.appendSlice(&[_]f64{ 9.0, 10.0, 11.0, 12.0 });
    var e_row4 = ArrayList(f64).init(allocator);
    try e_row4.appendSlice(&[_]f64{ 13.0, 14.0, 15.0, 16.0 });
    try e_data.append(e_row1);
    try e_data.append(e_row2);
    try e_data.append(e_row3);
    try e_data.append(e_row4);
    var e = try Matrix.init(allocator, e_data);
    defer e.deinit();

    // Matrix F - Identity 4x4
    var f_data = ArrayList(ArrayList(f64)).init(allocator);
    var f_row1 = ArrayList(f64).init(allocator);
    try f_row1.appendSlice(&[_]f64{ 1.0, 0.0, 0.0, 0.0 });
    var f_row2 = ArrayList(f64).init(allocator);
    try f_row2.appendSlice(&[_]f64{ 0.0, 1.0, 0.0, 0.0 });
    var f_row3 = ArrayList(f64).init(allocator);
    try f_row3.appendSlice(&[_]f64{ 0.0, 0.0, 1.0, 0.0 });
    var f_row4 = ArrayList(f64).init(allocator);
    try f_row4.appendSlice(&[_]f64{ 0.0, 0.0, 0.0, 1.0 });
    try f_data.append(f_row1);
    try f_data.append(f_row2);
    try f_data.append(f_row3);
    try f_data.append(f_row4);
    var f = try Matrix.init(allocator, f_data);
    defer f.deinit();

    const stdout = std.io.getStdOut().writer();

    try stdout.print("Using 'normal' matrix multiplication:\n", .{});

    var a_clone = try a.clone();
    defer a_clone.deinit();
    var b_clone = try b.clone();
    defer b_clone.deinit();
    var ab = try a_clone.mul(b_clone);
    defer ab.deinit();
    try stdout.print("  a * b = {}\n", .{ab});

    var c_clone = try c.clone();
    defer c_clone.deinit();
    var d_clone = try d.clone();
    defer d_clone.deinit();
    var cd = try c_clone.mul(d_clone);
    defer cd.deinit();
    const cd_str = try cd.toStringWithPrecision(6, allocator);
    defer allocator.free(cd_str);
    try stdout.print("  c * d = {s}\n", .{cd_str});

    var e_clone = try e.clone();
    defer e_clone.deinit();
    var f_clone = try f.clone();
    defer f_clone.deinit();
    var ef = try e_clone.mul(f_clone);
    defer ef.deinit();
    try stdout.print("  e * f = {}\n", .{ef});

    try stdout.print("\nUsing 'Strassen' matrix multiplication:\n", .{});

    var a_clone2 = try a.clone();
    defer a_clone2.deinit();
    var b_clone2 = try b.clone();
    defer b_clone2.deinit();
    var ab_s = try a_clone2.strassen(b_clone2);
    defer ab_s.deinit();
    try stdout.print("  a * b = {}\n", .{ab_s});

    var c_clone2 = try c.clone();
    defer c_clone2.deinit();
    var d_clone2 = try d.clone();
    defer d_clone2.deinit();
    var cd_s = try c_clone2.strassen(d_clone2);
    defer cd_s.deinit();
    const cd_s_str = try cd_s.toStringWithPrecision(6, allocator);
    defer allocator.free(cd_s_str);
    try stdout.print("  c * d = {s}\n", .{cd_s_str});

    var e_clone2 = try e.clone();
    defer e_clone2.deinit();
    var f_clone2 = try f.clone();
    defer f_clone2.deinit();
    var ef_s = try e_clone2.strassen(f_clone2);
    defer ef_s.deinit();
    try stdout.print("  e * f = {}\n", .{ef_s});
}
