const std = @import("std");
const print = std.debug.print;
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;
const Random = std.Random;

const Point = struct {
    coords: []f32,
    allocator: Allocator,

    const Self = @This();

    pub fn init(allocator: Allocator, coords: []const f32) !Self {
        const owned_coords = try allocator.dupe(f32, coords);
        return Self{
            .coords = owned_coords,
            .allocator = allocator,
        };
    }

    pub fn deinit(self: Self) void {
        self.allocator.free(self.coords);
    }

    pub fn clone(self: Self) !Self {
        return Self.init(self.allocator, self.coords);
    }

    pub fn sub(self: Self, other: Self, allocator: Allocator) !Point {
        std.debug.assert(self.coords.len == other.coords.len);
        const result_coords = try allocator.alloc(f32, self.coords.len);
        for (0..self.coords.len) |i| {
            result_coords[i] = self.coords[i] - other.coords[i];
        }
        return Point{
            .coords = result_coords,
            .allocator = allocator,
        };
    }

    pub fn normSq(self: Self) f32 {
        var sum: f32 = 0.0;
        for (self.coords) |coord| {
            sum += coord * coord;
        }
        return sum;
    }

    pub fn format(self: Self, comptime fmt: []const u8, options: std.fmt.FormatOptions, writer: anytype) !void {
        _ = fmt;
        _ = options;
        try writer.writeAll("[");
        for (self.coords, 0..) |coord, i| {
            if (i > 0) try writer.writeAll(", ");
            try writer.print("{d:.1}", .{coord});
        }
        try writer.writeAll("]");
    }
};

const KDTreeNode = struct {
    point: Point,
    dim: usize,
    left: ?*KDTreeNode,
    right: ?*KDTreeNode,
    allocator: Allocator,

    const Self = @This();

    pub fn init(allocator: Allocator, points: []Point, dim: usize) !*Self {
        const points_len = points.len;

        if (points_len == 1) {
            const node = try allocator.create(Self);
            node.* = Self{
                .point = try points[0].clone(),
                .dim = dim,
                .left = null,
                .right = null,
                .allocator = allocator,
            };
            return node;
        }

        // Split around the median
        const pivot = try quickselectBy(points, points_len / 2, dim, allocator);

        const left = if (points_len >= 2)
            try Self.init(allocator, points[0..points_len / 2], (dim + 1) % pivot.coords.len)
        else
            null;

        const right = if (points_len >= 3)
            try Self.init(allocator, points[points_len / 2 + 1..points_len], (dim + 1) % pivot.coords.len)
        else
            null;

        const node = try allocator.create(Self);
        node.* = Self{
            .point = pivot,
            .dim = dim,
            .left = left,
            .right = right,
            .allocator = allocator,
        };
        return node;
    }

    pub fn deinit(self: *Self) void {
        self.point.deinit();
        if (self.left) |left| {
            left.deinit();
            self.allocator.destroy(left);
        }
        if (self.right) |right| {
            right.deinit();
            self.allocator.destroy(right);
        }
    }

    pub fn findNearestNeighbor(self: *const Self, point: Point, allocator: Allocator) !struct { point: Point, n_visited: usize } {
        const diff = try point.sub(self.point, allocator);
        defer diff.deinit();
        const initial_dist_sq = diff.normSq();

        const result = try self.findNearestNeighborHelper(point, self.point, initial_dist_sq, 1, allocator);
        return .{ .point = try result.point.clone(), .n_visited = result.n_visited };
    }

    fn findNearestNeighborHelper(
        self: *const Self,
        point: Point,
        best: Point,
        best_dist_sq: f32,
        n_visited: usize,
        allocator: Allocator,
    ) !struct { point: Point, n_visited: usize } {
        var my_best = best;
        var my_best_dist_sq = best_dist_sq;
        var my_n_visited = n_visited;

        // Examine the near side first
        if (self.point.coords[self.dim] < point.coords[self.dim] and self.right != null) {
            const result = try self.right.?.findNearestNeighborHelper(
                point, my_best, my_best_dist_sq, my_n_visited, allocator
            );
            my_best = result.point;
            my_n_visited = result.n_visited;
        } else if (self.left != null) {
            const result = try self.left.?.findNearestNeighborHelper(
                point, my_best, my_best_dist_sq, my_n_visited, allocator
            );
            my_best = result.point;
            my_n_visited = result.n_visited;
        }

        // Distance along this node's axis
        const axis_dist_sq = std.math.pow(f32, self.point.coords[self.dim] - point.coords[self.dim], 2);
        if (axis_dist_sq <= my_best_dist_sq) {
            // Check if this node is closer than current best
            const self_diff = try point.sub(self.point, allocator);
            defer self_diff.deinit();
            const self_dist_sq = self_diff.normSq();

            if (self_dist_sq < my_best_dist_sq) {
                my_best = self.point;
                my_best_dist_sq = self_dist_sq;
            }

            my_n_visited += 1;

            // Check the far side of the split
            if (self.point.coords[self.dim] < point.coords[self.dim] and self.left != null) {
                const result = try self.left.?.findNearestNeighborHelper(
                    point, my_best, my_best_dist_sq, my_n_visited, allocator
                );
                my_best = result.point;
                my_n_visited = result.n_visited;
            } else if (self.right != null) {
                const result = try self.right.?.findNearestNeighborHelper(
                    point, my_best, my_best_dist_sq, my_n_visited, allocator
                );
                my_best = result.point;
                my_n_visited = result.n_visited;
            }
        }

        return .{ .point = my_best, .n_visited = my_n_visited };
    }
};

