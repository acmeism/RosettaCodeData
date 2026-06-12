const std = @import("std");
const print = std.debug.print;
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

// Direction constants
const Direction = enum(u8) {
    E = 0,
    N = 1,
    W = 2,
    S = 3,
};

// Coordinate pair structure
const Coord = struct {
    x: usize,
    y: usize,
};

// X generates coordinate pairs for a grid of given dimensions
fn x(allocator: Allocator, a: usize, b: usize) !ArrayList(Coord) {
    var coords = ArrayList(Coord).init(allocator);

    var aa: usize = 0;
    while (aa <= a) : (aa += 1) {
        var bb: usize = 0;
        while (bb <= b) : (bb += 1) {
            try coords.append(Coord{ .x = aa, .y = bb });
        }
    }

    return coords;
}

// any checks if any element in the slice equals val
fn any(arr: []const i32, val: i32) bool {
    for (arr) |v| {
        if (v == val) return true;
    }
    return false;
}

// Result structure for identify_perimeter
const PerimeterResult = struct {
    x: usize,
    y: i32,
    path: ArrayList(u8),
};

// identify_perimeter identifies the perimeter of a shape in a 2D matrix
fn identify_perimeter(allocator: Allocator, data: []const []const i32) !PerimeterResult {
    const coords = try x(allocator, data[0].len - 1, data.len - 1);
    defer coords.deinit();

    for (coords.items) |coord| {
        const coord_x = coord.x;
        const coord_y = coord.y;

        if (coord_y < data.len and coord_x < data[0].len and data[coord_y][coord_x] != 0) {
            var path = ArrayList(u8).init(allocator);
            var cx = coord_x;
            var cy = coord_y;
            var d = Direction.E;
            var p = Direction.E;

            while (true) {
                var mask: i32 = 0;

                // Check 2x2 neighborhood
                const offsets = [_]struct { dx: usize, dy: usize, b: i32 }{
                    .{ .dx = 0, .dy = 0, .b = 1 },
                    .{ .dx = 1, .dy = 0, .b = 2 },
                    .{ .dx = 0, .dy = 1, .b = 4 },
                    .{ .dx = 1, .dy = 1, .b = 8 },
                };

                for (offsets) |offset| {
                    const mx = cx + offset.dx;
                    const my = cy + offset.dy;

                    if (mx > 0 and my > 0 and my - 1 < data.len and mx - 1 < data[0].len and
                        data[my - 1][mx - 1] != 0)
                    {
                        mask += offset.b;
                    }
                }

                // Determine direction based on mask
                if (any(&[_]i32{ 1, 5, 13 }, mask)) {
                    d = Direction.N;
                }
                if (any(&[_]i32{ 2, 3, 7 }, mask)) {
                    d = Direction.E;
                }
                if (any(&[_]i32{ 4, 12, 14 }, mask)) {
                    d = Direction.W;
                }
                if (any(&[_]i32{ 8, 10, 11 }, mask)) {
                    d = Direction.S;
                }
                if (mask == 6) {
                    if (p == Direction.N) {
                        d = Direction.W;
                    } else {
                        d = Direction.E;
                    }
                }
                if (mask == 9) {
                    if (p == Direction.E) {
                        d = Direction.N;
                    } else {
                        d = Direction.S;
                    }
                }

                // Add direction character to path
                const dir_chars = [_]u8{ 'E', 'N', 'W', 'S' };
                try path.append(dir_chars[@intFromEnum(d)]);
                p = d;

                // Move in the determined direction
                const dx_vals = [_]i32{ 1, 0, -1, 0 };
                const dy_vals = [_]i32{ 0, -1, 0, 1 };

                const new_cx = @as(i32, @intCast(cx)) + dx_vals[@intFromEnum(d)];
                const new_cy = @as(i32, @intCast(cy)) + dy_vals[@intFromEnum(d)];

                cx = @as(usize, @intCast(new_cx));
                cy = @as(usize, @intCast(new_cy));

                // Check if we've returned to starting position
                if (cx == coord_x and cy == coord_y) {
                    break;
                }
            }

            return PerimeterResult{
                .x = coord_x,
                .y = -@as(i32, @intCast(coord_y)),
                .path = path,
            };
        }
    }

    print("That did not work out...\n" , .{});
    std.process.exit(1);
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const m = [_][]const i32{
        &[_]i32{ 0, 0, 0, 0, 0 },
        &[_]i32{ 0, 0, 0, 0, 0 },
        &[_]i32{ 0, 0, 1, 1, 0 },
        &[_]i32{ 0, 0, 1, 1, 0 },
        &[_]i32{ 0, 0, 0, 1, 0 },
        &[_]i32{ 0, 0, 0, 0, 0 },
    };

    const result = try identify_perimeter(allocator, &m);
    defer result.path.deinit();

    print("X: {}, Y: {}, Path: {s}\n", .{ result.x, result.y, result.path.items });
}
