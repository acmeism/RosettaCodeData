const std = @import("std");

const Item = struct {
    name: []const u8,
    weight: usize,
    value: usize,
};

fn knapsack01_dyn(allocator: std.mem.Allocator, items: []const Item, max_weight: usize) !std.ArrayList(*const Item) {
    // Create 2D array for dynamic programming
    var best_value = try allocator.alloc([]usize, items.len + 1);
    defer allocator.free(best_value);

    for (best_value) |*row| {
        row.* = try allocator.alloc(usize, max_weight + 1);
    }
    defer {
        for (best_value) |row| {
            allocator.free(row);
        }
    }

    // Initialize with zeros
    for (best_value) |row| {
        @memset(row, 0);
    }

    // Fill the table
    for (items, 0..) |it, i| {
        for (1..max_weight + 1) |w| {
            if (it.weight > w) {
                best_value[i + 1][w] = best_value[i][w];
            } else {
                best_value[i + 1][w] = @max(
                    best_value[i][w],
                    best_value[i][w - it.weight] + it.value
                );
            }
        }
    }

    // Backtrack to find selected items
    var result = std.ArrayList(*const Item).init(allocator);
    var left_weight = max_weight;

    var i: usize = items.len;
    while (i > 0) : (i -= 1) {
        if (best_value[i][left_weight] != best_value[i - 1][left_weight]) {
            try result.append(&items[i - 1]);
            left_weight -= items[i - 1].weight;
        }
    }

    return result;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const MAX_WEIGHT: usize = 400;

    const ITEMS = [_]Item{
        .{ .name = "map", .weight = 9, .value = 150 },
        .{ .name = "compass", .weight = 13, .value = 35 },
        .{ .name = "water", .weight = 153, .value = 200 },
        .{ .name = "sandwich", .weight = 50, .value = 160 },
        .{ .name = "glucose", .weight = 15, .value = 60 },
        .{ .name = "tin", .weight = 68, .value = 45 },
        .{ .name = "banana", .weight = 27, .value = 60 },
        .{ .name = "apple", .weight = 39, .value = 40 },
        .{ .name = "cheese", .weight = 23, .value = 30 },
        .{ .name = "beer", .weight = 52, .value = 10 },
        .{ .name = "suntancream", .weight = 11, .value = 70 },
        .{ .name = "camera", .weight = 32, .value = 30 },
        .{ .name = "T-shirt", .weight = 24, .value = 15 },
        .{ .name = "trousers", .weight = 48, .value = 10 },
        .{ .name = "umbrella", .weight = 73, .value = 40 },
        .{ .name = "waterproof trousers", .weight = 42, .value = 70 },
        .{ .name = "waterproof overclothes", .weight = 43, .value = 75 },
        .{ .name = "note-case", .weight = 22, .value = 80 },
        .{ .name = "sunglasses", .weight = 7, .value = 20 },
        .{ .name = "towel", .weight = 18, .value = 12 },
        .{ .name = "socks", .weight = 4, .value = 50 },
        .{ .name = "book", .weight = 30, .value = 10 },
    };

    var items = try knapsack01_dyn(allocator, &ITEMS, MAX_WEIGHT);
    defer items.deinit();

    // Print in reverse order (to match original)
    const stdout = std.io.getStdOut().writer();
    var i: usize = items.items.len;
    while (i > 0) : (i -= 1) {
        try stdout.print("{s}\n", .{items.items[i - 1].name});
    }

    // Calculate totals
    var total_weight: usize = 0;
    var total_value: usize = 0;
    for (items.items) |item| {
        total_weight += item.weight;
        total_value += item.value;
    }

    try stdout.print("Total weight: {}\n", .{total_weight});
    try stdout.print("Total value: {}\n", .{total_value});
}
