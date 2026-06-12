const std = @import("std");
const assert = std.debug.assert;

pub const Graph = struct {
    allocator: std.mem.Allocator,
    n: usize,
    adj: [][]bool,

    /// Create an n×n empty graph (no edges).
    pub fn init(allocator: std.mem.Allocator, n: usize) !Graph {
        // allocate an array of n rows (each row is a []bool)
        const adj = try allocator.alloc([]bool, n);
        // for each row, allocate n bools, initialized to false
        for (adj) |*row| {
            row.* = try allocator.alloc(bool, n);
            for (row.*) |*cell| cell.* = false;
        }
        return Graph{
            .allocator = allocator,
            .n = n,
            .adj = adj,
        };
    }

    /// Free all allocations.
    pub fn deinit(self: *Graph) void {
        for (self.adj) |row| self.allocator.free(row);
        self.allocator.free(self.adj);
    }

    /// Add an undirected edge u--v.
    pub fn addEdge(self: *Graph, u: usize, v: usize) void {
        assert(u < self.n and v < self.n);
        self.adj[u][v] = true;
        self.adj[v][u] = true;
    }

    /// Degree of a vertex.
    pub fn degree(self: *const Graph, u: usize) usize {
        assert(u < self.n);
        var d: usize = 0;
        for (self.adj[u]) |has|{
             if (has){
                 d += 1;
             }
        }
        return d;
    }

    /// In‐place Chvátal closure.
    pub fn closure(self: *Graph) void {
        while (true) {
            var added = false;
            for (0..self.n)|u| {
                for ((u + 1)..self.n)|v| {
                    if (!self.adj[u][v]) {
                        const du = self.degree(u);
                        const dv = self.degree(v);
                        if (du + dv >= self.n) {
                            self.addEdge(u, v);
                            added = true;
                            break;
                        }
                    }
                }
                if (added == true) {
                    break;
                }
            }
            if (!added) break;
        }
    }

    /// Is the graph complete?
    pub fn isComplete(self: *const Graph) bool {
        for (0..self.n)|u| {
            for ((u + 1)..self.n)|v| {
                if (!self.adj[u][v]) return false;
            }
        }
        return true;
    }

    // recursive DFS
    pub fn dfs(
        self: *const Graph,
        visited: []bool,
        pathBuf: []usize,
        pathLen: usize,
        u: usize,
    ) !?[]usize {
        if (pathLen == self.n) {
            // can we close back to 0?
            if (self.adj[u][pathBuf[0]]) {
                // allocate cycle[n+1], copy pathBuf[0..n), then append 0
                var cycle = try self.allocator.alloc(usize, self.n + 1);
                // corrected copy
                for (0..pathLen)|i| {
                    cycle[i] = pathBuf[i];
                }
                cycle[self.n] = pathBuf[0];
                return cycle;
            } else {
                return null;
            }
        }

        for (0..self.n)|v| {
            if (!visited[v] and self.adj[u][v]) {
                visited[v] = true;
                pathBuf[pathLen] = v;
                const res = try dfs(self, visited, pathBuf, pathLen + 1, v);
                if (res != null) return res;  // Check explicitly for null
                // backtrack
                visited[v] = false;
            }
        }
        return null;
    }
    /// Simple backtracking to find a Hamiltonian cycle in this graph.
    /// Returns null if none found, or a newly‐allocated slice of length n+1
    /// (starting and ending at 0) on success.
    pub fn hamiltonianCycle(self: *const Graph) !?[]usize {
        const allocator = self.allocator;
        // temporary state
        var visited = try allocator.alloc(bool, self.n);
        for (visited) |*b| b.* = false;
        var pathBuf = try allocator.alloc(usize, self.n);

        // start at 0
        visited[0] = true;
        pathBuf[0] = 0;

        const result = try dfs(self, visited, pathBuf, 1, 0);
        allocator.free(visited);
        allocator.free(pathBuf);
        return result;
    }
};

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    // Build the example: 5 vertices, missing only edge 0--1.
    var g = try Graph.init(allocator, 5);
    defer g.deinit();
    for (0..5)|u| {
        for ((u + 1)..5)|v| {
            if (!(u == 0 and v == 1)) {
                g.addEdge(u, v);
            }
        }
    }

    try stdout.print("Original graph degrees:\n", .{});
    for (0..g.n)|u| {
        try stdout.print(" deg({}) = {}\n", .{u, g.degree(u)});
    }

    // Compute closure in a copy of g
    var cg = try Graph.init(allocator, g.n);
    defer cg.deinit();
    // copy adjacency
    for (0..g.n)|u| {
        for (0..g.n)|v| {
            cg.adj[u][v] = g.adj[u][v];
        }
    }
    cg.closure();

    try stdout.print("\nAfter Chvátal closure:\n", .{});
    for (0..cg.n)|u| {
        try stdout.print(" {}:", .{u});
        for (0..cg.n)|v| {
            if (cg.adj[u][v]) {
                try stdout.print(" {}", .{v});
            }
        }
        try stdout.print("\n", .{});
    }

    if (cg.isComplete()) {
        try stdout.print(
            "\nClosure is complete ⇒ graph is Hamiltonian (by Bondy--Chvátal).\n",
            .{},
        );
        // search in the *original* graph g
        const cycleOpt = try g.hamiltonianCycle();
        if (cycleOpt) |cycle| {
            try stdout.print("Found Hamiltonian cycle in original graph:\n", .{});
            for (cycle,0..) |v,i| {
                if (i > 0) try stdout.print(" → ", .{});
                try stdout.print("{}", .{v});
            }
            try stdout.print("\n", .{});
            allocator.free(cycle);
        } else {
            try stdout.print(
                "Unexpected: could not find a Hamiltonian cycle.\n",
                .{},
            );
        }
    } else {
        try stdout.print(
            "\nClosure is not complete ⇒ no guarantee of Hamiltonian cycle.\n",
            .{},
        );
    }
}
