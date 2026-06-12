const std = @import("std");
const print = std.debug.print;
const ArrayList = std.ArrayList;
const HashMap = std.HashMap;
const HashSet = std.HashMap;
const Allocator = std.mem.Allocator;

// Hash map for string -> set of strings (dependencies)
const StringSet = HashSet([]const u8, void, std.hash_map.StringContext, std.hash_map.default_max_load_percentage);
const DependencyMap = HashMap([]const u8, StringSet, std.hash_map.StringContext, std.hash_map.default_max_load_percentage);

fn printVector( vec: *const ArrayList([]const u8)) void {
    if (vec.items.len == 0) {
        print("[]" , .{} );
        return;
    }

    print("[" , .{} );
    for (vec.items[0..vec.items.len - 1]) |item| {
        print("{s}, ", .{item});
    }
    print("{s}]", .{vec.items[vec.items.len - 1]});
}

fn printSet(set: *const StringSet) void {
    var iterator = set.iterator();
    var first = true;
    while (iterator.next()) |entry| {
        if (!first) {
            print(", " , .{});
        }
        print("{s}", .{entry.key_ptr.*});
        first = false;
    }
}

// Return the top levels of the dependency graph
fn topLevels(allocator: Allocator, data: *const DependencyMap) !StringSet {
    var data_copy = DependencyMap.init(allocator);
    defer {
        var iter = data_copy.iterator();
        while (iter.next()) |entry| {
            entry.value_ptr.deinit();
        }
        data_copy.deinit();
    }

    // Deep copy the data and remove self dependencies
    var data_iter = data.iterator();
    while (data_iter.next()) |entry| {
        var new_set = StringSet.init(allocator);
        var set_iter = entry.value_ptr.iterator();
        while (set_iter.next()) |set_entry| {
            if (!std.mem.eql(u8, entry.key_ptr.*, set_entry.key_ptr.*)) {
                try new_set.put(set_entry.key_ptr.*, {});
            }
        }
        try data_copy.put(entry.key_ptr.*, new_set);
    }

    var dependencies = ArrayList([]const u8).init(allocator);
    defer dependencies.deinit();

    // Collect all dependencies
    var copy_iter = data_copy.iterator();
    while (copy_iter.next()) |entry| {
        var dep_iter = entry.value_ptr.iterator();
        while (dep_iter.next()) |dep_entry| {
            try dependencies.append(dep_entry.key_ptr.*);
        }
    }

    var result = StringSet.init(allocator);

    // Add all keys to result
    var key_iter = data_copy.iterator();
    while (key_iter.next()) |entry| {
        try result.put(entry.key_ptr.*, {});
    }

    // Remove dependencies from result
    for (dependencies.items) |dependency| {
        _ = result.remove(dependency);
    }

    return result;
}

// Return the set of top level items in topological order
fn topExtraction(allocator: Allocator, data: *const DependencyMap, tops: *const StringSet) !ArrayList(ArrayList([]const u8)) {
    var data_copy = DependencyMap.init(allocator);
    defer {
        var iter = data_copy.iterator();
        while (iter.next()) |entry| {
            entry.value_ptr.deinit();
        }
        data_copy.deinit();
    }

    // Deep copy data and remove self dependencies
    var data_iter = data.iterator();
    while (data_iter.next()) |entry| {
        var new_set = StringSet.init(allocator);
        var set_iter = entry.value_ptr.iterator();
        while (set_iter.next()) |set_entry| {
            if (!std.mem.eql(u8, entry.key_ptr.*, set_entry.key_ptr.*)) {
                try new_set.put(set_entry.key_ptr.*, {});
            }
        }
        try data_copy.put(entry.key_ptr.*, new_set);
    }

    var current_tops = StringSet.init(allocator);
    defer current_tops.deinit();

    // Copy initial tops
    var tops_iter = tops.iterator();
    while (tops_iter.next()) |entry| {
        try current_tops.put(entry.key_ptr.*, {});
    }

    var dependencies = StringSet.init(allocator);
    defer dependencies.deinit();

    var cumulative_dependencies = ArrayList(StringSet).init(allocator);
    defer {
        for (cumulative_dependencies.items) |*set| {
            set.deinit();
        }
        cumulative_dependencies.deinit();
    }

    while (true) {
        // Deep copy current_tops for cumulative_dependencies
        var tops_copy = StringSet.init(allocator);
        var copy_iter = current_tops.iterator();
        while (copy_iter.next()) |entry| {
            try tops_copy.put(entry.key_ptr.*, {});
        }
        try cumulative_dependencies.append(tops_copy);

        dependencies.clearAndFree();
        var current_iter = current_tops.iterator();
        while (current_iter.next()) |entry| {
            if (data_copy.get(entry.key_ptr.*)) |deps| {
                var dep_iter = deps.iterator();
                while (dep_iter.next()) |dep_entry| {
                    try dependencies.put(dep_entry.key_ptr.*, {});
                }
            }
        }

        current_tops.clearAndFree();
        var dep_iter = dependencies.iterator();
        while (dep_iter.next()) |entry| {
            try current_tops.put(entry.key_ptr.*, {});
        }

        if (dependencies.count() == 0) {
            break;
        }
    }

    var result = ArrayList(ArrayList([]const u8)).init(allocator);
    var accumulator = StringSet.init(allocator);
    defer accumulator.deinit();

    var i: usize = cumulative_dependencies.items.len;
    while (i > 0) {
        i -= 1;

        var current_dependencies = StringSet.init(allocator);
        defer current_dependencies.deinit();

        // Copy cumulative_dependencies[i]
        var cum_iter = cumulative_dependencies.items[i].iterator();
        while (cum_iter.next()) |entry| {
            try current_dependencies.put(entry.key_ptr.*, {});
        }

        // Remove accumulator items
        var acc_iter = accumulator.iterator();
        while (acc_iter.next()) |entry| {
            _ = current_dependencies.remove(entry.key_ptr.*);
        }

        // Convert to sorted vector
        var current_dependencies_vec = ArrayList([]const u8).init(allocator);
        var curr_iter = current_dependencies.iterator();
        while (curr_iter.next()) |entry| {
            try current_dependencies_vec.append(entry.key_ptr.*);
        }

        // Sort the vector
        std.mem.sort([]const u8, current_dependencies_vec.items, {}, struct {
            fn lessThan(_: void, a: []const u8, b: []const u8) bool {
                return std.mem.order(u8, a, b) == .lt;
            }
        }.lessThan);

        try result.append(current_dependencies_vec);

        // Add to accumulator
        var cum_iter2 = cumulative_dependencies.items[i].iterator();
        while (cum_iter2.next()) |entry| {
            try accumulator.put(entry.key_ptr.*, {});
        }
    }

    return result;
}

