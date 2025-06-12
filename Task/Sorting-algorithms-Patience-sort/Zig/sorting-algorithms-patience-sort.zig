const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const PriorityQueue = std.PriorityQueue;

// Pile structure to represent a stack of items
fn Pile(comptime T: type) type {
    return struct {
        values: ArrayList(T),

        const Self = @This();

        fn init(allocator: Allocator) Self {
            return Self{
                .values = ArrayList(T).init(allocator),
            };
        }

        fn deinit(self: *Self) void {
            self.values.deinit();
        }

        fn push(self: *Self, value: T) !void {
            try self.values.append(value);
        }

        fn pop(self: *Self) ?T {
            if (self.values.items.len == 0) return null;
            return self.values.pop();
        }

        fn top(self: *const Self) ?T {
            if (self.values.items.len == 0) return null;
            return self.values.items[self.values.items.len - 1];
        }

        fn isEmpty(self: *const Self) bool {
            return self.values.items.len == 0;
        }
    };
}

// Compare function for priority queue (min-heap)
fn pileGreaterThan(comptime T: type) type {
    return struct {
        pub fn compare(context: void, a: *const Pile(T), b: *const Pile(T)) std.math.Order {
            _ = context;
            const a_top = a.top() orelse return .lt;
            const b_top = b.top() orelse return .gt;
            return if (a_top > b_top) .lt else if (a_top < b_top) .gt else .eq;
        }
    };
}

// Patience sort implementation
fn patienceSort(comptime T: type, allocator: Allocator, slice: []T) !void {
    const PileT = Pile(T);
    var piles = ArrayList(*PileT).init(allocator);
    defer {
        // Clean up all piles regardless of how we exit the function
        for (piles.items) |pile| {
            pile.deinit();
            allocator.destroy(pile);
        }
        piles.deinit();
    }

    // Sort into piles
    for (slice) |item| {
        // Try to find an existing pile to add to
        var added = false;
        for (piles.items) |pile| {
            if (pile.top()) |top| {
                if (top > item) {
                    try pile.push(item);
                    added = true;
                    break;
                }
            }
        }

        // If no suitable pile found, create a new one
        if (!added) {
            var new_pile = try allocator.create(PileT);
            errdefer allocator.destroy(new_pile);

            new_pile.* = PileT.init(allocator);
            errdefer new_pile.deinit();

            try new_pile.push(item);
            try piles.append(new_pile);
        }
    }

    // Create a priority queue for efficient merging
    var queue = PriorityQueue(*PileT, void, pileGreaterThan(T).compare).init(allocator, {});
    defer queue.deinit();

    // Add all piles to the priority queue
    for (piles.items) |pile| {
        try queue.add(pile);
    }

    // Merge piles back into the original slice
    var i: usize = 0;
    while (queue.count() > 0) {
        const smallest_pile = queue.remove();
        if (smallest_pile.pop()) |value| {
            slice[i] = value;
            i += 1;

            if (!smallest_pile.isEmpty()) {
                try queue.add(smallest_pile);
            }
        }
    }

    std.debug.assert(i == slice.len);
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var a = [_]i32{ 4, 65, 2, -31, 0, 99, 83, 782, 1 };
    try patienceSort(i32, allocator, &a);

    const stdout = std.io.getStdOut().writer();
    try stdout.print("Sorted array: ", .{});
    for (a, 0..) |value, i| {
        try stdout.print("{}", .{value});
        if (i < a.len - 1) {
            try stdout.print(", ", .{});
        }
    }
    try stdout.print("\n", .{});
}
