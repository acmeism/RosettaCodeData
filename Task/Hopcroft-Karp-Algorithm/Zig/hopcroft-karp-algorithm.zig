const std = @import("std");

/// Representation of a bipartite graph.
/// Vertices in the left partition, U, are numbered from 1 to m,
/// and vertices in the right partition, V, are numbered 1 to n.
const BipartiteGraph = struct {
    adjacency_lists: std.ArrayList(std.ArrayList(u32)),
    pair_u: std.ArrayList(u32),
    pair_v: std.ArrayList(u32),
    levels: std.ArrayList(u32),
    m: u32,
    n: u32,
    allocator: std.mem.Allocator,

    const NIL: u32 = 0;
    const INFINITY: u32 = std.math.maxInt(u32);

    pub fn init(allocator: std.mem.Allocator, m: u32, n: u32) !BipartiteGraph {
        var adjacency_lists = std.ArrayList(std.ArrayList(u32)).init(allocator);
        try adjacency_lists.resize(m + 1);
        for (0..m + 1) |i| {
            adjacency_lists.items[i] = std.ArrayList(u32).init(allocator);
        }

        var pair_u = try std.ArrayList(u32).initCapacity(allocator, m + 1);
        try pair_u.appendNTimes(NIL, m + 1);

        var pair_v = try std.ArrayList(u32).initCapacity(allocator, n + 1);
        try pair_v.appendNTimes(NIL, n + 1);

        var levels = try std.ArrayList(u32).initCapacity(allocator, m + 1);
        try levels.appendNTimes(INFINITY, m + 1);

        return BipartiteGraph{
            .adjacency_lists = adjacency_lists,
            .pair_u = pair_u,
            .pair_v = pair_v,
            .levels = levels,
            .m = m,
            .n = n,
            .allocator = allocator,
        };
    }

    pub fn deinit(self: *BipartiteGraph) void {
        for (0..self.adjacency_lists.items.len) |i| {
            self.adjacency_lists.items[i].deinit();
        }
        self.adjacency_lists.deinit();
        self.pair_u.deinit();
        self.pair_v.deinit();
        self.levels.deinit();
    }

    pub fn add_edge(self: *BipartiteGraph, u: u32, v: u32) !void {
        if (1 <= u and u <= self.m and 1 <= v and v <= self.n) {
            try self.adjacency_lists.items[u].append(v);
        } else {
            return error.InvalidEdge;
        }
    }

    /// Return the matching size of the bipartite graph.
    pub fn hopcroftKarp_algorithm(self: *BipartiteGraph) !u32 {
        var matching_size: u32 = 0;

        // Reset the matching
        for (0..self.pair_u.items.len) |i| {
            self.pair_u.items[i] = NIL;
        }
        for (0..self.pair_v.items.len) |i| {
            self.pair_v.items[i] = NIL;
        }

        while (try self.breadth_first_search()) {
            var u: u32 = 1;
            while (u <= self.m) : (u += 1) {
                if (self.pair_u.items[u] == NIL and try self.depth_first_search(u)) {
                    matching_size += 1;
                }
            }
        }

        return matching_size;
    }

    /// Determines whether there exists an augmenting path starting from a free vertex in U.
    ///
    /// Return true if an augmenting path could exist, otherwise false.
    fn breadth_first_search(self: *BipartiteGraph) !bool {
        var queue = std.fifo.LinearFifo(u32, .Dynamic).init(self.allocator);
        defer queue.deinit();

        // Initialize 'levels' for the vertices in U
        var u: u32 = 1;
        while (u <= self.m) : (u += 1) {
            if (self.pair_u.items[u] == NIL) {
                // If u is a free vertex, its level is 0 and it is added to the queue
                self.levels.items[u] = 0;
                try queue.writeItem(u);
            } else {
                // Otherwise, set 'levels' to infinity
                self.levels.items[u] = INFINITY;
            }
        }

        // The 'level' to the NIL node represents the length of the shortest augmenting path
        self.levels.items[NIL] = INFINITY;

        while (queue.readItem()) |my_u| {
            if (self.levels.items[my_u] < self.levels.items[NIL]) {
                // The path through u could lead to a shorter augmenting path
                for (self.adjacency_lists.items[my_u].items) |v| {
                    const matched_u = self.pair_v.items[v];
                    if (self.levels.items[matched_u] == INFINITY) {
                        // The matched vertex has not been visited yet
                        self.levels.items[matched_u] = self.levels.items[my_u] + 1;
                        try queue.writeItem(matched_u);
                    }
                }
            }
        }

        // An augmenting path from the initial free vertices was found if levels[NIL] is not INFINITY
        return self.levels.items[NIL] != INFINITY;
    }

    /// Determine whether the shortest path from vertex u in U found by breadth_first_search() can be augmented.
    ///
    /// Return true if an augmenting path was found starting from u, otherwise false.
    fn depth_first_search(self: *BipartiteGraph, u: u32) !bool {
        if (u != NIL) {
            // Explore neighbours v of u in V
            for (self.adjacency_lists.items[u].items) |v| {
                const matched_u = self.pair_v.items[v];
                // Check whether the edge (u, v) leads to a vertex matched_u
                // such that the path u -> v -> matched_u is part of a shortest augmenting path
                if (self.levels.items[matched_u] == self.levels.items[u] + 1) {
                    if (try self.depth_first_search(matched_u)) {
                        // An augmenting path is found starting from 'matched_u'
                        self.pair_v.items[v] = u; // Match v with u
                        self.pair_u.items[u] = v; // and u with v
                        return true;
                    }
                }
            }

            // No augmenting path was found starting from vertex u through any of its neighbours v,
            // so remove u from the depth first search phase of the algorithm
            self.levels.items[u] = INFINITY;
            return false;
        }

        return true;
    }
};

