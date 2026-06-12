const std = @import("std");

const Point = struct {
    x: i32,
    y: i32,

    pub fn init(a: i32, b: i32) Point {
        return Point{ .x = a, .y = b };
    }

    pub fn equals(self: Point, other: Point) bool {
        return self.x == other.x and self.y == other.y;
    }

    pub fn add(self: Point, other: Point) Point {
        return Point.init(self.x + other.x, self.y + other.y);
    }
};

const Map = struct {
    m: [8][8]u8,
    w: i32,
    h: i32,

    pub fn init() Map {
        var map = Map{
            .m = undefined,
            .w = 8,
            .h = 8,
        };

        const t = [_][8]u8{
            [_]u8{0, 0, 0, 0, 0, 0, 0, 0},
            [_]u8{0, 0, 0, 0, 0, 0, 0, 0},
            [_]u8{0, 0, 0, 0, 1, 1, 1, 0},
            [_]u8{0, 0, 1, 0, 0, 0, 1, 0},
            [_]u8{0, 0, 1, 0, 0, 0, 1, 0},
            [_]u8{0, 0, 1, 1, 1, 1, 1, 0},
            [_]u8{0, 0, 0, 0, 0, 0, 0, 0},
            [_]u8{0, 0, 0, 0, 0, 0, 0, 0},
        };

        for (0..@as(usize, @intCast(map.h))) |r| {
            for (0..@as(usize, @intCast(map.w))) |s| {
                map.m[s][r] = t[r][s];
            }
        }

        return map;
    }

    pub fn get(self: Map, x: i32, y: i32) u8 {
        return self.m[@as(usize, @intCast(x))][@as(usize, @intCast(y))];
    }
};

const Node = struct {
    pos: Point,
    parent: Point,
    dist: i32,
    cost: i32,

    pub fn equals(self: Node, other: Node) bool {
        return self.pos.equals(other.pos);
    }

    pub fn equalsPoint(self: Node, p: Point) bool {
        return self.pos.equals(p);
    }

    pub fn lessThan(self: Node, other: Node) bool {
        return (self.dist + self.cost) < (other.dist + other.cost);
    }
};

