const std = @import("std");

/// Solve the Traveling Salesman Problem using the Held--Karp algorithm (O(n^2·2^n)).
/// dist: square matrix of pairwise distances, dist[i][j] is the cost from i to j.
/// Returns a tuple {min_cost, tour}, where tour is a sequence of node indices
/// starting and ending at 0.
fn heldKarp(allocator: std.mem.Allocator, dist: []const []const i64) !struct { cost: i64, tour: []u32 } {
    const n = @as(u32,@intCast(dist.len));
    const N = @as(u32, 1) << @as(u5, @intCast(n)); // number of subsets
    const INF = std.math.maxInt(i64) / 4;

    // dp[mask][j] = min cost to start at 0, visit exactly the cities in mask, and end at j
    var dp = try allocator.alloc([]i64, N);
    defer allocator.free(dp);
    for (dp, 0..) |*row, i| {
        row.* = try allocator.alloc(i64, n);
        @memset(row.*, INF);
        defer if (i != N - 1) allocator.free(row.*);
    }
    defer allocator.free(dp[N - 1]);

    // parent[mask][j] = best predecessor of j in the optimal path for (mask, j)
    var parent = try allocator.alloc([]i32, N);
    defer allocator.free(parent);
    for (parent, 0..) |*row, i| {
        row.* = try allocator.alloc(i32, n);
        @memset(row.*, -1);
        defer if (i != N - 1) allocator.free(row.*);
    }
    defer allocator.free(parent[N - 1]);

    dp[1][0] = 0; // base case: mask=1<<0, at city 0, cost=0

    // Build up DP table
    var mask: u32 = 1;
    while (mask < N) : (mask += 1) {
        if ((mask & 1) == 0) continue; // we always include city 0 in the tour
        var j: u32 = 1;
        while (j < n) : (j += 1) {
            if ((mask & (@as(u32, 1) <<  @as(u5, @intCast(j)) ) ) == 0) continue;
            const prevMask = mask ^ (@as(u32, 1) << @as(u5, @intCast(j)));
            var k: u32 = 0;
            while (k < n) : (k += 1) {
                if (prevMask & (@as(u32, 1) << @as(u5, @intCast(k))   ) != 0) {
                    const cost = dp[prevMask][k] + dist[k][j];
                    if (cost < dp[mask][j]) {
                        dp[mask][j] = cost;
                        parent[mask][j] = @as(i32, @intCast(k));
                    }
                }
            }
        }
    }

    // Close the tour by returning to city 0
    const fullMask = N - 1;
    var minCost: i64 = INF;
    var lastCity: i32 = -1;
    var j: u32 = 1;
    while (j < n) : (j += 1) {
        const cost = dp[fullMask][j] + dist[j][0];
        if (cost < minCost) {
            minCost = cost;
            lastCity = @as(i32, @intCast(j));
        }
    }

    // Reconstruct the optimal tour
    var tour = std.ArrayList(u32).init(allocator);
    defer tour.deinit();

    var curMask = fullMask;
    var cur = lastCity;
    while (cur != -1) {
        try tour.append( @as(u32, @intCast(cur)));
        const p = parent[curMask][@as(usize, @intCast(cur))];
        curMask ^= (@as(u32, 1) << @as(u5, @intCast(cur)));
        cur = p;
    }
    try tour.append(0); // add the start city

    // Reverse the tour
    var i: usize = 0;
    var j_rev: usize = tour.items.len - 1;
    while (i < j_rev) {
        const temp = tour.items[i];
        tour.items[i] = tour.items[j_rev];
        tour.items[j_rev] = temp;
        i += 1;
        j_rev -= 1;
    }

    try tour.append(0); // return to start

    return .{ .cost = minCost, .tour = try tour.toOwnedSlice() };
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Example test case: 4 cities, symmetric distances
    const rows = 4;
    const cols = 4;
    var dist = try allocator.alloc([]i64, rows);
    defer allocator.free(dist);

    for (dist, 0..) |*row, i| {
        row.* = try allocator.alloc(i64, cols);
        defer if (i != rows - 1) allocator.free(row.*);
    }
    defer allocator.free(dist[rows - 1]);

    dist[0][0] = 0;  dist[0][1] = 2;  dist[0][2] = 9;  dist[0][3] = 10;
    dist[1][0] = 1;  dist[1][1] = 0;  dist[1][2] = 6;  dist[1][3] = 4;
    dist[2][0] = 15; dist[2][1] = 7;  dist[2][2] = 0;  dist[2][3] = 8;
    dist[3][0] = 6;  dist[3][1] = 3;  dist[3][2] = 12; dist[3][3] = 0;

    const result = try heldKarp(allocator, dist);
    defer allocator.free(result.tour);

    const stdout = std.io.getStdOut().writer();
    try stdout.print("Minimum tour cost: {}\n", .{result.cost});
    try stdout.print("Tour: ", .{});
    for (result.tour) |v| {
        try stdout.print("{} ", .{v});
    }
    try stdout.print("\n", .{});
}
