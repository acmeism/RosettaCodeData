const std = @import("std");
const print = std.debug.print;

const Point = struct {
    x: f32,
    y: f32,

    pub fn format(
        self: Point,
        comptime fmt: []const u8,
        options: std.fmt.FormatOptions,
        writer: anytype,
    ) !void {
        _ = fmt;
        _ = options;
        try writer.print("Point{{ x: {d}, y: {d} }}", .{ self.x, self.y });
    }
};

fn calculateConvexHull(allocator: std.mem.Allocator, points: []const Point) ![]Point {
    // There must be at least 3 points
    if (points.len < 3) {
        const result = try allocator.alloc(Point, points.len);
        @memcpy(result, points);
        return result;
    }

    var hull = std.ArrayList(Point).init(allocator);
    defer hull.deinit();

    // Find the left most point in the polygon
    var left_most_idx: usize = 0;
    for (points, 0..) |p, i| {
        if (p.x < points[left_most_idx].x) {
            left_most_idx = i;
        }
    }

    var p = left_most_idx;
    var q: usize = 0;

    while (true) {
        // The left most point must be part of the hull
        try hull.append(points[p]);

        q = (p + 1) % points.len;

        for (points, 0..) |_, i| {
            if (orientation(&points[p], &points[i], &points[q]) == 2) {
                q = i;
            }
        }

        p = q;

        // Break from loop once we reach the first point again
        if (p == left_most_idx) break;
    }

    return hull.toOwnedSlice();
}

// Calculate orientation for 3 points
// 0 -> Straight line
// 1 -> Clockwise
// 2 -> Counterclockwise
fn orientation(p: *const Point, q: *const Point, r: *const Point) usize {
    const val = (q.y - p.y) * (r.x - q.x) - (q.x - p.x) * (r.y - q.y);

    if (val == 0) return 0;
    if (val > 0) return 1 else return 2;
}

fn pt(x: i32, y: i32) Point {
    return Point{ .x = @as(f32, @floatFromInt(x)), .y = @as(f32, @floatFromInt(y)) };
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const points = [_]Point{
        pt(16, 3),   pt(12, 17),  pt(0, 6),    pt(-4, -6),  pt(16, 6),
        pt(16, -7),  pt(16, -3),  pt(17, -4),  pt(5, 19),   pt(19, -8),
        pt(3, 16),   pt(12, 13),  pt(3, -4),   pt(17, 5),   pt(-3, 15),
        pt(-3, -9),  pt(0, 11),   pt(-9, -3),  pt(-4, -2),  pt(12, 10),
    };

    const hull = try calculateConvexHull(allocator, &points);
    defer allocator.free(hull);

    for (hull) |point| {
        print("{}\n", .{point});
    }
}
