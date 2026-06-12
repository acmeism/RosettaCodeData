const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const AutoHashMap = std.AutoHashMap;
const PriorityQueue = std.PriorityQueue;

// f64_max isn't directly available in Zig 0.14.0, use std.math.floatMax instead
const INF = std.math.floatMax(f64);

const Edge = struct {
    u: usize,
    v: usize,
    weight: f64,
};

const VertexAndWeight = struct {
    v: usize,
    weight: f64,
};

const WeightAndVertex = struct {
    weight: f64,
    vertex: usize,

    pub fn compare(context: void, a: WeightAndVertex, b: WeightAndVertex) std.math.Order {
        _ = context;
        // For min-heap, we want to return Less when a is greater (reversed order)
        return std.math.order(b.weight, a.weight);
    }
};

pub fn johnsonsAlgorithm(allocator: Allocator, graph: []const []const f64) !?ArrayList(ArrayList(f64)) {
    const vertex_count = graph.len;
    var original_edges = ArrayList(Edge).init(allocator);
    defer original_edges.deinit();

    // Step 0: Build a list of edges for the original graph
    for (0..vertex_count) |i| {
        for (0..vertex_count) |j| {
            const weight = graph[i][j];
            if (i == j) {
                if (weight != 0.0) {
                    std.debug.print("Warning: graph[i][i] for i = {d} is {d}, expected to be 0.0, resetting it to 0.0\n", .{ i, weight });
                }
            } else if (weight != INF) {
                try original_edges.append(Edge{ .u = i, .v = j, .weight = weight });
            }
        }
    }

    // Step 1: Form the augmented graph
    // Add a new vertex with index 'vertex_count' and having 0-weight edges to all the original vertices
    var augmented_edges = ArrayList(Edge).init(allocator);
    defer augmented_edges.deinit();

    try augmented_edges.appendSlice(original_edges.items);
    for (0..vertex_count) |i| {
        try augmented_edges.append(Edge{ .u = vertex_count, .v = i, .weight = 0.0 });
    }

    // Step 2: Invoke the Bellman-Ford Algorithm starting from the new vertex
    const h_values_opt = try bellmanFordAlgorithm(allocator, vertex_count + 1,
                                               augmented_edges.items, vertex_count);

    if (h_values_opt == null) {
        return null; // A negative cycle was detected by the Bellman-Ford Algorithm
    }

    var h_values = h_values_opt.?;
    defer h_values.deinit();

    // Remove the value for the augmented vertex
    _ = h_values.pop();

    // Step 3: Reweight the edges
    var reweighted_adjacencies = AutoHashMap(usize, ArrayList(VertexAndWeight)).init(allocator);
    defer {
        var it = reweighted_adjacencies.valueIterator();
        while (it.next()) |value| {
            value.deinit();
        }
        reweighted_adjacencies.deinit();
    }

    for (0..vertex_count) |v| {
        try reweighted_adjacencies.put(v, ArrayList(VertexAndWeight).init(allocator));
    }

    for (original_edges.items) |edge| {
        // Ensure the 'values' are valid before reweighting
        if (h_values.items[edge.u] == INF or h_values.items[edge.v] == INF) {
            std.debug.print("Warning: invalid hValues detected by the Bellman-Ford Algorithm.\n", .{});
        }

        const reweight = edge.weight + h_values.items[edge.u] - h_values.items[edge.v];
        try reweighted_adjacencies.getPtr(edge.u).?.append(VertexAndWeight{ .v = edge.v, .weight = reweight });
    }

    // Step 4: Invoke Dijkstra's Algorithm starting from each vertex on the reweighted graph
    var all_pairs_shortest_paths = ArrayList(ArrayList(f64)).init(allocator);
    var error_occurred = false;

    for (0..vertex_count) |u| {
        if (error_occurred) break;

        // We create a new function that returns a result to handle errors
        if (try dijkstraAlgorithm(allocator, vertex_count, &reweighted_adjacencies, u, h_values.items)) |distances| {
            try all_pairs_shortest_paths.append(distances);
        } else {
            error_occurred = true;

            // Clean up previously allocated lists
            for (all_pairs_shortest_paths.items) |*path| {
                path.deinit();
            }
            all_pairs_shortest_paths.deinit();

            return null;
        }
    }

    // Step 5: Return the result matrix
    return all_pairs_shortest_paths;
}

