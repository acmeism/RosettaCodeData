const std = @import("std");
const ArrayList = std.ArrayList;
const print = std.debug.print;

const Vec = struct {
    x: i32,
    y: i32,

    pub fn sum_sq(v: Vec) i32 {
        return v.x * v.x + v.y * v.y;
    }

    pub fn add(a: Vec, b: Vec) Vec {
        return .{
            .x = a.x + b.x,
            .y = a.y + b.y,
        };
    }
    pub fn atan(v: Vec) f32 {
        const x: f32 = @floatFromInt(v.x);
        const y: f32 = @floatFromInt(v.y);
        return std.math.atan2(x, y);
    }

    pub fn lessThan(ctx: void, a: Vec, b: Vec) std.math.Order {
        _ = ctx;
        return std.math.order(a.sum_sq(), b.sum_sq());
    }
};

pub fn add_candidates(candidates: *ArrayList(Vec), base: Vec) !void {
    const i = base.x;
    const j = base.y;
    const candidate_steps = [_]Vec{
        .{ .x = i, .y = j },
        .{ .x = -i, .y = j },
        .{ .x = i, .y = -j },
        .{ .x = -i, .y = -j },
        .{ .y = i, .x = j },
        .{ .y = -i, .x = j },
        .{ .y = i, .x = -j },
        .{ .y = -i, .x = -j },
    };
    try candidates.appendSlice(&candidate_steps);
}

pub fn babylonian_spiral(n_points: usize, allocator: std.mem.Allocator) !ArrayList(Vec) {
    const tau: f32 = std.math.tau;

    var queue = std.PriorityQueue(Vec, void, Vec.lessThan).init(allocator, {});
    defer queue.deinit();
    try queue.add(.{ .x = 1, .y = 1 });

    var point = Vec{ .x = 0, .y = 1 };
    var last = Vec{ .x = 0, .y = 1 };
    var last_angle = last.atan();

    var points = ArrayList(Vec).init(allocator);
    try points.ensureUnusedCapacity(n_points);
    points.appendAssumeCapacity(.{ .x = 0, .y = 0 });
    points.appendAssumeCapacity(.{ .x = 0, .y = 1 });

    var candidates = ArrayList(Vec).init(allocator);
    defer candidates.deinit();

    var sum_sq: i32 = 1;
    var loaded: i32 = 1;
    var count: usize = 2;
    while (count < n_points) : (count += 1) {
        if (loaded * loaded < sum_sq + 1) {
            loaded += 1;
            var y: i32 = 0;
            while (y <= loaded) : (y += 1) {
                try queue.add(.{ .x = loaded, .y = y });
            }
        }
        var base = queue.remove();
        try add_candidates(&candidates, base);

        sum_sq = base.sum_sq();
        while (queue.peek().?.sum_sq() == sum_sq) {
            base = queue.remove();
            try add_candidates(&candidates, base);
        }
        var min = candidates.items[0];
        var min_angle = min.atan() - last_angle;
        if (min_angle < 0) min_angle += tau;
        for (candidates.items[1..]) |step| {
            var angle = step.atan() - last_angle;
            if (angle < 0) angle += tau;
            if (angle < min_angle) {
                min = step;
                min_angle = angle;
            }
        }
        point = point.add(min);
        points.appendAssumeCapacity(point);
        last = min;
        last_angle = min.atan();
        candidates.clearRetainingCapacity();
    }
    return points;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var points = try babylonian_spiral(10_000, allocator);
    defer points.deinit();
    print("The first 40 Babylonian spiral points are:\n", .{});
    for (points.items[0..40], 0..) |p, n| {
        print("({},{}) ", .{ p.x, p.y });
        if (n % 10 == 9) {
            print("\n", .{});
        }
    }

    const file = try std.fs.cwd().createFile("babylonian_spiral.svg", .{});
    defer file.close();

    var buffered_writer = std.io.bufferedWriter(file.writer());
    defer {
        buffered_writer.flush() catch {
            print("Failed to flush buffer to file", .{});
        };
    }
    var w = buffered_writer.writer();

    var min_xi: i32 = 0;
    var max_xi: i32 = 0;
    var min_yi: i32 = 0;
    var max_yi: i32 = 0;
    for (points.items) |p| {
        if (min_xi > p.x) min_xi = p.x;
        if (min_yi > p.y) min_yi = p.y;
        if (max_xi < p.x) max_xi = p.x;
        if (max_yi < p.y) max_yi = p.y;
    }
    const min_x: f32 = @floatFromInt(min_xi);
    const min_y: f32 = @floatFromInt(min_yi);
    const max_x: f32 = @floatFromInt(max_xi);
    const max_y: f32 = @floatFromInt(max_yi);
    const width = max_x - min_x;
    const height = max_y - min_y;
    const view_width: u32 = 1000;
    const view_height: u32 = 1000;

    try w.print(
        \\<svg viewBox="0 0 {} {}" xmlns="http://www.w3.org/2000/svg">
        \\<polyline fill="none" stroke="black" points="
    , .{ view_width, view_height });

    for (points.items) |p| {
        const x = (@as(f32, @floatFromInt(p.x)) - min_x) * view_width / width;
        const y = (@as(f32, @floatFromInt(p.y)) - min_y) * view_height / height;
        try w.print("{d:.0},{d:.0} ", .{ x, view_height - y });
    }

    try w.print("{s}", .{"\"/></svg>"});
}