const AStar = struct {
    m: Map,
    end: Point,
    start: Point,
    neighbours: [8]Point,
    open: std.ArrayList(Node),
    closed: std.ArrayList(Node),
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator) AStar {
        return AStar{
            .m = undefined,
            .end = undefined,
            .start = undefined,
            .neighbours = [_]Point{
                Point.init(-1, -1), Point.init(1, -1),
                Point.init(-1, 1), Point.init(1, 1),
                Point.init(0, -1), Point.init(-1, 0),
                Point.init(0, 1), Point.init(1, 0),
            },
            .open = std.ArrayList(Node).init(allocator),
            .closed = std.ArrayList(Node).init(allocator),
            .allocator = allocator,
        };
    }

    pub fn deinit(self: *AStar) void {
        self.open.deinit();
        self.closed.deinit();
    }

    pub fn calcDist(self: AStar, p: Point) i32 {
        // need a better heuristic
        const x = self.end.x - p.x;
        const y = self.end.y - p.y;
        return (x * x + y * y);
    }

    pub fn isValid(self: AStar, p: Point) bool {
        return (p.x > -1 and p.y > -1 and p.x < self.m.w and p.y < self.m.h);
    }

    pub fn existPoint(self: *AStar, p: Point, cost: i32) !bool {
        // Check in closed list
        for (self.closed.items, 0..) |node, i| {
            if (node.equalsPoint(p)) {
                if (node.cost + node.dist < cost) {
                    return true;
                } else {
                    _ = self.closed.orderedRemove(i);
                    return false;
                }
            }
        }

        // Check in open list
        for (self.open.items, 0..) |node, i| {
            if (node.equalsPoint(p)) {
                if (node.cost + node.dist < cost) {
                    return true;
                } else {
                    _ = self.open.orderedRemove(i);
                    return false;
                }
            }
        }

        return false;
    }

    pub fn fillOpen(self: *AStar, n: Node) !bool {
        for (0..8) |x| {
            // one can make diagonals have different cost
            const stepCost: i32 = if (x < 4) 1 else 1;
            const neighbour = n.pos.add(self.neighbours[x]);

            if (neighbour.equals(self.end)) {
                return true;
            }

            if (self.isValid(neighbour) and self.m.get(neighbour.x, neighbour.y) != 1) {
                const nc = stepCost + n.cost;
                const dist = self.calcDist(neighbour);

                if (!(try self.existPoint(neighbour, nc + dist))) {
                    const m = Node{
                        .cost = nc,
                        .dist = dist,
                        .pos = neighbour,
                        .parent = n.pos,
                    };
                    try self.open.append(m);
                }
            }
        }

        return false;
    }

    fn nodeLessThan(_: void, a: Node, b: Node) bool {
        return a.lessThan(b);
    }

    pub fn search(self: *AStar, s: Point, e: Point, mp: Map) !bool {
        self.end = e;
        self.start = s;
        self.m = mp;

        // Clear lists
        self.open.clearRetainingCapacity();
        self.closed.clearRetainingCapacity();

        const n = Node{
            .cost = 0,
            .pos = s,
            .parent = Point.init(0, 0),
            .dist = self.calcDist(s),
        };

        try self.open.append(n);

        while (self.open.items.len > 0) {
            // Sort open list by cost + dist
            std.sort.pdq(Node, self.open.items, {}, AStar.nodeLessThan);

            const node = self.open.orderedRemove(0);
            try self.closed.append(node);

            if (try self.fillOpen(node)) {
                return true;
            }
        }

        return false;
    }

    pub fn path(self: *AStar, pathList: *std.ArrayList(Point)) !i32 {
        try pathList.insert(0, self.end);

        const cost = 1 + self.closed.items[self.closed.items.len - 1].cost;
        try pathList.insert(0, self.closed.items[self.closed.items.len - 1].pos);

        var parent = self.closed.items[self.closed.items.len - 1].parent;

        var i = self.closed.items.len;
        while (i > 0) {
            i -= 1;
            if (self.closed.items[i].pos.equals(parent) and !self.closed.items[i].pos.equals(self.start)) {
                try pathList.insert(0, self.closed.items[i].pos);
                parent = self.closed.items[i].parent;
            }
        }

        try pathList.insert(0, self.start);
        return cost;
    }
};

fn inPath(path: std.ArrayList(Point), p: Point) bool {
    for (path.items) |point| {
        if (point.equals(p)) {
            return true;
        }
    }
    return false;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    var m = Map.init();
    const s = Point.init(0, 0);
    const e = Point.init(7, 7);
    var as = AStar.init(allocator);
    defer as.deinit();

    if (try as.search(s, e, m)) {
        var path = std.ArrayList(Point).init(allocator);
        defer path.deinit();

        const c = try as.path(&path);

        const stdout = std.io.getStdOut().writer();

        for (0..9) |y_usize| {
            const y = @as(i32, @intCast(y_usize)) - 1;
            for (0..9) |x_usize| {
                const x = @as(i32, @intCast(x_usize)) - 1;

                if (x < 0 or y < 0 or x > 7 or y > 7 or m.get(x, y) == 1) {
                    try stdout.print("█", .{});
                } else {
                    if (inPath(path, Point.init(x, y))) {
                        try stdout.print("x", .{});
                    } else {
                        try stdout.print(".", .{});
                    }
                }
            }
            try stdout.print("\n", .{});
        }

        try stdout.print("\nPath cost {d}: ", .{c});
        for (path.items) |p| {
            try stdout.print("({d}, {d}) ", .{p.x, p.y});
        }
    }

    try std.io.getStdOut().writer().print("\n\n", .{});
}
