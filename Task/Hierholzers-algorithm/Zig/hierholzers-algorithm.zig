const std = @import("std");

fn printCircuit(adj: []const []const u32, allocator: std.mem.Allocator) !void {
    // adj represents the adjacency list of the directed graph
    // edge_count represents the number of edges emerging from a vertex
    var edge_count = std.AutoHashMap(u32, u32).init(allocator);
    defer edge_count.deinit();

    for (adj, 0..) |edges, i| {
        // find the count of edges to keep track of unused edges
        try edge_count.put(@intCast(i), @intCast(edges.len));
    }

    if (adj.len == 0) return; // empty graph

    // Maintain a stack to keep vertices
    var curr_path = std.ArrayList(u32).init(allocator);
    defer curr_path.deinit();

    // vector to store final circuit
    var circuit = std.ArrayList(u32).init(allocator);
    defer circuit.deinit();

    // Create mutable copies of adjacency lists
    var adj_mutable = try allocator.alloc(std.ArrayList(u32), adj.len);
    defer {
        for (adj_mutable) |*list| {
            list.deinit();
        }
        allocator.free(adj_mutable);
    }

    for (adj, 0..) |edges, i| {
        adj_mutable[i] = std.ArrayList(u32).init(allocator);
        try adj_mutable[i].appendSlice(edges);
    }

    // start from any vertex
    try curr_path.append(0);
    var curr_v: u32 = 0; // Current vertex

    while (curr_path.items.len > 0) {
        // If there's remaining edge
        if (edge_count.get(curr_v).? > 0) {
            // Push the vertex
            try curr_path.append(curr_v);

            // Find the next vertex using an edge
            const next_v = adj_mutable[curr_v].items[adj_mutable[curr_v].items.len - 1];

            // and remove that edge
            edge_count.put(curr_v, edge_count.get(curr_v).? - 1) catch unreachable;
            _ = adj_mutable[curr_v].pop();

            // Move to next vertex
            curr_v = next_v;
        } else {
            // back-track to find remaining circuit
            try circuit.append(curr_v);

            // Back-tracking
            curr_v = curr_path.items[curr_path.items.len - 1];
            _ = curr_path.pop();
        }
    }

    // we've got the circuit, now print it in reverse
    const stdout = std.io.getStdOut().writer();
    var i: usize = circuit.items.len;
    while (i > 0) {
        i -= 1;
        try stdout.print("{}", .{circuit.items[i]});
        if (i > 0) try stdout.print(" -> ", .{});
    }
    try stdout.print("\n", .{});
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    // First adjacency list
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var adj1 = try allocator.alloc([]const u32, 3);
    defer allocator.free(adj1);

    adj1[0] = &[_]u32{1};
    adj1[1] = &[_]u32{2};
    adj1[2] = &[_]u32{0};
    try printCircuit(adj1, allocator);

    // Second adjacency list
    var adj2 = try allocator.alloc([]const u32, 7);
    defer allocator.free(adj2);

    adj2[0] = &[_]u32{1, 6};
    adj2[1] = &[_]u32{2};
    adj2[2] = &[_]u32{0, 3};
    adj2[3] = &[_]u32{4};
    adj2[4] = &[_]u32{2, 5};
    adj2[5] = &[_]u32{0};
    adj2[6] = &[_]u32{4};
    try printCircuit(adj2, allocator);
}
