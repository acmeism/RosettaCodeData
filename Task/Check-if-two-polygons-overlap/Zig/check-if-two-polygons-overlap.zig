const std = @import("std");

// Replaces Rust Point struct
pub const Point = struct {
    x: f32,
    y: f32,

    pub fn init(x: f32, y: f32) Point {
        return .{ .x = x, .y = y };
    }
};

// Replaces Rust Vector struct
pub const Vector = struct {
    x: f32,
    y: f32,

    pub fn init(x: f32, y: f32) Vector {
        return .{ .x = x, .y = y };
    }

    // Renamed from scalar_product
    pub fn scalarProduct(self: *const Vector, other: *const Vector) f32 {
        return self.x * other.x + self.y * other.y;
    }

    // Renamed from edge_with
    pub fn edgeWith(self: *const Vector, other: *const Vector) Vector {
        return .{
            .x = self.x - other.x,
            .y = self.y - other.y,
        };
    }

    pub fn perpendicular(self: *const Vector) Vector {
        return .{
            .x = -self.y,
            .y = self.x,
        };
    }

    // Similar to Display implementation in Rust
    pub fn format(
        self: *const Vector,
        comptime fmt: []const u8,
        options: std.fmt.FormatOptions,
        writer: anytype,
    ) !void {
        _ = fmt;
        _ = options;
        try writer.print("({d}, {d})", .{ self.x, self.y });
    }
};

// Replaces Rust Projection struct
pub const Projection = struct {
    min: f32,
    max: f32,

    pub fn init(min: f32, max: f32) Projection {
        return .{ .min = min, .max = max };
    }

    pub fn overlaps(self: *const Projection, other: *const Projection) bool {
        return !(self.max < other.min or other.max < self.min);
    }
};

// Replaces Rust Polygon struct
pub const Polygon = struct {
    vertices: std.ArrayList(Vector),
    axes: std.ArrayList(Vector),

    pub fn init(allocator: std.mem.Allocator, points: []const Point) !Polygon {
        var vertices = try computeVertices(allocator, points);
        errdefer vertices.deinit();

        var axes = try computeAxes(allocator, vertices.items);
        errdefer axes.deinit();

        return .{
            .vertices = vertices,
            .axes = axes,
        };
    }

    pub fn deinit(self: *Polygon) void {
        self.vertices.deinit();
        self.axes.deinit();
    }

    // Helper function
    fn computeVertices(allocator: std.mem.Allocator, points: []const Point) !std.ArrayList(Vector) {
        var vertices = std.ArrayList(Vector).init(allocator);
        errdefer vertices.deinit();

        for (points) |p| {
            try vertices.append(.{ .x = p.x, .y = p.y });
        }

        return vertices;
    }

    // Helper function
    fn computeAxes(allocator: std.mem.Allocator, vertices: []const Vector) !std.ArrayList(Vector) {
        var axes = std.ArrayList(Vector).init(allocator);
        errdefer axes.deinit();

        if (vertices.len < 2) {
            return axes; // Handle cases with less than 2 vertices
        }

        for (vertices, 0..) |p1, i| {
            // Use modulo for wrap-around indexing
            const p2 = vertices[(i + 1) % vertices.len];
            const edge = p1.edgeWith(&p2);
            try axes.append(edge.perpendicular());
        }

        return axes;
    }

    pub fn overlaps(self: *const Polygon, other: *const Polygon) bool {
        // Check axes from this polygon
        for (self.axes.items) |*axis| {
            const projection1 = self.projectionOnAxis(axis);
            const projection2 = other.projectionOnAxis(axis);

            if (!projection1.overlaps(&projection2)) {
                return false; // Found a separating axis
            }
        }

        // Check axes from the other polygon
        for (other.axes.items) |*axis| {
            const projection1 = self.projectionOnAxis(axis);
            const projection2 = other.projectionOnAxis(axis);

            if (!projection1.overlaps(&projection2)) {
                return false; // Found a separating axis
            }
        }

        return true; // No separating axis found, polygons overlap
    }

    pub fn projectionOnAxis(self: *const Polygon, axis: *const Vector) Projection {
        var min = std.math.inf(f32);
        var max = -std.math.inf(f32);

        for (self.vertices.items) |*vertex| {
            const p = axis.scalarProduct(vertex);
            min = @min(min, p);
            max = @max(max, p);
        }

        return .{ .min = min, .max = max };
    }

    // Similar to Display implementation in Rust
    pub fn format(
        self: *const Polygon,
        comptime fmt: []const u8,
        options: std.fmt.FormatOptions,
        writer: anytype,
    ) !void {
        _ = fmt;
        _ = options;
        try writer.writeAll("[ ");

        for (self.vertices.items) |*vertex| {
            try writer.print("{} ", .{vertex});
        }

        try writer.writeAll("]");
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const points1 = [_]Point{
        Point.init(0.0, 0.0), Point.init(0.0, 2.0), Point.init(1.0, 4.0),
        Point.init(2.0, 2.0), Point.init(2.0, 0.0),
    };

    const points2 = [_]Point{
        Point.init(4.0, 0.0), Point.init(4.0, 2.0), Point.init(5.0, 4.0),
        Point.init(6.0, 2.0), Point.init(6.0, 0.0),
    };

    const points3 = [_]Point{
        Point.init(1.0, 0.0), Point.init(1.0, 2.0), Point.init(5.0, 4.0),
        Point.init(9.0, 2.0), Point.init(9.0, 0.0),
    };

    var polygon1 = try Polygon.init(allocator, &points1);
    defer polygon1.deinit();

    var polygon2 = try Polygon.init(allocator, &points2);
    defer polygon2.deinit();

    var polygon3 = try Polygon.init(allocator, &points3);
    defer polygon3.deinit();

    const stdout = std.io.getStdOut().writer();

    try stdout.print("polygon1: {}\n", .{polygon1});
    try stdout.print("polygon2: {}\n", .{polygon2});
    try stdout.print("polygon3: {}\n", .{polygon3});
    try stdout.print("\n", .{});

    try stdout.print("polygon1 and polygon2 overlap? {}\n", .{polygon1.overlaps(&polygon2)});
    try stdout.print("polygon1 and polygon3 overlap? {}\n", .{polygon1.overlaps(&polygon3)});
    try stdout.print("polygon2 and polygon3 overlap? {}\n", .{polygon2.overlaps(&polygon3)});
}