fn bellmanFordAlgorithm(
    allocator: Allocator,
    augmented_vertex_count: usize,
    edges: []const Edge,
    source_vertex: usize
) !?ArrayList(f64) {
    var distances = ArrayList(f64).init(allocator);
    try distances.resize(augmented_vertex_count);

    for (distances.items, 0..) |*dist, i| {
        dist.* = if (i == source_vertex) 0.0 else INF;
    }

    // Relax the edges (augmented_vertex_count - 1) times
    var updated = true;
    for (0..augmented_vertex_count - 1) |_| {
        if (!updated) break;
        updated = false;

        for (edges) |edge| {
            if (distances.items[edge.u] != INF and
                distances.items[edge.u] + edge.weight < distances.items[edge.v]) {
                distances.items[edge.v] = distances.items[edge.u] + edge.weight;
                updated = true;
            }
        }
    }

    // Check for negative cycles in the graph
    for (edges) |edge| {
        if (distances.items[edge.u] != INF and
            distances.items[edge.u] + edge.weight < distances.items[edge.v]) {
            distances.deinit();
            return null; // Indicates a negative cycle has been detected
        }
    }

    return distances;
}

fn dijkstraAlgorithm(
    allocator: Allocator,
    vertex_count: usize,
    reweighted_adjacencies: *const AutoHashMap(usize, ArrayList(VertexAndWeight)),
    source_vertex: usize,
    values: []const f64,
) !?ArrayList(f64) {
    var distances = ArrayList(f64).init(allocator);
    try distances.resize(vertex_count);

    for (distances.items, 0..) |*dist, i| {
        dist.* = if (i == source_vertex) 0.0 else INF;
    }

    var priority_queue = PriorityQueue(WeightAndVertex, void, WeightAndVertex.compare).init(allocator, {});
    defer priority_queue.deinit();

    try priority_queue.add(WeightAndVertex{ .weight = 0.0, .vertex = source_vertex });

    var final_distances = ArrayList(f64).init(allocator);
    try final_distances.resize(vertex_count);

    for (final_distances.items) |*dist| {
        dist.* = INF;
    }

    while (priority_queue.removeOrNull()) |weight_and_vertex| {
        const vertex = weight_and_vertex.vertex;
        if (weight_and_vertex.weight > distances.items[vertex]) {
            continue;
        }

        // Store the final shortest path distance, translated back to the distance in the original graph
        if (final_distances.items[vertex] == INF) {
            if (distances.items[vertex] == INF) {
                // This should not happen, but is included as a safety check
                final_distances.items[vertex] = INF;
            } else {
                // Translate distance back to its original weight: d(u,v) = d'(u,v) - h[u] + h[v]
                final_distances.items[vertex] = distances.items[vertex] - values[source_vertex] + values[vertex];
            }
        }

        // Relax the edges outgoing from vertex
        if (reweighted_adjacencies.get(vertex)) |adjacencies| {
            for (adjacencies.items) |pair| {
                if (distances.items[vertex] != INF and
                    distances.items[vertex] + pair.weight < distances.items[pair.v]) {
                    distances.items[pair.v] = distances.items[vertex] + pair.weight;
                    try priority_queue.add(WeightAndVertex{ .weight = distances.items[pair.v], .vertex = pair.v });
                }
            }
        }
    }

    // Translate distance back to its original weight for any remaining reachable vertices
    for (0..vertex_count) |i| {
        if (final_distances.items[i] == INF and distances.items[i] != INF) {
            final_distances.items[i] = distances.items[i] - values[source_vertex] + values[i];
        }
    }

    distances.deinit();
    return final_distances;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // The element (i, j) is the weight of the edge from vertex i to vertex j.
    // INF, for infinity, means that there is no edge from vertex i to vertex j.
    const graph = [_][]const f64{
        &[_]f64{ 0.0, -5.0, 2.0, 3.0 },
        &[_]f64{ INF, 0.0, 4.0, INF },
        &[_]f64{ INF, INF, 0.0, 1.0 },
        &[_]f64{ INF, INF, INF, 0.0 },
    };

    if (try johnsonsAlgorithm(allocator, &graph)) |result| {
        defer {
            for (result.items) |*row| {
                row.deinit();
            }
            result.deinit();
        }

        std.debug.print("All pairs shortest paths:\n", .{});
        std.debug.print("The element (i, j) is the shortest path between vertex i and vertex j.\n", .{});

        for (result.items) |row| {
            std.debug.print("[", .{});
            for (row.items) |number| {
                if (number == INF) {
                    std.debug.print("INF ", .{});
                } else {
                    std.debug.print("{d} ", .{number});
                }
            }
            std.debug.print("]\n", .{});
        }
    } else {
        std.debug.print("A negative cycle was detected in the graph.\n", .{});
    }
}
