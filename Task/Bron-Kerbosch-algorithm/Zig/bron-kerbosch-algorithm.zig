const std = @import("std");

const Edge = struct {
    start: []const u8,
    end: []const u8,
};

fn printVector(vec: []const []const u8) !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("[", .{});
    for (vec, 0..) |element, i| {
        if (i < vec.len - 1) {
            try stdout.print("{s}, ", .{element});
        } else {
            try stdout.print("{s}", .{element});
        }
    }
    try stdout.print("]", .{});
}

fn print2DVector(vecs: []const []const []const u8) !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("[", .{});
    for (vecs, 0..) |vec, i| {
        try printVector(vec);
        if (i < vecs.len - 1) {
            try stdout.print(", ", .{});
        }
    }
    try stdout.print("]\n", .{});
}

fn bronKerbosch(
    allocator: std.mem.Allocator,
    currentClique: *std.StringArrayHashMap([]const u8),
    candidates: *std.StringArrayHashMap([]const u8),
    processedVertices: *std.StringArrayHashMap([]const u8),
    graph: *std.StringArrayHashMap(std.StringHashMap(void)),
    cliques: *std.ArrayList([]const []const u8),
) !void {
    if (candidates.count() == 0 and processedVertices.count() == 0) {
        if (currentClique.count() > 2) {
            var cliqueList = std.ArrayList([]const u8).init(allocator);
            var it = currentClique.iterator();
            while (it.next()) |entry| {
                try cliqueList.append(entry.key_ptr.*);
            }
            const cliqueSlice = try cliqueList.toOwnedSlice();
            try cliques.append(cliqueSlice);
        }
        return;
    }

    // Find pivot with maximum degree
    var pivot: []const u8 = "";
    var maxDegree: usize = 0;
    var it = graph.iterator();
    while (it.next()) |entry| {
        const vertex = entry.key_ptr.*;
        const degree = entry.value_ptr.count();
        if (degree > maxDegree or (maxDegree == 0 and pivot.len == 0)) {
            maxDegree = degree;
            pivot = vertex;
        }
    }

    // Candidates not connected to pivot
    var possibles = std.StringArrayHashMap([]const u8).init(allocator);
    defer possibles.deinit();
    var cand_it = candidates.iterator();
    while (cand_it.next()) |entry| {
        const vertex = entry.key_ptr.*;
        const is_connected = if (graph.get(vertex)) |neighbors|
            neighbors.contains(pivot)
        else
            false;
        if (!is_connected) {
            try possibles.put(vertex, vertex);
        }
    }

    // Iterate over possible vertices
    var poss_it = possibles.iterator();
    while (poss_it.next()) |entry| {
        const vertex = entry.key_ptr.*;

        // New clique
        var newClique = std.StringArrayHashMap([]const u8).init(allocator);
        defer newClique.deinit();
        var clique_it = currentClique.iterator();
        while (clique_it.next()) |clique_entry| {
            try newClique.put(clique_entry.key_ptr.*, clique_entry.key_ptr.*);
        }
        try newClique.put(vertex, vertex);

        // New candidates (neighbors of vertex)
        var newCandidates = std.StringArrayHashMap([]const u8).init(allocator);
        defer newCandidates.deinit();
        if (graph.get(vertex)) |vertexNeighbors| {
            var cand_iter = candidates.iterator();
            while (cand_iter.next()) |cand| {
                if (vertexNeighbors.contains(cand.key_ptr.*)) {
                    try newCandidates.put(cand.key_ptr.*, cand.key_ptr.*);
                }
            }
        }

        // New processed vertices (neighbors of vertex)
        var newProcessed = std.StringArrayHashMap([]const u8).init(allocator);
        defer newProcessed.deinit();
        if (graph.get(vertex)) |vertexNeighbors| {
            var proc_it = processedVertices.iterator();
            while (proc_it.next()) |proc| {
                if (vertexNeighbors.contains(proc.key_ptr.*)) {
                    try newProcessed.put(proc.key_ptr.*, proc.key_ptr.*);
                }
            }
        }

        // Recursive call
        try bronKerbosch(allocator, &newClique, &newCandidates, &newProcessed, graph, cliques);

        // Move vertex from candidates to processed
        _ = candidates.*.swapRemove(vertex);         // swapRemove - O(1)
        // _ = candidates.*.orderedRemove(vertex);         // orderedRemove - O(N)
        try processedVertices.put(vertex, vertex);
    }
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const edges: []const Edge = &.{
        .{ .start = "a", .end = "b" },
        .{ .start = "b", .end = "a" },
        .{ .start = "a", .end = "c" },
        .{ .start = "c", .end = "a" },
        .{ .start = "b", .end = "c" },
        .{ .start = "c", .end = "b" },
        .{ .start = "d", .end = "e" },
        .{ .start = "e", .end = "d" },
        .{ .start = "d", .end = "f" },
        .{ .start = "f", .end = "d" },
        .{ .start = "e", .end = "f" },
        .{ .start = "f", .end = "e" },
    };

    // Initialize graph
    var graph = std.StringArrayHashMap(std.StringHashMap(void)).init(allocator);
    defer graph.deinit();
    for (edges) |edge| {
        if (!graph.contains(edge.start)) {
            try graph.put(edge.start, std.StringHashMap(void).init(allocator));
        }
        if (!graph.contains(edge.end)) {
            try graph.put(edge.end, std.StringHashMap(void).init(allocator));
        }
        if (graph.getPtr(edge.start)) |neighbors| {
            try neighbors.put(edge.end, {});
        }
        if (graph.getPtr(edge.end)) |neighbors| {
            try neighbors.put(edge.start, {});
        }
    }

    var currentClique = std.StringArrayHashMap([]const u8).init(allocator);
    defer currentClique.deinit();

    var candidates = std.StringArrayHashMap([]const u8).init(allocator);
    defer candidates.deinit();
    var graph_it = graph.iterator();
    while (graph_it.next()) |entry| {
        try candidates.put(entry.key_ptr.*, entry.key_ptr.*);
    }

    var processedVertices = std.StringArrayHashMap([]const u8).init(allocator);
    defer processedVertices.deinit();

    var cliques = std.ArrayList([]const []const u8).init(allocator);
    defer cliques.deinit();

    try bronKerbosch(allocator, &currentClique, &candidates, &processedVertices, &graph, &cliques);

    // Sort cliques
    std.sort.heap([]const []const u8, cliques.items, {}, struct {
        fn lessThan(_: void, a: []const []const u8, b: []const []const u8) bool {
            const minLen = @min(a.len, b.len);
            for (0..minLen) |i| {
                if (!std.mem.eql(u8, a[i], b[i])) {
                    return std.mem.lessThan(u8, a[i], b[i]);
                }
            }
            return a.len < b.len;
        }
    }.lessThan);

    try print2DVector(cliques.items);
}
