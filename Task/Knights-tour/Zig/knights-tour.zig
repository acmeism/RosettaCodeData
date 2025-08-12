const std = @import("std");

const SIZE: usize = 8;
const MOVES = [_][2]i32{
    [_]i32{ 2, 1 },
    [_]i32{ 1, 2 },
    [_]i32{ -1, 2 },
    [_]i32{ -2, 1 },
    [_]i32{ -2, -1 },
    [_]i32{ -1, -2 },
    [_]i32{ 1, -2 },
    [_]i32{ 2, -1 },
};

const Point = struct {
    x: i32,
    y: i32,

    fn mov(self: Point, dir: [2]i32) Point {
        return .{
            .x = self.x + dir[0],
            .y = self.y + dir[1],
        };
    }
};

const Board = struct {
    field: [SIZE][SIZE]i32,

    fn init() Board {
        return .{
            .field = [_][SIZE]i32{[_]i32{0} ** SIZE} ** SIZE,
        };
    }

    fn available(self: *const Board, p: Point) bool {
        return 0 <= p.x and
            p.x < @as(i32, @intCast(SIZE)) and
            0 <= p.y and
            p.y < @as(i32, @intCast(SIZE)) and
            self.field[@as(usize, @intCast(p.x))][@as(usize, @intCast(p.y))] == 0;
    }

    // calculate the number of possible moves
    fn countDegree(self: *const Board, p: Point) i32 {
        var count: i32 = 0;
        for (MOVES) |dir| {
            const next = p.mov(dir);
            if (self.available(next)) {
                count += 1;
            }
        }
        return count;
    }

    fn format(
        self: *const Board,
        comptime fmt: []const u8,
        options: std.fmt.FormatOptions,
        writer: anytype,
    ) !void {
        _ = fmt;
        _ = options;

        for (self.field) |row| {
            for (row) |x| {
                try writer.print("{d:3} ", .{x});
            }
            try writer.writeByte('\n');
        }
    }
};

fn knightsTour(x: i32, y: i32) ?Board {
    var board = Board.init();
    var p = Point{ .x = x, .y = y };
    var step: i32 = 1;
    board.field[@as(usize, @intCast(p.x))][@as(usize, @intCast(p.y))] = step;
    step += 1;

    while (step <= @as(i32, @intCast(SIZE * SIZE))) {
        // choose next square by Warnsdorf's rule
        var candidates = std.ArrayList(struct { degree: i32, pos: Point }).init(std.heap.page_allocator);
        defer candidates.deinit();

        for (MOVES) |dir| {
            const adj = p.mov(dir);
            if (board.available(adj)) {
                const degree = board.countDegree(adj);
                candidates.append(.{ .degree = degree, .pos = adj }) catch unreachable;
            }
        }

        if (candidates.items.len == 0) {
            return null; // can't move
        }

        // Find minimum degree
        var min_idx: usize = 0;
        for (candidates.items, 0..) |candidate, i| {
            if (candidate.degree < candidates.items[min_idx].degree) {
                min_idx = i;
            }
        }

        // move to next square
        p = candidates.items[min_idx].pos;
        board.field[@as(usize, @intCast(p.x))][@as(usize, @intCast(p.y))] = step;
        step += 1;
    }

    return board;
}

pub fn main() !void {
    const x: i32 = 3;
    const y: i32 = 1;

    const stdout = std.io.getStdOut().writer();
    try stdout.print("Board size: {d}\n", .{SIZE});
    try stdout.print("Starting position: ({d}, {d})\n", .{ x, y });

    if (knightsTour(x, y)) |board| {
        try stdout.print("{}\n", .{board});
    } else {
        try stdout.print("Fail!\n", .{});
    }
}
