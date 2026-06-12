const std = @import("std");
const math = std.math;
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const AutoHashMap = std.AutoHashMap;


// Add this near the top with your other struct definitions
const EulerianAdjEntry = struct {
    neighbor: usize,
    edge_idx: usize
};

// --- Structs ---
const Point = struct {
    id: usize, // Original index or assigned ID
    x: f64,
    y: f64,

    pub fn init(id: usize, x: f64, y: f64) Point {
        return .{ .id = id, .x = x, .y = y };
    }
};

const Edge = struct {
    u: usize,
    v: usize,
    weight: f64,

    pub fn init(u: usize, v: usize, weight: f64) Edge {
        return .{ .u = u, .v = v, .weight = weight };
    }

    // Comparison function for sorting edges by weight
    pub fn lessThan(_: void, a: Edge, b: Edge) bool {
        return a.weight < b.weight;
    }
};

// --- Helper Functions ---

fn printUsizeVec(vec: []const usize, name: []const u8) void {
    std.debug.print("{s}: [", .{name});
    for (vec, 0..) |x, i| {
        if (i > 0) std.debug.print(", ", .{});
        std.debug.print("{}", .{x});
    }
    std.debug.print("]\n", .{});
}

fn printEdges(edges: []const Edge, name: []const u8) void {
    std.debug.print("{s}: [", .{name});
    for (edges, 0..) |e, i| {
        if (i > 0) std.debug.print(", ", .{});
        std.debug.print("({}, {}, {d:.2})", .{e.u, e.v, e.weight});
    }
    std.debug.print("]\n", .{});
}

fn printGraph(graph: []const []const f64, name: []const u8) void {
    std.debug.print("{s}: {{\n", .{name});
    const n = graph.len;
    for (0..n) |i| {
        std.debug.print("  {}: {{", .{i});
        var first = true;
        for (0..n) |j| {
            if (i == j) continue;
            if (!first) std.debug.print(", ", .{});
            std.debug.print("{}: {d:.2}", .{j, graph[i][j]});
            first = false;
        }
        std.debug.print("}}{s}\n", .{if (i == n - 1) "" else ","});
    }
    std.debug.print("}}\n", .{});
}

// --- Euclidean Distance ---
fn getLength(p1: Point, p2: Point) f64 {
    const dx = p1.x - p2.x;
    const dy = p1.y - p2.y;
    return @sqrt(dx * dx + dy * dy);
}

// --- Build Complete Graph (Adjacency Matrix) ---
fn buildGraph(allocator: Allocator, data: []const Point) ![][]f64 {
    const n = data.len;
    var graph = try allocator.alloc([]f64, n);
    errdefer {
        for (0..graph.len) |i| {
            allocator.free(graph[i]);
        }
        allocator.free(graph);
    }

    for (0..n) |i| {
        graph[i] = try allocator.alloc(f64, n);
        @memset(graph[i], 0.0);
    }

    for (0..n) |i| {
        for (i + 1..n) |j| { // Only calculate upper triangle
            const dist = getLength(data[i], data[j]);
            graph[i][j] = dist;
            graph[j][i] = dist; // Symmetric graph
        }
    }
    return graph;
}

// --- Union-Find Data Structure ---
const UnionFind = struct {
    parent: []usize,
    rank: []usize,
    allocator: Allocator,

    pub fn init(allocator: Allocator, n: usize) !UnionFind {
        var parent = try allocator.alloc(usize, n);
        errdefer allocator.free(parent);

        var rank = try allocator.alloc(usize, n);
        errdefer allocator.free(rank);

        for (0..n) |i| {
            parent[i] = i;
            rank[i] = 0;
        }

        return UnionFind{
            .parent = parent,
            .rank = rank,
            .allocator = allocator,
        };
    }

    pub fn deinit(self: *UnionFind) void {
        self.allocator.free(self.parent);
        self.allocator.free(self.rank);
    }

    pub fn find(self: *UnionFind, i: usize) usize {
        if (self.parent[i] == i) {
            return i;
        } else {
            // Path compression
            self.parent[i] = self.find(self.parent[i]);
            return self.parent[i];
        }
    }

    pub fn unite(self: *UnionFind, i: usize, j: usize) bool {
        const root_i = self.find(i);
        const root_j = self.find(j);
        if (root_i != root_j) {
            // Union by rank
            if (self.rank[root_i] < self.rank[root_j]) {
                self.parent[root_i] = root_j;
            } else if (self.rank[root_i] > self.rank[root_j]) {
                self.parent[root_j] = root_i;
            } else {
                self.parent[root_j] = root_i;
                self.rank[root_i] += 1;
            }
            return true;
        } else {
            return false;
        }
    }
};