fn printCompilationOrder(  order: *const ArrayList(ArrayList([]const u8))) void {
    if (order.items.len == 0) return;

    print("First: " , .{});
    printVector( &order.items[0]);

    for (order.items[1..]) |*level| {
        print("    Then: " , .{});
        printVector( level);
    }
    print("\n" , .{} );
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Create the dependency map
    var data = DependencyMap.init(allocator);
    defer {
        var iter = data.iterator();
        while (iter.next()) |entry| {
            entry.value_ptr.deinit();
        }
        data.deinit();
    }

    // Helper function to create a set from array
    const createSet = struct {
        fn create(alloc: Allocator, items: []const []const u8) !StringSet {
            var set = StringSet.init(alloc);
            for (items) |item| {
                try set.put(item, {});
            }
            return set;
        }
    }.create;

    // Build the dependency data
    try data.put("top1", try createSet(allocator, &[_][]const u8{ "ip1", "des1", "ip2" }));
    try data.put("top2", try createSet(allocator, &[_][]const u8{ "ip2", "des1", "ip3" }));
    try data.put("des1", try createSet(allocator, &[_][]const u8{ "des1a", "des1b", "des1c" }));
    try data.put("des1a", try createSet(allocator, &[_][]const u8{ "des1a1", "des1a2" }));
    try data.put("des1c", try createSet(allocator, &[_][]const u8{ "des1c1", "extra1" }));
    try data.put("ip2", try createSet(allocator, &[_][]const u8{ "ip2a", "ip2b", "ip2c", "ipcommon" }));
    try data.put("ip1", try createSet(allocator, &[_][]const u8{ "ip1a", "ipcommon", "extra1" }));

    var tops = try topLevels(allocator, &data);
    defer tops.deinit();

    print("The top levels of the dependency graph are: " ,  .{});
    printSet(&tops);
    print("\n\n" , .{});

    // Process each top level individually
    var tops_iter = tops.iterator();
    while (tops_iter.next()) |entry| {
        print("The compilation order for top level '{s}' is:\n", .{entry.key_ptr.*});

        var single_top = StringSet.init(allocator);
        defer single_top.deinit();
        try single_top.put(entry.key_ptr.*, {});

        var order = try topExtraction(allocator, &data, &single_top);
        defer {
            for (order.items) |*level| {
                level.deinit();
            }
            order.deinit();
        }

        printCompilationOrder( &order);
    }

    // Process all top levels together if there are multiple
    if (tops.count() > 1) {
        print("The compilation order for top levels '" , .{} );
        printSet(&tops);
        print("' is:\n" , .{});

        var all_order = try topExtraction(allocator, &data, &tops);
        defer {
            for (all_order.items) |*level| {
                level.deinit();
            }
            all_order.deinit();
        }

        printCompilationOrder( &all_order);
    }

    // Process specific file
    const ip1_str = "ip1";
    print("The compilation order for file '{s}' is:\n", .{ip1_str});

    var ip1_set = StringSet.init(allocator);
    defer ip1_set.deinit();
    try ip1_set.put(ip1_str, {});

    var ip1_order = try topExtraction(allocator, &data, &ip1_set);
    defer {
        for (ip1_order.items) |*level| {
            level.deinit();
        }
        ip1_order.deinit();
    }

    printCompilationOrder( &ip1_order);
}
