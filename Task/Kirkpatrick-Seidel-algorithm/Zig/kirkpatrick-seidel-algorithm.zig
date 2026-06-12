const std = @import("std");
const math = std.math;
const Allocator = std.mem.Allocator;
const Random = std.Random;

const Point = struct {
    x: f64,
    y: f64,

    fn lessThan(_: void, a: Point, b: Point) bool {
        if (a.x == b.x) {
            return a.y < b.y;
        }
        return a.x < b.x;
    }

    fn eql(a: Point, b: Point) bool {
        return a.x == b.x and a.y == b.y;
    }
};

const PointPair = struct {
    p1: Point,
    p2: Point,
};

fn sortAndDedup(list: *std.ArrayList(Point)) void {
    std.sort.heap(Point, list.items, {}, Point.lessThan);
    if (list.items.len <= 1) return;
    var write: usize = 1;
    for (list.items[1..]) |item| {
        if (!Point.eql(list.items[write - 1], item)) {
            list.items[write] = item;
            write += 1;
        }
    }
    list.items.len = write;
}

fn quickSelectF64(rng: *Random, ls: []f64, index: usize, lo: usize, hi: ?usize) f64 {
    const high = hi orelse ls.len - 1;

    if (lo == high) return ls[lo];

    const pivot = lo + rng.intRangeAtMost(usize, 0, high - lo);
    std.mem.swap(f64, &ls[lo], &ls[pivot]);

    var cur = lo;
    var run = lo + 1;
    while (run <= high) : (run += 1) {
        if (ls[run] < ls[lo]) {
            cur += 1;
            std.mem.swap(f64, &ls[cur], &ls[run]);
        }
    }
    std.mem.swap(f64, &ls[cur], &ls[lo]);

    if (index < cur) {
        return quickSelectF64(rng, ls, index, lo, cur - 1);
    } else if (index > cur) {
        return quickSelectF64(rng, ls, index, cur + 1, high);
    }
    return ls[cur];
}

fn quickSelect(
    rng: *Random,
    ls: []Point,
    index: usize,
    lo: usize,
    hi: ?usize,
) Point {
    const high = hi orelse ls.len - 1;

    if (lo == high) return ls[lo];

    const pivot = lo + rng.intRangeAtMost(usize, 0, high - lo);
    std.mem.swap(Point, &ls[lo], &ls[pivot]);

    var cur = lo;
    var run = lo + 1;
    while (run <= high) : (run += 1) {
        if (Point.lessThan({}, ls[run], ls[lo])) {
            cur += 1;
            std.mem.swap(Point, &ls[cur], &ls[run]);
        }
    }
    std.mem.swap(Point, &ls[cur], &ls[lo]);

    if (index < cur) {
        return quickSelect(rng, ls, index, lo, cur - 1);
    } else if (index > cur) {
        return quickSelect(rng, ls, index, cur + 1, high);
    }
    return ls[cur];
}

