const std = @import("std");

/// Representation of a directed graph, or digraph, using adjacency lists.
/// Vertices are identified by integers starting from zero.
const Digraph = struct {
    vertex_count: u32,
    edge_count: u32,
    adjacency_lists: std.ArrayList(std.ArrayList(u32)),
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator, vertex_count: u32) !Digraph {
        var adjacency_lists = std.ArrayList(std.ArrayList(u32)).init(allocator);
        try adjacency_lists.ensureTotalCapacity(vertex_count);

        for (0..vertex_count) |_| {
            try adjacency_lists.append(std.ArrayList(u32).init(allocator));
        }

        return Digraph{
            .vertex_count = vertex_count,
            .edge_count = 0,
            .adjacency_lists = adjacency_lists,
            .allocator = allocator,
        };
    }

    pub fn deinit(self: *Digraph) void {
        for (self.adjacency_lists.items) |*list| {
            list.deinit();
        }
        self.adjacency_lists.deinit();
    }

    pub fn addEdge(self: *Digraph, from: u32, to: u32) !void {
        self.validateVertex(from);
        self.validateVertex(to);
        try self.adjacency_lists.items[from].append(to);
        self.edge_count += 1;
    }

    pub fn toString(self: *Digraph, allocator: std.mem.Allocator) ![]u8 {
        var result = std.ArrayList(u8).init(allocator);
        defer result.deinit();

        try std.fmt.format(result.writer(), "Digraph has {d} vertices and {d} edges\nAdjacency lists:\n", .{ self.vertex_count, self.edge_count });

        for (0..self.vertex_count) |vertex| {
            if (vertex < 10) {
                try result.append(' ');
            }
            try std.fmt.format(result.writer(), "{d}: ", .{vertex});

            // Sort the adjacency list
            std.sort.insertion(u32, self.adjacency_lists.items[vertex].items, {}, comptime std.sort.asc(u32));

            for (self.adjacency_lists.items[vertex].items) |adjacent| {
                try std.fmt.format(result.writer(), "{d} ", .{adjacent});
            }
            try result.append('\n');
        }

        return result.toOwnedSlice();
    }

    pub fn getVertexCount(self: Digraph) u32 {
        return self.vertex_count;
    }

    pub fn getEdgeCount(self: Digraph) u32 {
        return self.edge_count;
    }

    pub fn getAdjacencyList(self: Digraph, vertex: u32) ![]const u32 {
        self.validateVertex(vertex);
        return self.adjacency_lists.items[vertex].items;
    }

    fn validateVertex(self: Digraph, vertex: u32) void {
        if (vertex >= self.vertex_count) {
            std.debug.panic("Vertex must be between 0 and {d}: {d}", .{ self.vertex_count - 1, vertex });
        }
    }
};

const UNDEFINED: u32 = std.math.maxInt(u32);

/// Determination of the strongly connected components (SCC's) of a directed graph using Gabow's algorithm.
const GabowSCC = struct {
    visited: []bool,
    component_IDs: []u32,
    preorders: []u32,
    preorder_count: u32,
    scc_count: u32,
    visited_vertices_stack: std.ArrayList(u32),
    auxiliary_stack: std.ArrayList(u32),
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator, digraph: Digraph) !GabowSCC {
        const vertex_count = digraph.getVertexCount();

        const visited = try allocator.alloc(bool, vertex_count);
        @memset(visited, false);

        const component_IDs = try allocator.alloc(u32, vertex_count);
        @memset(component_IDs, UNDEFINED);

        const preorders = try allocator.alloc(u32, vertex_count);
        @memset(preorders, UNDEFINED);

        var result = GabowSCC{
            .visited = visited,
            .component_IDs = component_IDs,
            .preorders = preorders,
            .preorder_count = 0,
            .scc_count = 0,
            .visited_vertices_stack = std.ArrayList(u32).init(allocator),
            .auxiliary_stack = std.ArrayList(u32).init(allocator),
            .allocator = allocator,
        };

        for (0..vertex_count) |vertex| {
            if (!result.visited[vertex]) {
                try result.depthFirstSearch(digraph, @intCast(vertex));
            }
        }

        return result;
    }

    pub fn deinit(self: *GabowSCC) void {
        self.allocator.free(self.visited);
        self.allocator.free(self.component_IDs);
        self.allocator.free(self.preorders);
        self.visited_vertices_stack.deinit();
        self.auxiliary_stack.deinit();
    }

    // Return, for each vertex, a list of its strongly connected vertices
    pub fn getComponents(self: GabowSCC) !std.ArrayList(std.ArrayList(u32)) {
        var components = std.ArrayList(std.ArrayList(u32)).init(self.allocator);
        try components.ensureTotalCapacity(self.scc_count);

        for (0..self.scc_count) |_| {
            try components.append(std.ArrayList(u32).init(self.allocator));
        }

        for (0..self.visited.len) |vertex| {
            const component_id = self.getComponentID(@intCast(vertex));
            if (component_id != UNDEFINED) {
                try components.items[component_id].append(@intCast(vertex));
            } else {
                std.debug.panic("Warning: Vertex {d} has no SCC ID assigned.", .{vertex});
            }
        }

        return components;
    }

    // Return whether or not vertices 'v' and 'w' are in the same strongly connected component.
    pub fn isStronglyConnected(self: GabowSCC, v: u32, w: u32) bool {
        self.validateVertex(v);
        self.validateVertex(w);
        return self.component_IDs[v] != UNDEFINED and self.component_IDs[v] == self.component_IDs[w];
    }

    // Return the component ID of the strong component containing 'vertex'.
    pub fn getComponentID(self: GabowSCC, vertex: u32) u32 {
        self.validateVertex(vertex);
        return self.component_IDs[vertex];
    }

    pub fn getSccCount(self: GabowSCC) u32 {
        return self.scc_count;
    }

    fn depthFirstSearch(self: *GabowSCC, digraph: Digraph, vertex: u32) !void {
        self.visited[vertex] = true;
        self.preorders[vertex] = self.preorder_count;
        self.preorder_count += 1;

        try self.visited_vertices_stack.append(vertex);
        try self.auxiliary_stack.append(vertex);

        const adjacents = try digraph.getAdjacencyList(vertex);
        for (adjacents) |adjacent| {
            if (!self.visited[adjacent]) {
                try self.depthFirstSearch(digraph, adjacent);
            } else if (self.component_IDs[adjacent] == UNDEFINED) {
                // Pop vertices from the 'auxiliary_stack'
                // until the top vertex has a preorder <= preorder of 'adjacent'.
                while (self.auxiliary_stack.items.len > 0 and
                       self.preorders[self.auxiliary_stack.items[self.auxiliary_stack.items.len - 1]] > self.preorders[adjacent]) {
                    _ = self.auxiliary_stack.pop();
                }
            }
        }

        // 'vertex' is the root of a SCC,
        // if it remains on top of the 'auxiliary_stack' after exploring all of its descendants and back-edges.
        if (self.auxiliary_stack.items.len > 0 and self.auxiliary_stack.items[self.auxiliary_stack.items.len - 1] == vertex) {
            _ = self.auxiliary_stack.pop();

            // Pop vertices from the 'auxiliary_stack' until 'vertex' is popped,
            // and assign these vertices the current strongly connected component id.
            while (self.visited_vertices_stack.items.len > 0) {
                const adjacent = self.visited_vertices_stack.pop().?;  // Use .? to unwrap the optional
                self.component_IDs[adjacent] = self.scc_count;
                if (adjacent == vertex) {
                    break;
                }
            }
            self.scc_count += 1;
        }
    }

    fn validateVertex(self: GabowSCC, vertex: u32) void {
        const visited_count = self.visited.len;
        if (vertex >= visited_count) {
            std.debug.panic("Vertex {d} is not between 0 and {d}", .{ vertex, visited_count - 1 });
        }
    }
};

