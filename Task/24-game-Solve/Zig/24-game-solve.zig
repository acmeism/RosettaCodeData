const std = @import("std");
const print = std.debug.print;
const ArrayList = std.ArrayList;
const HashMap = std.HashMap;
const Allocator = std.mem.Allocator;

const Operator = enum {
    sub,
    plus,
    mul,
    div,
};

const Factor = struct {
    content: []const u8,
    value: i32,

    fn deinit(self: Factor, allocator: Allocator) void {
        allocator.free(self.content);
    }
};

fn apply(allocator: Allocator, op: Operator, left: []const Factor, right: []const Factor) !ArrayList(Factor) {
    var ret = ArrayList(Factor).init(allocator);

    for (left) |l| {
        for (right) |r| {
            switch (op) {
                .sub => {
                    if (l.value > r.value) {
                        const content = try std.fmt.allocPrint(allocator, "({s} - {s})", .{ l.content, r.content });
                        try ret.append(Factor{
                            .content = content,
                            .value = l.value - r.value,
                        });
                    }
                },
                .plus => {
                    const content = try std.fmt.allocPrint(allocator, "({s} + {s})", .{ l.content, r.content });
                    try ret.append(Factor{
                        .content = content,
                        .value = l.value + r.value,
                    });
                },
                .mul => {
                    const content = try std.fmt.allocPrint(allocator, "({s} x {s})", .{ l.content, r.content });
                    try ret.append(Factor{
                        .content = content,
                        .value = l.value * r.value,
                    });
                },
                .div => {
                    if (l.value >= r.value and r.value > 0 and @rem(l.value, r.value) == 0) {
                        const content = try std.fmt.allocPrint(allocator, "({s} / {s})", .{ l.content, r.content });
                        try ret.append(Factor{
                            .content = content,
                            .value = @divTrunc(l.value, r.value),
                        });
                    }
                },
            }
        }
    }

    return ret;
}

fn calc(allocator: Allocator, ops: [3]Operator, numbers: [4]i32) !ArrayList(Factor) {
    var current_factors = ArrayList(Factor).init(allocator);
    defer {
        for (current_factors.items) |factor| {
            factor.deinit(allocator);
        }
        current_factors.deinit();
    }

    // Initialize with first number
    const initial_content = try std.fmt.allocPrint(allocator, "{}", .{numbers[0]});
    try current_factors.append(Factor{
        .content = initial_content,
        .value = numbers[0],
    });

    // Process each operation
    for (ops, 0..) |op, i| {
        var next_factors = ArrayList(Factor).init(allocator);
        defer {
            for (next_factors.items) |factor| {
                factor.deinit(allocator);
            }
            next_factors.deinit();
        }

        const mono_content = try std.fmt.allocPrint(allocator, "{}", .{numbers[i + 1]});
        defer allocator.free(mono_content);
        const mono_factor = Factor{
            .content = mono_content,
            .value = numbers[i + 1],
        };
        const mono_slice = &[_]Factor{mono_factor};

        switch (op) {
            .mul, .plus => {
                var applied = try apply(allocator, op, current_factors.items, mono_slice);
                defer applied.deinit();
                try next_factors.appendSlice(applied.items);
            },
            .div, .sub => {
                var applied1 = try apply(allocator, op, current_factors.items, mono_slice);
                defer applied1.deinit();
                try next_factors.appendSlice(applied1.items);

                var applied2 = try apply(allocator, op, mono_slice, current_factors.items);
                defer applied2.deinit();
                try next_factors.appendSlice(applied2.items);
            },
        }

        // Clear current factors and move next_factors to current_factors
        for (current_factors.items) |factor| {
            factor.deinit(allocator);
        }
        current_factors.clearRetainingCapacity();

        // Move ownership from next_factors to current_factors
        try current_factors.appendSlice(next_factors.items);
        next_factors.clearRetainingCapacity(); // Don't deinit the items, we moved them
    }

    // Create result and transfer ownership
    var result = ArrayList(Factor).init(allocator);
    try result.appendSlice(current_factors.items);
    current_factors.clearRetainingCapacity(); // Don't deinit, we transferred ownership

    return result;
}