fn bridge(
    arena: Allocator,
    rng: *Random,
    points: []const Point,
    vertical_line: f64,
) !PointPair {
    if (points.len == 2) {
        return if (Point.lessThan({}, points[0], points[1]))
            PointPair{ .p1 = points[0], .p2 = points[1] }
        else
            PointPair{ .p1 = points[1], .p2 = points[0] };
    }

    var candidates = try std.ArrayList(Point).initCapacity(arena, points.len);
    var pairs = try std.ArrayList(PointPair).initCapacity(arena, points.len / 2 + 1);

    // Pair up points by index — no orderedRemove needed
    var n: usize = 0;
    while (n + 1 < points.len) : (n += 2) {
        const p1 = points[n];
        const p2 = points[n + 1];
        if (Point.lessThan({}, p1, p2)) {
            try pairs.append(arena, PointPair{ .p1 = p1, .p2 = p2 });
        } else {
            try pairs.append(arena, PointPair{ .p1 = p2, .p2 = p1 });
        }
    }
    if (n < points.len) {
        try candidates.append(arena, points[n]);
    }

    var slopes = try std.ArrayList(f64).initCapacity(arena, pairs.items.len);

    var idx: usize = 0;
    while (idx < pairs.items.len) {
        const pair = pairs.items[idx];
        if (pair.p1.x == pair.p2.x) {
            try candidates.append(arena, if (pair.p1.y > pair.p2.y) pair.p1 else pair.p2);
            _ = pairs.swapRemove(idx);
        } else {
            try slopes.append(arena, (pair.p1.y - pair.p2.y) / (pair.p1.x - pair.p2.x));
            idx += 1;
        }
    }

    if (slopes.items.len == 0) {
        if (candidates.items.len >= 2) {
            return PointPair{ .p1 = candidates.items[0], .p2 = candidates.items[1] };
        }
        return PointPair{ .p1 = points[0], .p2 = points[1] };
    }

    const median_index = if (slopes.items.len % 2 == 0)
        slopes.items.len / 2 - 1
    else
        slopes.items.len / 2;

    const slopes_copy = try arena.dupe(f64, slopes.items);
    const median_slope = quickSelectF64(rng, slopes_copy, median_index, 0, null);

    var small = try std.ArrayList(PointPair).initCapacity(arena, pairs.items.len);
    var equal = try std.ArrayList(PointPair).initCapacity(arena, pairs.items.len);
    var large = try std.ArrayList(PointPair).initCapacity(arena, pairs.items.len);

    for (slopes.items, 0..) |slope, j| {
        if (slope < median_slope) {
            try small.append(arena, pairs.items[j]);
        } else if (math.approxEqAbs(f64, slope, median_slope, math.floatEps(f64))) {
            try equal.append(arena, pairs.items[j]);
        } else {
            try large.append(arena, pairs.items[j]);
        }
    }

    var max_slope = -math.inf(f64);
    for (points) |point| {
        max_slope = @max(max_slope, point.y - median_slope * point.x);
    }

    var left = Point{ .x = math.inf(f64), .y = -math.inf(f64) };
    var right = Point{ .x = -math.inf(f64), .y = -math.inf(f64) };

    for (points) |point| {
        if (math.approxEqAbs(f64, point.y - median_slope * point.x, max_slope, math.floatEps(f64))) {
            if (Point.lessThan({}, point, left)) left = point;
            if (Point.lessThan({}, right, point)) right = point;
        }
    }

    if (left.x <= vertical_line and right.x > vertical_line) {
        return PointPair{ .p1 = left, .p2 = right };
    }

    if (right.x <= vertical_line) {
        for (large.items) |pair| try candidates.append(arena, pair.p2);
        for (equal.items) |pair| try candidates.append(arena, pair.p2);
        for (small.items) |pair| {
            try candidates.append(arena, pair.p1);
            try candidates.append(arena, pair.p2);
        }
    }

    if (left.x > vertical_line) {
        for (small.items) |pair| try candidates.append(arena, pair.p1);
        for (equal.items) |pair| try candidates.append(arena, pair.p1);
        for (large.items) |pair| {
            try candidates.append(arena, pair.p1);
            try candidates.append(arena, pair.p2);
        }
    }

    sortAndDedup(&candidates);

    return bridge(arena, rng, candidates.items, vertical_line);
}

fn connect(
    arena: Allocator,
    rng: *Random,
    lower: Point,
    upper: Point,
    points: []const Point,
) ![]Point {
    if (Point.eql(lower, upper)) {
        const result = try arena.alloc(Point, 1);
        result[0] = lower;
        return result;
    }

    const mid_index = points.len / 2 - 1;

    // Single quickSelect — after partitioning, mid_index+1 is the min of the right half
    const points_copy = try arena.dupe(Point, points);
    const max_left = quickSelect(rng, points_copy, mid_index, 0, null);
    const min_right = points_copy[mid_index + 1];

    const br = try bridge(arena, rng, points, (max_left.x + min_right.x) / 2.0);
    const left = br.p1;
    const right = br.p2;

    var points_left = try std.ArrayList(Point).initCapacity(arena, points.len);
    var points_right = try std.ArrayList(Point).initCapacity(arena, points.len);

    for (points) |point| {
        if (point.x < left.x) {
            try points_left.append(arena, point);
        } else if (point.x > right.x) {
            try points_right.append(arena, point);
        }
    }

    sortAndDedup(&points_left);
    sortAndDedup(&points_right);

    const left_result = try connect(arena, rng, lower, left, points_left.items);
    const right_result = try connect(arena, rng, right, upper, points_right.items);

    const result = try arena.alloc(Point, left_result.len + right_result.len);
    @memcpy(result[0..left_result.len], left_result);
    @memcpy(result[left_result.len..], right_result);

    return result;
}

