// floyd_warshall.zig
const std = @import("std");

const F64_INF = std.math.inf(f64);

fn idx(i: usize, j: usize, n: usize) usize {
    return i * n + j;
}

fn printResult(dist: []const f64, next: []const usize, n: usize) void {
    std.debug.print("(pair, dist, path)\n", .{});
    for (0..n) |i| {
        for (0..n) |j| {
            if (i == j) continue;

            const @"u0" = i + 1;
            const v0 = j + 1;

            std.debug.print("({d} -> {d}, {d}, ", .{
                @"u0", v0, dist[idx(i, j, n)],
            });

            var u = @"u0";
            std.debug.print("{d}", .{u});
            while (u != v0) {
                u = next[idx(u - 1, v0 - 1, n)];
                std.debug.print(" -> {d}", .{u});
            }
            std.debug.print(")\n", .{});
        }
    }
}

fn solve(
    allocator: std.mem.Allocator,
    edges: []const [3]i64, // (u,v,w) 1‑based
    n: usize,
) !void {
    // Allocate matrices
    var dist   = try allocator.alloc(f64,   n * n);
    defer allocator.free(dist);

    var next_v = try allocator.alloc(usize, n * n);
    defer allocator.free(next_v);

    // Initialise
    for (dist)|*d|  d.* = F64_INF;
    for (next_v)|*x| x.* = 0;

    // Edge weights
    for (edges) |e| {
        const u = @as(usize, @intCast(e[0] - 1));
        const v = @as(usize, @intCast(e[1] - 1));
        dist[idx(u, v, n)] = @as(f64, @floatFromInt(e[2]));
    }

    // Successor matrix
    for (0..n) |i| {
        for (0..n) |j| {
            if (i != j) next_v[idx(i, j, n)] = j + 1; // 1‑based
        }
    }

    // Floyd–Warshall
    for (0..n) |k| {
        for (0..n) |i| {
            for (0..n) |j| {
                const dik = dist[idx(i, k, n)];
                const dkj = dist[idx(k, j, n)];
                if (std.math.isFinite(dik) and std.math.isFinite(dkj)) {
                    const alt = dik + dkj;
                    const pos = idx(i, j, n);
                    if (alt < dist[pos]) {
                        dist[pos]   = alt;
                        next_v[pos] = next_v[idx(i, k, n)];
                    }
                }
            }
        }
    }

    printResult(dist, next_v, n);
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const alloc = gpa.allocator();

    const edges = [_][3]i64{
        .{ 1, 3, -2 },
        .{ 2, 1,  4 },
        .{ 2, 3,  3 },
        .{ 3, 4,  2 },
        .{ 4, 2, -1 },
    };

    try solve(alloc, edges[0..], 4);
}