const OpIter = struct {
    index: usize,

    const OPTIONS = [_]Operator{ .mul, .sub, .plus, .div };

    fn init() OpIter {
        return OpIter{ .index = 0 };
    }

    fn next(self: *OpIter) ?[3]Operator {
        if (self.index >= 64) {
            return null;
        }

        const f1 = OPTIONS[(self.index & (3 << 4)) >> 4];
        const f2 = OPTIONS[(self.index & (3 << 2)) >> 2];
        const f3 = OPTIONS[(self.index & (3 << 0)) >> 0];

        self.index += 1;
        return [3]Operator{ f1, f2, f3 };
    }
};

fn orders() [24][4]usize {
    return [24][4]usize{
        [4]usize{ 0, 1, 2, 3 },
        [4]usize{ 0, 1, 3, 2 },
        [4]usize{ 0, 2, 1, 3 },
        [4]usize{ 0, 2, 3, 1 },
        [4]usize{ 0, 3, 1, 2 },
        [4]usize{ 0, 3, 2, 1 },
        [4]usize{ 1, 0, 2, 3 },
        [4]usize{ 1, 0, 3, 2 },
        [4]usize{ 1, 2, 0, 3 },
        [4]usize{ 1, 2, 3, 0 },
        [4]usize{ 1, 3, 0, 2 },
        [4]usize{ 1, 3, 2, 0 },
        [4]usize{ 2, 0, 1, 3 },
        [4]usize{ 2, 0, 3, 1 },
        [4]usize{ 2, 1, 0, 3 },
        [4]usize{ 2, 1, 3, 0 },
        [4]usize{ 2, 3, 0, 1 },
        [4]usize{ 2, 3, 1, 0 },
        [4]usize{ 3, 0, 1, 2 },
        [4]usize{ 3, 0, 2, 1 },
        [4]usize{ 3, 1, 0, 2 },
        [4]usize{ 3, 1, 2, 0 },
        [4]usize{ 3, 2, 0, 1 },
        [4]usize{ 3, 2, 1, 0 },
    };
}

fn applyOrder(numbers: [4]i32, order: [4]usize) [4]i32 {
    return [4]i32{ numbers[order[0]], numbers[order[1]], numbers[order[2]], numbers[order[3]] };
}

fn solutions(allocator: Allocator, numbers: [4]i32) !ArrayList(Factor) {
    var ret = ArrayList(Factor).init(allocator);
    var hash_set = HashMap([]const u8, void, std.hash_map.StringContext, std.hash_map.default_max_load_percentage).init(allocator);
    defer {
        // Free all keys in the hash map
        var iterator = hash_set.iterator();
        while (iterator.next()) |entry| {
            allocator.free(entry.key_ptr.*);
        }
        hash_set.deinit();
    }

    var op_iter = OpIter.init();
    while (op_iter.next()) |ops| {
        const all_orders = orders();
        for (all_orders) |order| {
            const reordered_numbers = applyOrder(numbers, order);
            var results = calc(allocator, ops, reordered_numbers) catch continue;
            defer {
                for (results.items) |factor| {
                    factor.deinit(allocator);
                }
                results.deinit();
            }

            for (results.items) |factor| {
                if (factor.value == 24) {
                    // Check if we've seen this content before
                    if (hash_set.contains(factor.content)) {
                        continue;
                    }

                    // Add to hash set with a duplicated key
                    const key_copy = try allocator.dupe(u8, factor.content);
                    try hash_set.put(key_copy, {});

                    // Add to results with a duplicated content
                    try ret.append(Factor{
                        .content = try allocator.dupe(u8, factor.content),
                        .value = factor.value,
                    });
                }
            }
        }
    }

    return ret;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Hard-coded input: 5598
    const nums = [4]i32{ 5, 5, 9, 8 };

    var sols = solutions(allocator, nums) catch {
        print("Error computing solutions\n", .{});
        return;
    };
    defer {
        for (sols.items) |factor| {
            factor.deinit(allocator);
        }
        sols.deinit();
    }

    const len = sols.items.len;
    if (len == 0) {
        print("no solution for {}, {}, {}, {}\n", .{ nums[0], nums[1], nums[2], nums[3] });
        return;
    }

    print("solutions for {}, {}, {}, {}\n", .{ nums[0], nums[1], nums[2], nums[3] });
    for (sols.items) |s| {
        print("{s}\n", .{s.content});
    }
    print("{} solutions found\n", .{len});
}