fn upperHull(
    arena: Allocator,
    rng: *Random,
    points: []const Point,
) ![]Point {
    // Find leftmost point (highest y if tied)
    var lower = points[0];
    for (points) |point| {
        if (point.x < lower.x or (point.x == lower.x and point.y > lower.y)) {
            lower = point;
        }
    }

    // Find rightmost point (highest y if tied)
    var upper = points[0];
    for (points) |point| {
        if (point.x > upper.x or (point.x == upper.x and point.y > upper.y)) {
            upper = point;
        }
    }

    var filtered = try std.ArrayList(Point).initCapacity(arena, points.len);
    try filtered.append(arena, lower);
    try filtered.append(arena, upper);

    for (points) |p| {
        if (lower.x < p.x and p.x < upper.x) {
            try filtered.append(arena, p);
        }
    }

    sortAndDedup(&filtered);

    return connect(arena, rng, lower, upper, filtered.items);
}

fn convexHull(
    arena: Allocator,
    rng: *Random,
    points: []const Point,
) ![]Point {
    const upper = try upperHull(arena, rng, points);

    // Flip points in-place for lower hull
    const flipped_pts = try arena.alloc(Point, points.len);
    for (points, 0..) |p, n| {
        flipped_pts[n] = .{ .x = -p.x, .y = -p.y };
    }

    const flipped_upper = try upperHull(arena, rng, flipped_pts);

    // Flip back
    const lower = try arena.alloc(Point, flipped_upper.len);
    for (flipped_upper, 0..) |p, n| {
        lower[n] = .{ .x = -p.x, .y = -p.y };
    }

    // Merge upper and lower, skipping duplicate endpoints
    var lower_start: usize = 0;
    var lower_end: usize = lower.len;

    if (upper.len > 0 and lower.len > 0 and Point.eql(upper[upper.len - 1], lower[0])) {
        lower_start = 1;
    }
    if (upper.len > 0 and lower.len > 0 and Point.eql(upper[0], lower[lower.len - 1])) {
        lower_end -= 1;
    }

    const lower_slice = lower[lower_start..lower_end];
    const result = try arena.alloc(Point, upper.len + lower_slice.len);
    @memcpy(result[0..upper.len], upper);
    @memcpy(result[upper.len..], lower_slice);

    return result;
}

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const arena = init.arena.allocator();

    var prng = std.Random.DefaultPrng.init(42);
    var rng = prng.random();

    var points = [_]Point{
        .{ .x = 0.0, .y = 0.0 },
        .{ .x = 1.0, .y = 0.0 },
        .{ .x = 0.0, .y = 1.0 },
        .{ .x = 0.5, .y = 0.5 },
    };
    std.sort.heap(Point, &points, {}, Point.lessThan);

    var stdout_writer = std.Io.File.stdout().writer(io, &.{});
    const stdout = &stdout_writer.interface;

    try stdout.writeAll("Input points:\n");
    for (&points) |p| {
        try stdout.print("({d}, {d})\n", .{ p.x, p.y });
    }

    const hull = try convexHull(arena, &rng, &points);

    try stdout.writeAll("\nConvex hull points:\n");
    for (hull) |p| {
        try stdout.print("({d}, {d})\n", .{ p.x, p.y });
    }
}
