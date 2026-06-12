const std = @import("std");
const Random = std.Random;
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

const Point = struct {
    x: f64,
    y: f64,

    pub fn new(x: f64, y: f64) Point {
        return Point{ .x = x, .y = y };
    }
};

const Circle = struct {
    centre: Point,
    radius: f64,

    pub fn new(centre: Point, radius: f64) Circle {
        return Circle{ .centre = centre, .radius = radius };
    }
};

fn distance(a: *const Point, b: *const Point) f64 {
    const dx = a.x - b.x;
    const dy = a.y - b.y;
    return @sqrt(dx * dx + dy * dy);
}

fn encloses(point: *const Point, circle: *const Circle) bool {
    return distance(point, &circle.centre) <= circle.radius;
}

fn circleFromTwoPoints(a: *const Point, b: *const Point) Circle {
    const centre = Point.new((a.x + b.x) / 2.0, (a.y + b.y) / 2.0);
    return Circle.new(centre, distance(a, b) / 2.0);
}

fn circleFromThreePoints(a: *const Point, b: *const Point, c: *const Point) Circle {
    const ba = Point.new(b.x - a.x, b.y - a.y);
    const ca = Point.new(c.x - a.x, c.y - a.y);
    const bb = ba.x * ba.x + ba.y * ba.y;
    const cc = ca.x * ca.x + ca.y * ca.y;
    const dd = (ba.x * ca.y - ba.y * ca.x) * 2.0;
    const centre = Point.new(
        (ca.y * bb - ba.y * cc) / dd + a.x,
        (ba.x * cc - ca.x * bb) / dd + a.y,
    );
    return Circle.new(centre, distance(&centre, a));
}

const WelzlError = error{
    TooManyPointsOnBoundary,
    OutOfMemory,
};

fn smallestEnclosingCircle(points: []const Point) WelzlError!Circle {
    switch (points.len) {
        0 => return Circle.new(Point.new(0.0, 0.0), 0.0),
        1 => return Circle.new(points[0], 0.0),
        2 => return circleFromTwoPoints(&points[0], &points[1]),
        3 => return circleFromThreePoints(&points[0], &points[1], &points[2]),
        else => return WelzlError.TooManyPointsOnBoundary,
    }
}

fn welzlRecursive(allocator: Allocator, points: ArrayList(Point), boundary: ArrayList(Point)) WelzlError!Circle {
    // Base case occurs when all the points have been processed
    // or the smallest enclosing circle boundary is specified by three points
    if (points.items.len == 0 or boundary.items.len == 3) {
        return smallestEnclosingCircle(boundary.items);
    }

    // Choose a random point from the given 'points', since 'points' has already been shuffled
    var points_copy = points;
    const point = points_copy.pop().?; // Use .? to unwrap the optional

    // Recurse with the chosen point removed
    const candidate = try welzlRecursive(allocator, points_copy, boundary);

    if (encloses(&point, &candidate)) {
        return candidate;
    }

    // Otherwise, 'point' must be on the boundary of the smallest enclosing circle
    var new_boundary = ArrayList(Point).init(allocator);
    defer new_boundary.deinit();

    try new_boundary.appendSlice(boundary.items);
    try new_boundary.append(point);

    // Recurse with the chosen point removed from 'points' and added to the 'boundary'
    return welzlRecursive(allocator, points_copy, new_boundary);
}

// Return the smallest enclosing circle using Welzl's algorithm
fn welzl(allocator: Allocator, points: []const Point) WelzlError!Circle {
    var points_copy = ArrayList(Point).init(allocator);
    defer points_copy.deinit();

    try points_copy.appendSlice(points);

    // Shuffle the points
    var prng = std.Random.DefaultPrng.init(@as(u64, @intCast(std.time.milliTimestamp())));
    const random = prng.random();
    random.shuffle(Point, points_copy.items);

    var boundary = ArrayList(Point).init(allocator);
    defer boundary.deinit();

    return welzlRecursive(allocator, points_copy, boundary);
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const tests = [_][]const Point{
        &[_]Point{
            Point.new(0.0, 0.0),
            Point.new(0.0, 1.0),
            Point.new(1.0, 0.0),
        },
        &[_]Point{
            Point.new(5.0, -2.0),
            Point.new(-3.0, -2.0),
            Point.new(-2.0, 5.0),
            Point.new(1.0, 6.0),
            Point.new(0.0, 2.0),
        },
        &[_]Point{
            Point.new(0.0, 0.0),
            Point.new(-2.0, -1.0),
            Point.new(3.0, -4.0),
            Point.new(2.0, 8.0),
            Point.new(3.0, 11.0),
            Point.new(-8.0, -2.0),
            Point.new(-14.0, -6.0),
            Point.new(7.0, 3.0),
            Point.new(10.0, 4.0),
            Point.new(-1.0, 4.0),
        },
    };

    for (tests) |my_test| {
        const circle = try welzl(allocator, my_test);
        std.debug.print("Centre: ({d}, {d}), Radius: {d}\n", .{ circle.centre.x, circle.centre.y, circle.radius });
    }
}
