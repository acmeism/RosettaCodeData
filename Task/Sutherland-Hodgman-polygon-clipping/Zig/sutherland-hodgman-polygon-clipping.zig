const std = @import("std");
const print = std.debug.print;
const ArrayList = std.ArrayList;

const Point = struct {
    x: f64,
    y: f64,

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

const Polygon = struct {
    points: ArrayList(Point),

    pub fn init(allocator: std.mem.Allocator) Polygon {
        return Polygon{
            .points = ArrayList(Point).init(allocator),
        };
    }

    pub fn deinit(self: *Polygon) void {
        self.points.deinit();
    }

    pub fn clone(self: Polygon, allocator: std.mem.Allocator) !Polygon {
        var new_polygon = Polygon.init(allocator);
        try new_polygon.points.appendSlice(self.points.items);
        return new_polygon;
    }

    pub fn format(
        self: Polygon,
        comptime fmt: []const u8,
        options: std.fmt.FormatOptions,
        writer: anytype,
    ) !void {
        _ = fmt;
        _ = options;
        try writer.print("Polygon{{", .{});
        for (self.points.items, 0..) |point, i| {
            try writer.print(" {}", .{point});
            if (i < self.points.items.len - 1) {
                try writer.print(",", .{});
            }
        }
        try writer.print(" }}", .{});
    }
};

fn isInside(p: Point, cp1: Point, cp2: Point) bool {
    return (cp2.x - cp1.x) * (p.y - cp1.y) > (cp2.y - cp1.y) * (p.x - cp1.x);
}

fn computeIntersection(cp1: Point, cp2: Point, s: Point, e: Point) Point {
    const dc = Point{
        .x = cp1.x - cp2.x,
        .y = cp1.y - cp2.y,
    };
    const dp = Point{
        .x = s.x - e.x,
        .y = s.y - e.y,
    };
    const n1 = cp1.x * cp2.y - cp1.y * cp2.x;
    const n2 = s.x * e.y - s.y * e.x;
    const n3 = 1.0 / (dc.x * dp.y - dc.y * dp.x);

    return Point{
        .x = (n1 * dp.x - n2 * dc.x) * n3,
        .y = (n1 * dp.y - n2 * dc.y) * n3,
    };
}

fn sutherlandHodgmanClip(allocator: std.mem.Allocator, subject_polygon: Polygon, clip_polygon: Polygon) !Polygon {
    var result_ring = try subject_polygon.clone(allocator);

    if (clip_polygon.points.items.len == 0) {
        return result_ring;
    }

    var cp1 = clip_polygon.points.items[clip_polygon.points.items.len - 1];

    for (clip_polygon.points.items) |cp2| {
        var input = try result_ring.clone(allocator);
        defer input.deinit();

        result_ring.points.clearRetainingCapacity();

        if (input.points.items.len == 0) {
            continue;
        }

        var s = input.points.items[input.points.items.len - 1];

        for (input.points.items) |e| {
            if (isInside(e, cp1, cp2)) {
                if (!isInside(s, cp1, cp2)) {
                    try result_ring.points.append(computeIntersection(cp1, cp2, s, e));
                }
                try result_ring.points.append(e);
            } else if (isInside(s, cp1, cp2)) {
                try result_ring.points.append(computeIntersection(cp1, cp2, s, e));
            }
            s = e;
        }

        cp1 = cp2;
    }

    return result_ring;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    var subject_polygon = Polygon.init(allocator);
    defer subject_polygon.deinit();

    try subject_polygon.points.append(.{ .x = 50.0, .y = 150.0 });
    try subject_polygon.points.append(.{ .x = 200.0, .y = 50.0 });
    try subject_polygon.points.append(.{ .x = 350.0, .y = 150.0 });
    try subject_polygon.points.append(.{ .x = 350.0, .y = 300.0 });
    try subject_polygon.points.append(.{ .x = 250.0, .y = 300.0 });
    try subject_polygon.points.append(.{ .x = 200.0, .y = 250.0 });
    try subject_polygon.points.append(.{ .x = 150.0, .y = 350.0 });
    try subject_polygon.points.append(.{ .x = 100.0, .y = 250.0 });
    try subject_polygon.points.append(.{ .x = 100.0, .y = 200.0 });

    var clip_polygon = Polygon.init(allocator);
    defer clip_polygon.deinit();

    try clip_polygon.points.append(.{ .x = 100.0, .y = 100.0 });
    try clip_polygon.points.append(.{ .x = 300.0, .y = 100.0 });
    try clip_polygon.points.append(.{ .x = 300.0, .y = 300.0 });
    try clip_polygon.points.append(.{ .x = 100.0, .y = 300.0 });

    var result = try sutherlandHodgmanClip(allocator, subject_polygon, clip_polygon);
    defer result.deinit();

    print("{}\n", .{result});
}
