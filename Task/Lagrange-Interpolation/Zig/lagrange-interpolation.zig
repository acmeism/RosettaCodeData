const std = @import("std");
const print = std.debug.print;
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

fn add(allocator: Allocator, one: []const f64, two: []const f64) !ArrayList(f64) {
    const max_size = @max(one.len, two.len);
    var sum = try ArrayList(f64).initCapacity(allocator, max_size);
    // Initialize all elements to 0
    for (0..max_size) |i| {
        sum.items[i] = 0.0;
    }

    for (0..one.len) |i| {
        sum.items[i] = one[i];
    }

    for (0..two.len) |i| {
        sum.items[i] += two[i];
    }

    return sum;
}

fn multiply(allocator: Allocator, one: []const f64, two: []const f64) !ArrayList(f64) {
    const result_size = one.len + two.len - 1;
    var product = try ArrayList(f64).initCapacity(allocator, result_size);

    // Initialize all elements to 0
    for (0..result_size) |i| {
        product.items[i] = 0.0;
    }

    for (0..one.len) |i| {
        for (0..two.len) |j| {
            product.items[i + j] += one[i] * two[j];
        }
    }

    return product;
}

fn scalarMultiply(allocator: Allocator, vec: []const f64, value: f64) !ArrayList(f64) {
    var result = try ArrayList(f64).initCapacity(allocator, vec.len);

    for (vec) |d| {
        try result.append(d * value);
    }

    return result;
}

fn scalarDivide(allocator: Allocator, vec: []const f64, value: f64) !ArrayList(f64) {
    return scalarMultiply(allocator, vec, 1.0 / value);
}

fn evaluate(vec: []const f64, value: f64) f64 {
    var result: f64 = 0.0;
    var i = vec.len;
    while (i > 0) {
        i -= 1;
        result = result * value + vec[i];
    }
    return result;
}

fn display(vec: []const f64) void {
    const degree = vec.len - 1;
    if (degree == 0) {
        print("{d:.5}\n", .{vec[0]});
        return;
    }

    var output = std.ArrayList(u8).init(std.heap.page_allocator);
    defer output.deinit();

    var i = degree + 1;
    while (i > 0) {
        i -= 1;
        if (vec[i] == 0.0) {
            continue;
        }

        const sign = if (vec[i] < 0.0 and i == degree) "-"
            else if (vec[i] < 0.0) " - "
            else if (i < degree) " + "
            else "";

        output.writer().writeAll(sign) catch unreachable;

        const coeff = @abs(vec[i]);
        if (coeff > 1.0) {
            var buf: [32]u8 = undefined;
            const coeff_str = std.fmt.bufPrint(&buf, "{d:.5}", .{coeff}) catch unreachable;
            output.writer().writeAll(coeff_str) catch unreachable;
        }

        if (i > 1) {
            var buf: [32]u8 = undefined;
            const term = std.fmt.bufPrint(&buf, "x^{d}", .{i}) catch unreachable;
            output.writer().writeAll(term) catch unreachable;
        } else if (i == 1) {
            output.writer().writeAll("x") catch unreachable;
        } else if (coeff == 1.0) {
            output.writer().writeAll("1") catch unreachable;
        }
    }

    print("{s}\n", .{output.items});
}

const Point = struct {
    x: f64,
    y: f64,
};

fn lagrangeInterpolation(allocator: Allocator, points: []const Point) !ArrayList(f64) {
    var polys = ArrayList(ArrayList(f64)).init(allocator);
    defer {
        for (polys.items) |*poly| {
            poly.deinit();
        }
        polys.deinit();
    }

    for (0..points.len) |_| {
        try polys.append(ArrayList(f64).init(allocator));
    }

    for (points, 0..) |_, i| {
        var poly = ArrayList(f64).init(allocator);
        try poly.append(1.0);

        for (points, 0..) |point, j| {
            if (i != j) {
                var factor = ArrayList(f64).init(allocator);
                try factor.append(-point.x);
                try factor.append(1.0);

                const temp = try multiply(allocator, poly.items, factor.items);
                poly.deinit();
                factor.deinit();
                poly = temp;
            }
        }

        const value = evaluate(poly.items, points[i].x);
        const divided = try scalarDivide(allocator, poly.items, value);
        poly.deinit();

        polys.items[i] = divided;
    }

    var sum = ArrayList(f64).init(allocator);
    try sum.append(0.0);

    for (points, 0..) |point, i| {
        var scaled_poly = try scalarMultiply(allocator, polys.items[i].items, point.y);
        defer scaled_poly.deinit();

        const new_sum = try add(allocator, sum.items, scaled_poly.items);
        sum.deinit();
        sum = new_sum;
    }

    return sum;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const points = [_]Point{
        .{ .x = 1.0, .y = 1.0 },
        .{ .x = 2.0, .y = 4.0 },
        .{ .x = 3.0, .y = 1.0 },
        .{ .x = 4.0, .y = 5.0 },
    };

    var result = try lagrangeInterpolation(allocator, &points);
    defer result.deinit();

    display(result.items);
}