// --- Minimum Spanning Tree (Kruskal's Algorithm) ---
fn minimumSpanningTree(allocator: Allocator, graph: []const []const f64) ![]Edge {
    const n = graph.len;
    if (n == 0) {
        return &[_]Edge{};
    }

    var edges = ArrayList(Edge).init(allocator);
    defer edges.deinit();

    for (0..n) |i| {
        for (i + 1..n) |j| { // Avoid duplicates and self-loops
            try edges.append(Edge.init(i, j, graph[i][j]));
        }
    }

    // Sort edges by weight
    std.sort.heap(Edge, edges.items, {}, Edge.lessThan);

    var mst = ArrayList(Edge).init(allocator);
    errdefer mst.deinit();

    var uf = try UnionFind.init(allocator, n);
    defer uf.deinit();

    var edges_count: usize = 0;

    for (edges.items) |edge| {
        if (uf.unite(edge.u, edge.v)) {
            try mst.append(edge);
            edges_count += 1;
            if (edges_count == n - 1) { // Optimization: MST has n-1 edges
                break;
            }
        }
    }
    return mst.toOwnedSlice();
}

// --- Find Vertices with Odd Degree in MST ---
fn findOddVertexes(allocator: Allocator, mst: []const Edge, n: usize) ![]usize {
    var degree = try allocator.alloc(usize, n);
    defer allocator.free(degree);
    @memset(degree, 0);

    for (mst) |edge| {
        degree[edge.u] += 1;
        degree[edge.v] += 1;
    }

    var odd_vertices = ArrayList(usize).init(allocator);
    errdefer odd_vertices.deinit();

    for (0..n) |i| {
        if (degree[i] % 2 != 0) {
            try odd_vertices.append(i);
        }
    }
    return odd_vertices.toOwnedSlice();
}

// --- Minimum Weight Matching (Greedy Heuristic) ---
fn minimumWeightMatching(
    allocator: Allocator,
    multigraph_edges: *ArrayList(Edge),
    graph: []const []const f64,
    odd_vertices: []const usize,
) !void {
    const n = graph.len;
    if (odd_vertices.len == 0) {
        return;
    }

    var rand = std.Random.DefaultPrng.init(@as(u64, @intCast(std.time.milliTimestamp())));
    var prng = rand.random();

    // Clone and shuffle odd_vertices
    var current_odd = ArrayList(usize).init(allocator);
    defer current_odd.deinit();
    try current_odd.appendSlice(odd_vertices);

    // Shuffle the array
    for (0..current_odd.items.len) |i| {
        const j = prng.intRangeLessThan(usize, 0, current_odd.items.len);
        std.mem.swap(usize, &current_odd.items[i], &current_odd.items[j]);
    }

    var matched = try allocator.alloc(bool, n);
    defer allocator.free(matched);
    @memset(matched, false);

    var processed = try allocator.alloc(bool, current_odd.items.len);
    defer allocator.free(processed);
    @memset(processed, false);

    for (0..current_odd.items.len) |i| {
        if (processed[i]) continue; // Skip if already processed (matched)

        const v = current_odd.items[i];
        var min_length = math.inf(f64);
        var closest_u_idx: ?usize = null; // Store index in current_odd

        // Find the closest *unmatched* odd vertex *later* in the shuffled list
        for (i + 1..current_odd.items.len) |j| {
            if (!processed[j]) { // Check if 'u' (at current_odd[j]) is available
                const u = current_odd.items[j];
                if (graph[v][u] < min_length) {
                    min_length = graph[v][u];
                    closest_u_idx = j;
                }
            }
        }

        if (closest_u_idx) |j| {
            const u = current_odd.items[j];
            // Add the matching edge to the MST list (now a multigraph)
            try multigraph_edges.append(Edge.init(v, u, min_length));

            // Mark both as processed in the shuffled list context
            processed[i] = true;
            processed[j] = true;
            // Mark in the global 'matched' array
            matched[v] = true;
            matched[u] = true;
        } else {
            // This *shouldn't* happen in Christofides as the number of odd vertices is always even.
            // If it does, it might indicate an issue earlier or a graph where matching isn't possible?
            std.log.err("Warning: Could not find match for odd vertex {} in greedy matching.", .{v});
        }
    }
}