const Edge = struct {
    from: u32,
    to: u32,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const edges = [_]Edge{
        .{ .from = 4, .to = 2 }, .{ .from = 2, .to = 3 }, .{ .from = 3, .to = 2 }, .{ .from = 6, .to = 0 },
        .{ .from = 0, .to = 1 }, .{ .from = 2, .to = 0 }, .{ .from = 11, .to = 12 }, .{ .from = 12, .to = 9 },
        .{ .from = 9, .to = 10 }, .{ .from = 9, .to = 11 }, .{ .from = 8, .to = 9 }, .{ .from = 10, .to = 12 },
        .{ .from = 0, .to = 5 }, .{ .from = 5, .to = 4 }, .{ .from = 3, .to = 5 }, .{ .from = 6, .to = 4 },
        .{ .from = 6, .to = 9 }, .{ .from = 7, .to = 6 }, .{ .from = 7, .to = 8 }, .{ .from = 8, .to = 7 },
        .{ .from = 5, .to = 3 }, .{ .from = 0, .to = 6 },
    };

    var digraph = try Digraph.init(allocator, 13);
    defer digraph.deinit();

    for (edges) |edge| {
        try digraph.addEdge(edge.from, edge.to);
    }

    const stdout = std.io.getStdOut().writer();
    try stdout.print("Constructed digraph:\n", .{});

    const digraph_str = try digraph.toString(allocator);
    defer allocator.free(digraph_str);
    try stdout.print("{s}\n", .{digraph_str});

    var gabow_scc = try GabowSCC.init(allocator, digraph);
    defer gabow_scc.deinit();

    try stdout.print("It has {d} strongly connected components.\n\n", .{gabow_scc.getSccCount()});

    var components = try gabow_scc.getComponents();
    defer {
        for (components.items) |*component| {
            component.deinit();
        }
        components.deinit();
    }

    try stdout.print("Components:\n", .{});
    for (components.items, 0..) |component, i| {
        try stdout.print("Component {d}: ", .{i});
        for (component.items) |vertex| {
            try stdout.print("{d} ", .{vertex});
        }
        try stdout.print("\n", .{});
    }

    try stdout.print("\nExample connectivity checks:\n", .{});
    try stdout.print("Vertices 0 and 3 strongly connected? {}\n", .{gabow_scc.isStronglyConnected(0, 3)});
    try stdout.print("Vertices 0 and 7 strongly connected? {}\n", .{gabow_scc.isStronglyConnected(0, 7)});
    try stdout.print("Vertices 9 and 12 strongly connected? {}\n", .{gabow_scc.isStronglyConnected(9, 12)});
    try stdout.print("Component ID of vertex 5: {d}\n", .{gabow_scc.getComponentID(5)});
    try stdout.print("Component ID of vertex 8: {d}\n", .{gabow_scc.getComponentID(8)});
}