const Edge = struct {
    from: u32,
    to: u32,
};

fn test_value(allocator: std.mem.Allocator, test_number: u32, m: u32, n: u32, edges: []const Edge, expected_result: u32) !u32 {
    var graph = try BipartiteGraph.init(allocator, m, n);
    defer graph.deinit();

    for (edges) |edge| {
        try graph.add_edge(edge.from, edge.to);
    }

    const result = try graph.hopcroftKarp_algorithm();

    const stdout = std.io.getStdOut().writer();
    try stdout.print("Test {d}: Result = {d}, Expected = {d}\n", .{ test_number, result, expected_result });

    if (result == expected_result) {
        return 1;
    }

    try stdout.print("Test {d} failed.\n", .{test_number});
    return 0;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const stdout = std.io.getStdOut().writer();
    try stdout.print("Running tests:\n", .{});
    var success_count: u32 = 0;

    // Test Case 1
    {
        const edges = [_]Edge{.{ .from = 1, .to = 4 }};
        success_count += try test_value(allocator, 1, 3, 5, &edges, 1);
    }

    // Test Case 2
    {
        const edges = [_]Edge{
            .{ .from = 1, .to = 4 },
            .{ .from = 1, .to = 5 },
            .{ .from = 5, .to = 1 },
        };
        success_count += try test_value(allocator, 2, 6, 6, &edges, 2);
    }

    // Test Case 3: Complete Bipartite Graph K(3, 3)
    {
        var edges = std.ArrayList(Edge).init(allocator);
        defer edges.deinit();
        var i: u32 = 1;
        while (i <= 3) : (i += 1) {
            var j: u32 = 1;
            while (j <= 3) : (j += 1) {
                try edges.append(.{ .from = i, .to = j });
            }
        }
        success_count += try test_value(allocator, 3, 3, 3, edges.items, 3);
    }

    // Test Case 4: No edges
    {
        const edges = [_]Edge{};
        success_count += try test_value(allocator, 4, 2, 2, &edges, 0);
    }

    // Test Case 5
    {
        const edges = [_]Edge{
            .{ .from = 1, .to = 1 },
            .{ .from = 1, .to = 3 },
            .{ .from = 2, .to = 3 },
            .{ .from = 3, .to = 4 },
            .{ .from = 4, .to = 3 },
            .{ .from = 4, .to = 2 },
        };
        success_count += try test_value(allocator, 5, 4, 4, &edges, 4);
    }

    if (success_count == 5) {
        try stdout.print("All tests passed.\n", .{});
    }
}