// --- Find Eulerian Tour (Hierholzer's Algorithm) ---
// Then in the findEulerianTour function, modify this section:
fn findEulerianTour(allocator: Allocator, multigraph_edges: []const Edge, n: usize) ![]usize {
    if (multigraph_edges.len == 0) {
        return &[_]usize{};
    }

    // Build adjacency list: adj[u] = Vec<(neighbor, edge_index)>
    var adj = try allocator.alloc(ArrayList(EulerianAdjEntry), n);
    defer {
        for (0..n) |i| {
            adj[i].deinit();
        }
        allocator.free(adj);
    }

    for (0..n) |i| {
        adj[i] = ArrayList(EulerianAdjEntry).init(allocator);
    }

    for (multigraph_edges, 0..) |edge, edge_idx| {
        try adj[edge.u].append(.{ .neighbor = edge.v, .edge_idx = edge_idx });
        try adj[edge.v].append(.{ .neighbor = edge.u, .edge_idx = edge_idx });
    }

    var edge_used = try allocator.alloc(bool, multigraph_edges.len);
    defer allocator.free(edge_used);
    @memset(edge_used, false);

    var tour = ArrayList(usize).init(allocator);
    errdefer tour.deinit();

    var stack = ArrayList(usize).init(allocator);
    defer stack.deinit();

    // Start at any vertex with edges
    const start_node = multigraph_edges[0].u;
    try stack.append(start_node);

    while (stack.items.len > 0) {
        const current_node = stack.items[stack.items.len - 1];
        var found_edge = false;

        // Try to find an unused edge
        while (adj[current_node].items.len > 0) {
            const last_idx = adj[current_node].items.len - 1;
            const item = adj[current_node].items[last_idx];
            const neighbor = item.neighbor;
            const edge_idx = item.edge_idx;
            _ = adj[current_node].pop();

            if (!edge_used[edge_idx]) {
                edge_used[edge_idx] = true;
                try stack.append(neighbor);
                found_edge = true;
                break; // Move to the neighbor
            }
            // If edge was used, loop continues popping from adj[current_node]
        }

        // If no unused edge was found from current_node
        if (!found_edge) {
            try tour.append(stack.pop().?);
        }
    }

    // Reverse the tour
    std.mem.reverse(usize, tour.items);
    return tour.toOwnedSlice();
}

// --- Main TSP Function (Christofides Approximation) ---
fn tsp(allocator: Allocator, data: []const Point) !struct { length: f64, path: []usize } {
    const n = data.len;
    if (n == 0) {
        return .{ .length = 0.0, .path = &[_]usize{} };
    }
    if (n == 1) {
        var path = try allocator.alloc(usize, 1);
        path[0] = data[0].id;
        return .{ .length = 0.0, .path = path };
    }

    std.debug.print("Building graph...\n", .{});
    const graph = try buildGraph(allocator, data);
    defer {
        for (0..graph.len) |i| {
            allocator.free(graph[i]);
        }
        allocator.free(graph);
    }
    // printGraph(graph, "Graph"); // Can be very large

    std.debug.print("Finding Minimum Spanning Tree...\n", .{});
    const mst = try minimumSpanningTree(allocator, graph);
    defer allocator.free(mst);
    printEdges(mst, "MSTree");

    std.debug.print("Finding odd degree vertices...\n", .{});
    const odd_vertices = try findOddVertexes(allocator, mst, n);
    defer allocator.free(odd_vertices);
    printUsizeVec(odd_vertices, "Odd vertexes in MSTree");

    std.debug.print("Finding Minimum Weight Matching (greedy)...\n", .{});
    // Clone MST edges to create the initial multigraph
    var multigraph_edges = ArrayList(Edge).init(allocator);
    defer multigraph_edges.deinit();
    try multigraph_edges.appendSlice(mst);

    // Add matching edges to the multigraph_edges vector
    try minimumWeightMatching(allocator, &multigraph_edges, graph, odd_vertices);
    printEdges(multigraph_edges.items, "Minimum weight matching (MST + Matching Edges)");

    std.debug.print("Finding Eulerian Tour...\n", .{});
    const eulerian_tour = try findEulerianTour(allocator, multigraph_edges.items, n);
    defer allocator.free(eulerian_tour);
    printUsizeVec(eulerian_tour, "Eulerian tour");

    // --- Create Hamiltonian Circuit by Skipping Visited Nodes ---
    std.debug.print("Creating Hamiltonian path (shortcutting)...\n", .{});
    if (eulerian_tour.len == 0 and n > 0) {
        std.log.err("Error: Eulerian tour could not be found.", .{});
        return .{ .length = -1.0, .path = &[_]usize{} };
    }

    var path = ArrayList(usize).init(allocator);
    errdefer path.deinit();

    var length: f64 = 0.0;
    var visited = AutoHashMap(usize, void).init(allocator);
    defer visited.deinit();

    var last_node_in_path: ?usize = null;

    for (eulerian_tour) |node| {
        const result = try visited.getOrPut(node);
        if (!result.found_existing) {
            if (last_node_in_path) |last_node| {
                // Add distance from the *previous node added to the path*
                length += graph[last_node][node];
            }
            try path.append(node); // Add node to the Hamiltonian path
            last_node_in_path = node; // Update the last node *in the path*
        }
    }

    // Add the edge back to the start to complete the cycle
    if (last_node_in_path != null and path.items.len > 0) {
        const last = last_node_in_path.?;
        const first = path.items[0];
        length += graph[last][first];
        try path.append(first); // Add the starting node ID again to show the cycle
    }

    printUsizeVec(path.items, "Result path");
    std.debug.print("Result length of the path: {d:.2}\n", .{length});

    return .{ .length = length, .path = try path.toOwnedSlice() };
}

