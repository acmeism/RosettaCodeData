const std = @import("std");

const Edge = struct {
    u: u32,
    v: u32,
    weight: f64,
};

const Graph = struct {
    edges: std.ArrayList(Edge),
    vertex_count: u32,
    allocator: std.mem.Allocator,

    fn init(allocator: std.mem.Allocator, vertex_count: u32) !Graph {
        return Graph{
            .edges = std.ArrayList(Edge).init(allocator),
            .vertex_count = vertex_count,
            .allocator = allocator,
        };
    }

    fn deinit(self: *Graph) void {
        self.edges.deinit();
    }

    fn addEdge(self: *Graph, edge: Edge) !void {
        try self.edges.append(edge);
    }

    // Return the index of the tree containing 'vertex', using a path compression technique
    fn find(parent: []u32, vertex: u32) u32 {
        if (parent[vertex] != vertex) {
            parent[vertex] = find(parent, parent[vertex]);
        }
        return parent[vertex];
    }

    // Form the union by rank of the two trees indexed by u and v
    fn unionSet(parent: []u32, rank: []u32, u: u32, v: u32) void {
        const uRoot = find(parent, u);
        const vRoot = find(parent, v);

        // Attach the smaller rank tree under root of the high rank tree
        if (rank[uRoot] < rank[vRoot]) {
            parent[uRoot] = vRoot;
        } else if (rank[uRoot] > rank[vRoot]) {
            parent[vRoot] = uRoot;
        } else {
            // If ranks are the same, make one the root and increment its rank
            parent[vRoot] = uRoot;
            rank[uRoot] += 1;
        }
    }

    // Return the minimum spanning tree by using Boruvka's algorithm
    fn boruvkaMinimumSpanningTree(self: *Graph) !void {
        const stdout = std.io.getStdOut().writer();
        var parent = try self.allocator.alloc(u32, self.vertex_count);
        defer self.allocator.free(parent);

        var rank = try self.allocator.alloc(u32, self.vertex_count);
        defer self.allocator.free(rank);

        var cheapest = try self.allocator.alloc(Edge, self.vertex_count);
        defer self.allocator.free(cheapest);

        // Initialize parent array (each vertex is its own parent)
        for (0..self.vertex_count) |i| {
            parent[i] = @intCast(i);
            rank[i] = 0;
            cheapest[i] = Edge{ .u = std.math.maxInt(u32), .v = std.math.maxInt(u32), .weight = -1.0 };
        }

        // Initially there are 'vertex_count' different trees
        var tree_count: u32 = self.vertex_count;
        var minimum_spanning_tree_weight: f64 = 0.0;

        // Combine trees until all trees are combined into a single minimum spanning tree
        while (tree_count > 1) {
            // Traverse through all edges and update cheapest edge for every tree
            for (self.edges.items) |edge| {
                const u = edge.u;
                const v = edge.v;
                const weight = edge.weight;

                const index1 = find(parent, u);
                const index2 = find(parent, v);

                // If the two vertices of the current edge belong to different trees,
                // check whether the current edge is cheaper than previous cheapest edges
                if (index1 != index2) {
                    if (cheapest[index1].weight == -1.0 or cheapest[index1].weight > weight) {
                        cheapest[index1] = Edge{ .u = u, .v = v, .weight = weight };
                    }
                    if (cheapest[index2].weight == -1.0 or cheapest[index2].weight > weight) {
                        cheapest[index2] = Edge{ .u = u, .v = v, .weight = weight };
                    }
                }
            }

            // Add the cheapest edges to the minimum spanning tree
            for (0..self.vertex_count) |vertex_usize| {
                const vertex = @as(u32,  @intCast(vertex_usize));

                // Check whether the cheapest edge for current vertex exists
                if (cheapest[vertex].weight != -1.0) {
                    const u = cheapest[vertex].u;
                    const v = cheapest[vertex].v;
                    const weight = cheapest[vertex].weight;

                    const index1 = find(parent, u);
                    const index2 = find(parent, v);

                    if (index1 != index2) {
                        minimum_spanning_tree_weight += weight;
                        unionSet(parent, rank, index1, index2);
                        try stdout.print("Edge {d}--{d} with weight {d} is included in the minimum spanning tree\n", .{ u, v, weight });
                        tree_count -= 1;
                    }
                }
            }

            // Reset cheapest edges for next iteration
            for (0..self.vertex_count) |i| {
                cheapest[i] = Edge{ .u = std.math.maxInt(u32), .v = std.math.maxInt(u32), .weight = -1.0 };
            }
        }

        try stdout.print("\nWeight of minimum spanning tree is {d}\n", .{minimum_spanning_tree_weight});
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var graph = try Graph.init(allocator, 4);
    defer graph.deinit();

    try graph.addEdge(Edge{ .u = 0, .v = 1, .weight = 10.0 });
    try graph.addEdge(Edge{ .u = 0, .v = 2, .weight = 6.0 });
    try graph.addEdge(Edge{ .u = 0, .v = 3, .weight = 5.0 });
    try graph.addEdge(Edge{ .u = 1, .v = 3, .weight = 15.0 });
    try graph.addEdge(Edge{ .u = 2, .v = 3, .weight = 4.0 });

    try graph.boruvkaMinimumSpanningTree();
}