fn quickselectBy(arr: []Point, position: usize, dim: usize, allocator: Allocator) !Point {
    if (arr.len == 1) return try arr[0].clone();

    var rng = std.Random.DefaultPrng.init(@intCast(std.time.timestamp()));
    const random = rng.random();

    var pivot_index = random.uintLessThan(usize, arr.len);
    pivot_index = partitionBy(arr, pivot_index, dim);

    const array_len = arr.len;
    if (position == pivot_index) {
        return try arr[position].clone();
    } else if (position < pivot_index) {
        return quickselectBy(arr[0..pivot_index], position, dim, allocator);
    } else {
        return quickselectBy(arr[pivot_index + 1..array_len], position - pivot_index - 1, dim, allocator);
    }
}

fn partitionBy(arr: []Point, pivot_index: usize, dim: usize) usize {
    const array_len = arr.len;
    std.mem.swap(Point, &arr[pivot_index], &arr[array_len - 1]);
    var store_index: usize = 0;

    for (0..array_len - 1) |i| {
        if (arr[i].coords[dim] < arr[array_len - 1].coords[dim]) {
            std.mem.swap(Point, &arr[i], &arr[store_index]);
            store_index += 1;
        }
    }
    std.mem.swap(Point, &arr[array_len - 1], &arr[store_index]);
    return store_index;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var rng = std.Random.DefaultPrng.init(@intCast(std.time.timestamp()));
    const random = rng.random();

    // Wikipedia example
    const wp_coords = [_][]const f32{
        &[_]f32{ 2.0, 3.0 },
        &[_]f32{ 5.0, 4.0 },
        &[_]f32{ 9.0, 6.0 },
        &[_]f32{ 4.0, 7.0 },
        &[_]f32{ 8.0, 1.0 },
        &[_]f32{ 7.0, 2.0 },
    };

    var wp_points = ArrayList(Point).init(allocator);
    defer {
        for (wp_points.items) |point| {
            point.deinit();
        }
        wp_points.deinit();
    }

    for (wp_coords) |coords| {
        try wp_points.append(try Point.init(allocator, coords));
    }

    const wp_tree = try KDTreeNode.init(allocator, wp_points.items, 0);
    defer {
        wp_tree.deinit();
        allocator.destroy(wp_tree);
    }

    const wp_target = try Point.init(allocator, &[_]f32{ 9.0, 2.0 });
    defer wp_target.deinit();

    const wp_result = try wp_tree.findNearestNeighbor(wp_target, allocator);
    defer wp_result.point.deinit();

    const wp_diff = try wp_result.point.sub(wp_target, allocator);
    defer wp_diff.deinit();

    print("Wikipedia example data:\n", .{});
    print("Point: {}\n", .{wp_target});
    print("Nearest neighbor: {}\n", .{wp_result.point});
    print("Distance: {d:.6}\n", .{@sqrt(wp_diff.normSq())});
    print("Nodes visited: {}\n", .{wp_result.n_visited});

    // Randomly generated 3D points
    const n_random = 1000;
    var random_points = ArrayList(Point).init(allocator);
    defer {
        for (random_points.items) |point| {
            point.deinit();
        }
        random_points.deinit();
    }

    for (0..n_random) |_| {
        const coords = [_]f32{
            (random.float(f32) - 0.5) * 1000.0,
            (random.float(f32) - 0.5) * 1000.0,
            (random.float(f32) - 0.5) * 1000.0,
        };
        try random_points.append(try Point.init(allocator, &coords));
    }

    const start_cons_time = std.time.nanoTimestamp();
    const random_tree = try KDTreeNode.init(allocator, random_points.items, 0);
    const cons_time = std.time.nanoTimestamp() - start_cons_time;
    defer {
        random_tree.deinit();
        allocator.destroy(random_tree);
    }

    print("1,000 3d points (Construction time: {}ms)\n", .{@divTrunc(cons_time, 1_000_000)});

    const random_target_coords = [_]f32{
        (random.float(f32) - 0.5) * 1000.0,
        (random.float(f32) - 0.5) * 1000.0,
        (random.float(f32) - 0.5) * 1000.0,
    };
    const random_target = try Point.init(allocator, &random_target_coords);
    defer random_target.deinit();

    const random_result = try random_tree.findNearestNeighbor(random_target, allocator);
    defer random_result.point.deinit();

    const random_diff = try random_result.point.sub(random_target, allocator);
    defer random_diff.deinit();

    print("Point: {}\n", .{random_target});
    print("Nearest neighbor: {}\n", .{random_result.point});
    print("Distance: {d:.6}\n", .{@sqrt(random_diff.normSq())});
    print("Nodes visited: {}\n", .{random_result.n_visited});

    // Benchmark search time
    const n_searches = 1000;
    var random_targets = ArrayList(Point).init(allocator);
    defer {
        for (random_targets.items) |point| {
            point.deinit();
        }
        random_targets.deinit();
    }

    for (0..n_searches) |_| {
        const coords = [_]f32{
            (random.float(f32) - 0.5) * 1000.0,
            (random.float(f32) - 0.5) * 1000.0,
            (random.float(f32) - 0.5) * 1000.0,
        };
        try random_targets.append(try Point.init(allocator, &coords));
    }

    const start_search_time = std.time.nanoTimestamp();
    var total_n_visited: usize = 0;
    for (random_targets.items) |target| {
        const result = try random_tree.findNearestNeighbor(target, allocator);
        defer result.point.deinit();
        total_n_visited += result.n_visited;
    }
    const search_time = std.time.nanoTimestamp() - start_search_time;

    print("Visited an average of {d:.1} nodes on {} searches in {} ms\n", .{
        @as(f32, @floatFromInt(total_n_visited)) / @as(f32, @floatFromInt(n_searches)),
        n_searches,
        @divTrunc(search_time, 1_000_000),
    });
}