pub fn main() !void {
    // Use an arena allocator for all temporary allocations
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    // Input data matching the Python/JS example
    const raw_data = [_][2]f64{
        .{1380.0, 939.0}, .{2848.0, 96.0}, .{3510.0, 1671.0}, .{457.0, 334.0}, .{3888.0, 666.0},
        .{984.0, 965.0}, .{2721.0, 1482.0}, .{1286.0, 525.0}, .{2716.0, 1432.0}, .{738.0, 1325.0},
        .{1251.0, 1832.0}, .{2728.0, 1698.0}, .{3815.0, 169.0}, .{3683.0, 1533.0}, .{1247.0, 1945.0},
        .{123.0, 862.0}, .{1234.0, 1946.0}, .{252.0, 1240.0}, .{611.0, 673.0}, .{2576.0, 1676.0},
        .{928.0, 1700.0}, .{53.0, 857.0}, .{1807.0, 1711.0}, .{274.0, 1420.0}, .{2574.0, 946.0},
        .{178.0, 24.0}, .{2678.0, 1825.0}, .{1795.0, 962.0}, .{3384.0, 1498.0}, .{3520.0, 1079.0},
        .{1256.0, 61.0}, .{1424.0, 1728.0}, .{3913.0, 192.0}, .{3085.0, 1528.0}, .{2573.0, 1969.0},
        .{463.0, 1670.0}, .{3875.0, 598.0}, .{298.0, 1513.0}, .{3479.0, 821.0}, .{2542.0, 236.0},
        .{3955.0, 1743.0}, .{1323.0, 280.0}, .{3447.0, 1830.0}, .{2936.0, 337.0}, .{1621.0, 1830.0},
        .{3373.0, 1646.0}, .{1393.0, 1368.0}, .{3874.0, 1318.0}, .{938.0, 955.0}, .{3022.0, 474.0},
        .{2482.0, 1183.0}, .{3854.0, 923.0}, .{376.0, 825.0}, .{2519.0, 135.0}, .{2945.0, 1622.0},
        .{953.0, 268.0}, .{2628.0, 1479.0}, .{2097.0, 981.0}, .{890.0, 1846.0}, .{2139.0, 1806.0},
        .{2421.0, 1007.0}, .{2290.0, 1810.0}, .{1115.0, 1052.0}, .{2588.0, 302.0}, .{327.0, 265.0},
        .{241.0, 341.0}, .{1917.0, 687.0}, .{2991.0, 792.0}, .{2573.0, 599.0}, .{19.0, 674.0},
        .{3911.0, 1673.0}, .{872.0, 1559.0}, .{2863.0, 558.0}, .{929.0, 1766.0}, .{839.0, 620.0},
        .{3893.0, 102.0}, .{2178.0, 1619.0}, .{3822.0, 899.0}, .{378.0, 1048.0}, .{1178.0, 100.0},
        .{2599.0, 901.0}, .{3416.0, 143.0}, .{2961.0, 1605.0}, .{611.0, 1384.0}, .{3113.0, 885.0},
        .{2597.0, 1830.0}, .{2586.0, 1286.0}, .{161.0, 906.0}, .{1429.0, 134.0}, .{742.0, 1025.0},
        .{1625.0, 1651.0}, .{1187.0, 706.0}, .{1787.0, 1009.0}, .{22.0, 987.0}, .{3640.0, 43.0},
        .{3756.0, 882.0}, .{776.0, 392.0}, .{1724.0, 1642.0}, .{198.0, 1810.0}, .{3950.0, 1558.0},
    };

    // Convert raw data to Point structs, using index as ID
    var data_points = ArrayList(Point).init(allocator);
    defer data_points.deinit();

    for (raw_data, 0..) |coords, i| {
        try data_points.append(Point.init(i, coords[0], coords[1]));
    }

    // --- Run TSP ---
    const result = try tsp(allocator, data_points.items);
    defer allocator.free(result.path);
    // Result is already printed within tsp function
}
