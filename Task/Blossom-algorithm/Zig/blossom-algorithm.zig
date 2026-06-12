const std = @import("std");

const Blossom = struct {
    n: usize,
    adj: [][]usize,
    matching: []?usize,  // matching[v] = u if v--u is matched
    parent: []?usize,    // parent in the alternating tree
    base: []usize,       // base[v] = base vertex of blossom containing v
    used: []bool,        // used[v] = whether v is in the BFS tree
    blossom: []bool,     // helper array for marking blossoms
    q: std.fifo.LinearFifo(usize, .Dynamic),  // BFS queue
    allocator: std.mem.Allocator,

    fn init(allocator: std.mem.Allocator, adj: [][]usize) !Blossom {
        const n = adj.len;
        const matching = try allocator.alloc(?usize, n);
        const parent = try allocator.alloc(?usize, n);
        var base = try allocator.alloc(usize, n);
        const used = try allocator.alloc(bool, n);
        const blossom = try allocator.alloc(bool, n);
        const q = std.fifo.LinearFifo(usize, .Dynamic).init(allocator);

        @memset(matching, null);
        @memset(parent, null);
        for (0..n) |i| {
            base[i] = i;
        }
        @memset(used, false);
        @memset(blossom, false);

        return Blossom{
            .n = n,
            .adj = adj,
            .matching = matching,
            .parent = parent,
            .base = base,
            .used = used,
            .blossom = blossom,
            .q = q,
            .allocator = allocator,
        };
    }

    fn deinit(self: *Blossom) void {
        self.allocator.free(self.matching);
        self.allocator.free(self.parent);
        self.allocator.free(self.base);
        self.allocator.free(self.used);
        self.allocator.free(self.blossom);
        self.q.deinit();
    }

    // Find least common ancestor of a and b in the forest of alternating tree.
    fn lca(self: *const Blossom, a_in: usize, b_in: usize) usize {
        var a = a_in;
        var b = b_in;
        var used_path = self.allocator.alloc(bool, self.n) catch unreachable;
        defer self.allocator.free(used_path);
        @memset(used_path, false);

        // climb from a
        while (true) {
            a = self.base[a];
            used_path[a] = true;
            if (self.matching[a]) |ma| {
                if (self.parent[ma]) |pa| {
                    a = pa;
                    continue;
                }
            }
            break;
        }

        // climb from b until we hit a marked vertex
        while (true) {
            b = self.base[b];
            if (used_path[b]) {
                return b;
            }
            if (self.matching[b]) |mb| {
                if (self.parent[mb]) |pb| {
                    b = pb;
                    continue;
                }
            }
            // In a valid alternating forest this should always terminate
            unreachable;
        }
    }

    // Mark vertices along the path from v to base b, setting their parent to x.
    fn markPath(self: *Blossom, v_in: usize, b: usize, x_in: usize) void {
        var v = v_in;
        var x = x_in;
        while (self.base[v] != b) {
            const mv = self.matching[v].?;
            self.blossom[self.base[v]] = true;
            self.blossom[self.base[mv]] = true;
            self.parent[v] = x;
            x = mv;
            v = self.parent[x].?;
        }
    }

    // Try to find an augmenting path starting from root.
    fn findPath(self: *Blossom, root: usize) bool {
        // Reset BFS state
        @memset(self.used, false);
        @memset(self.parent, null);
        for (0..self.n) |i| {
            self.base[i] = i;
        }
        self.q.head = 0;
        self.q.count = 0;

        self.used[root] = true;
        self.q.writeItem(root) catch unreachable;

        while (self.q.readItem()) |v| {
            for (self.adj[v]) |u| {
                if (self.base[v] == self.base[u] or self.matching[v] == u) {
                    continue;
                }
                // Found a blossom
                if (u == root or
                    (self.matching[u] != null and self.parent[self.matching[u].?] != null)) {
                    const curbase = self.lca(v, u);
                    @memset(self.blossom, false);
                    self.markPath(v, curbase, u);
                    self.markPath(u, curbase, v);
                    for (0..self.n) |i| {
                        if (self.blossom[self.base[i]]) {
                            self.base[i] = curbase;
                            if (!self.used[i]) {
                                self.used[i] = true;
                                self.q.writeItem(i) catch unreachable;
                            }
                        }
                    }
                }
                // Otherwise, try to extend the alternating tree
                else if (self.parent[u] == null) {
                    self.parent[u] = v;
                    // If u is free, we've found an augmenting path
                    if (self.matching[u] == null) {
                        var cur = u;
                        while (self.parent[cur]) |prev| {
                            const next = self.matching[prev];
                            self.matching[cur] = prev;
                            self.matching[prev] = cur;
                            cur = next orelse break;
                        }
                        return true;
                    }
                    // Otherwise enqueue the matched partner
                    const mu = self.matching[u].?;
                    if (!self.used[mu]) {
                        self.used[mu] = true;
                        self.q.writeItem(mu) catch unreachable;
                    }
                }
            }
        }
        return false;
    }

    // Main solver: returns (matching, size_of_matching)
    fn solve(self: *Blossom) struct { matching: []?usize, size: usize } {
        var res: usize = 0;
        for (0..self.n) |v| {
            if (self.matching[v] == null and self.findPath(v)) {
                res += 1;
            }
        }

        const result_matching = self.allocator.alloc(?usize, self.n) catch unreachable;
        @memcpy(result_matching, self.matching);

        return .{ .matching = result_matching, .size = res };
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Example: 5‑cycle (odd cycle) 0--1--2--3--4--0
    const n: usize = 5;
    const edges = [_][2]usize{
        .{0, 1}, .{1, 2}, .{2, 3}, .{3, 4}, .{4, 0}
    };

    var adj = try allocator.alloc([]usize, n);
    defer {
        for (adj) |neighbors| {
            allocator.free(neighbors);
        }
        allocator.free(adj);
    }

    // Initialize empty adjacency lists
    for (0..n) |i| {
        adj[i] = try allocator.alloc(usize, 0);
    }

    // Count neighbors for each vertex
    var counts = try allocator.alloc(usize, n);
    defer allocator.free(counts);
    @memset(counts, 0);

    for (edges) |edge| {
        counts[edge[0]] += 1;
        counts[edge[1]] += 1;
    }

    // Allocate space for neighbors
    for (0..n) |i| {
        allocator.free(adj[i]);
        adj[i] = try allocator.alloc(usize, counts[i]);
        counts[i] = 0; // Reset to use as index
    }

    // Fill adjacency lists
    for (edges) |edge| {
        const u = edge[0];
        const v = edge[1];
        adj[u][counts[u]] = v;
        counts[u] += 1;
        adj[v][counts[v]] = u;
        counts[v] += 1;
    }

    var blossom = try Blossom.init(allocator, adj);
    defer blossom.deinit();

    const result = blossom.solve();
    defer allocator.free(result.matching);

    const stdout = std.io.getStdOut().writer();
    try stdout.print("Maximum matching size: {d}\n", .{result.size});
    try stdout.print("Matched pairs:\n", .{});

    for (0..n) |u| {
        if (result.matching[u]) |v| {
            if (u < v) {
                try stdout.print("  {d} -- {d}\n", .{u, v});
            }
        }
    }
}
