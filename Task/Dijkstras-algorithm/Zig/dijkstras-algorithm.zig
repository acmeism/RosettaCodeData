const std = @import("std");

// ───────── data types ─────────
const Edge = struct {
    vertex: usize,
    weight: i32,
};

const Vertex = struct {
    edges   : std.ArrayList(Edge),
    dist    : i32           = std.math.maxInt(i32),
    prev    : usize         = 0,
    visited : bool          = false,

    fn init(alloc: std.mem.Allocator) Vertex {
        return .{ .edges = std.ArrayList(Edge).init(alloc) };
    }
};

const Graph = struct {
    verts : std.ArrayList(?*Vertex),

    fn init(alloc: std.mem.Allocator) Graph {
        return .{ .verts = std.ArrayList(?*Vertex).init(alloc) };
    }

    fn ensureVertex(self: *Graph, alloc: std.mem.Allocator, idx: usize) !void {
        if (idx >= self.verts.items.len) {
            const old_len = self.verts.items.len;
            try self.verts.resize(idx + 1);     // grow list
            // set all freshly‑appended slots to null
            for (self.verts.items[old_len..]) |*p| p.* = null;
        }

        if (self.verts.items[idx] == null) {
            const vp = try alloc.create(Vertex);
            vp.* = Vertex.init(alloc);
            self.verts.items[idx] = vp;
        }
    }

    fn addEdge(self: *Graph, alloc: std.mem.Allocator,
               a: u8, b: u8, w: i32) !void {
        const ai = a - 'a';
        const bi = b - 'a';

        try self.ensureVertex(alloc, ai);
        try self.ensureVertex(alloc, bi);

        try self.verts.items[ai].?.edges.append(.{ .vertex = bi, .weight = w });
    }

    fn deinit(self: *Graph, alloc: std.mem.Allocator) void {
        for (self.verts.items) |maybe_v| {
            if (maybe_v) |v| {
                v.edges.deinit();
                alloc.destroy(v);
            }
        }
        self.verts.deinit();
    }
};

// ───────── Dijkstra ─────────
fn compare(g: *Graph, a: usize, b: usize) std.math.Order {
    const da = g.verts.items[a].?.dist;
    const db = g.verts.items[b].?.dist;
    return if (da < db) .lt else if (da > db) .gt else .eq;
}

fn dijkstra(g: *Graph, alloc: std.mem.Allocator, src: u8, dst: u8) !void {
    const src_i = src - 'a';
    const dst_i = dst - 'a';

    // reset
    for (g.verts.items) |maybe_v| {
        if (maybe_v) |v| {
            v.dist    = std.math.maxInt(i32);
            v.prev    = 0;
            v.visited = false;
        }
    }

    var pq = std.PriorityQueue(usize, *Graph, compare).init(alloc, g);
    defer pq.deinit();

    g.verts.items[src_i].?.dist = 0;
    try pq.add(src_i);

    while (pq.removeOrNull()) |u_i| {
        if (u_i == dst_i) break;

        var u = g.verts.items[u_i].?;
        if (u.visited) continue;
        u.visited = true;

        for (u.edges.items) |e| {
            var v = g.verts.items[e.vertex].?;
            if (v.visited) continue;

            const alt = u.dist + e.weight;
            if (alt < v.dist) {
                v.dist = alt;
                v.prev = u_i;
                try pq.add(e.vertex);           // duplicates ok
            }
        }
    }
}

// ───────── output ─────────
fn printPath(g: *Graph, dst: u8) void {
    const dst_i = dst - 'a';
    const v = g.verts.items[dst_i].?;

    if (v.dist == std.math.maxInt(i32)) {
        std.debug.print("no path\n", .{});
        return;
    }

    var buf: [26]u8 = undefined;
    var n: usize = 0;
    var cur: usize = dst_i;
    while (true) {
        buf[n] = @as(u8, @intCast(cur)) + 'a';
        n += 1;
        if (g.verts.items[cur].?.dist == 0) break;
        cur = g.verts.items[cur].?.prev;
    }

    std.debug.print("{} ", .{v.dist});
    var i: isize = @as(isize, @intCast(n)) - 1;
    while (i >= 0) : (i -= 1) {
        std.debug.print("{c}", .{buf[@as(usize, @intCast(i))]});
    }
    std.debug.print("\n", .{});
}

// ───────── main ─────────
pub fn main() !void {
    const alloc = std.heap.page_allocator;

    var g = Graph.init(alloc);
    defer g.deinit(alloc);

    try g.addEdge(alloc, 'a','b', 7);
    try g.addEdge(alloc, 'a','c', 9);
    try g.addEdge(alloc, 'a','f',14);
    try g.addEdge(alloc, 'b','c',10);
    try g.addEdge(alloc, 'b','d',15);
    try g.addEdge(alloc, 'c','d',11);
    try g.addEdge(alloc, 'c','f', 2);
    try g.addEdge(alloc, 'd','e', 6);
    try g.addEdge(alloc, 'e','f', 9);

    try dijkstra(&g, alloc, 'a', 'e');
    printPath(&g, 'e');
}
