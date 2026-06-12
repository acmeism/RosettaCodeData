const std = @import("std");
const Allocator = std.mem.Allocator;

fn BinaryTree(comptime T: type) type {
    return struct {
        node: ?T,
        left_subtree: ?*Self,
        right_subtree: ?*Self,
        allocator: Allocator,

        const Self = @This();

        fn init(allocator: Allocator) Self {
            return Self{
                .node = null,
                .left_subtree = null,
                .right_subtree = null,
                .allocator = allocator,
            };
        }

        fn deinit(self: *Self) void {
            if (self.left_subtree) |left| {
                left.deinit();
                self.allocator.destroy(left);
            }
            if (self.right_subtree) |right| {
                right.deinit();
                self.allocator.destroy(right);
            }
        }

        fn insert(self: *Self, item: T) !void {
            if (self.node == null) {
                self.node = item;

                const left = try self.allocator.create(Self);
                left.* = Self.init(self.allocator);
                self.left_subtree = left;

                const right = try self.allocator.create(Self);
                right.* = Self.init(self.allocator);
                self.right_subtree = right;
            } else if (item < self.node.?) {
                try self.left_subtree.?.insert(item);
            } else {
                try self.right_subtree.?.insert(item);
            }
        }

        fn inOrder(self: *const Self, result: *std.ArrayList(T)) !void {
            if (self.node == null) {
                return;
            }
            try self.left_subtree.?.inOrder(result);
            try result.append(self.node.?);
            try self.right_subtree.?.inOrder(result);
        }
    };
}

fn treeSort(comptime T: type, allocator: Allocator, data: []const T) !std.ArrayList(T) {
    var searchTree = BinaryTree(T).init(allocator);
    defer searchTree.deinit();

    for (data) |item| {
        try searchTree.insert(item);
    }

    var sortedList = std.ArrayList(T).init(allocator);
    try searchTree.inOrder(&sortedList);

    return sortedList;
}

fn printList(comptime T: type, data: []const T, sortedFlag: bool) !void {
    const stdout = std.io.getStdOut().writer();

    for (data) |item| {
        try stdout.print("{} ", .{item});
    }

    if (!sortedFlag) {
        try stdout.print("-> ", .{});
    } else {
        try stdout.print("\n", .{});
    }
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const sl = [_]i32{ 5, 3, 7, 9, 1 };
    try printList(i32, &sl, false);
    var lls = try treeSort(i32, allocator, &sl);
    defer lls.deinit();
    try printList(i32, lls.items, true);

    const sl2 = [_]u8{ 'd', 'c', 'e', 'b', 'a' };
    try printList(u8, &sl2, false);
    var lls2 = try treeSort(u8, allocator, &sl2);
    defer lls2.deinit();
    try printList(u8, lls2.items, true);
}
