const std = @import("std");
const PriorityQueue = std.PriorityQueue;
const Allocator = std.mem.Allocator;
const testing = std.testing;

/// wrapper for the task - stores task priority
/// along with the task name
const Task = struct {
    const Self = @This();

    priority: i32,
    name: []const u8,

    pub fn init(priority: i32, name: []const u8) Self {
        return Self{
            .priority = priority,
            .name = name,
        };
    }
};

/// Simple wrapper for the comparator function.
/// Each comparator function has the following signature:
///
/// fn(T, T) bool
const Comparator = struct {
    fn maxCompare(_: void, a: Task, b: Task) std.math.Order {
        return std.math.order(a.priority, b.priority);
    }

    fn minCompare(_: void, a: Task, b: Task) std.math.Order {
        return std.math.order(a.priority, b.priority);
    }
};

test "priority queue (max heap)" {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();
    var pq = PriorityQueue(Task, void, Comparator.maxCompare).init(allocator, {});
    defer pq.deinit();

    try pq.add(Task.init(3, "Clear drains"));
    try pq.add(Task.init(4, "Feed Cat"));
    try pq.add(Task.init(5, "Make tea"));
    try pq.add(Task.init(1, "Solve RC tasks"));
    try pq.add(Task.init(2, "Tax returns"));
    try testing.expectEqual(pq.count(), 5);

    std.debug.print("\n", .{});

    // execute the tasks in decreasing order of priority
    while (pq.count() != 0) {
        const task = pq.remove();
        std.debug.print("Executing: {s} (priority {d})\n", .{ task.name, task.priority });
    }
    std.debug.print("\n", .{});
}

test "priority queue (min heap)" {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();
    var pq = PriorityQueue(Task, void, Comparator.minCompare).init(allocator, {});
    defer pq.deinit();

    try pq.add(Task.init(3, "Clear drains"));
    try pq.add(Task.init(4, "Feed Cat"));
    try pq.add(Task.init(5, "Make tea"));
    try pq.add(Task.init(1, "Solve RC tasks"));
    try pq.add(Task.init(2, "Tax returns"));
    try testing.expectEqual(pq.count(), 5);

    std.debug.print("\n", .{});

    // execute the tasks in increasing order of priority
    while (pq.count() != 0) {
        const task = pq.remove();
        std.debug.print("Executing: {s} (priority {d})\n", .{ task.name, task.priority });
    }
    std.debug.print("\n", .{});
}
