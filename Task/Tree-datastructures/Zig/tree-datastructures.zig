const std = @import("std");
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;
const print = std.debug.print;

pub const NestTree = struct {
    name: []const u8,
    children: ArrayList(NestTree),
    allocator: Allocator,

    pub fn init(allocator: Allocator, name: []const u8) !NestTree {
        const owned_name = try allocator.dupe(u8, name);
        return NestTree{
            .name = owned_name,
            .children = ArrayList(NestTree).init(allocator),
            .allocator = allocator,
        };
    }

    pub fn deinit(self: *NestTree) void {
        for (self.children.items) |*child| {
            child.deinit();
        }
        self.children.deinit();
        self.allocator.free(self.name);
    }

    pub fn addChild(self: *NestTree, name: []const u8) !void {
        const child = try NestTree.init(self.allocator, name);
        try self.children.append(child);
    }

    pub fn getChildMut(self: *NestTree, index: usize) ?*NestTree {
        if (index >= self.children.items.len) return null;
        return &self.children.items[index];
    }

    pub fn printTree(self: *const NestTree) void {
        self.printWithLevel(0);
    }

    fn printWithLevel(self: *const NestTree, level: usize) void {
        var i: usize = 0;
        while (i < level * 4) : (i += 1) {
            print(" " , .{});
        }
        print("{s}\n", .{self.name});

        for (self.children.items) |*child| {
            child.printWithLevel(level + 1);
        }
    }

    pub fn getName(self: *const NestTree) []const u8 {
        return self.name;
    }

    pub fn getChildren(self: *const NestTree) []const NestTree {
        return self.children.items;
    }

    pub fn equals(self: *const NestTree, other: *const NestTree) bool {
        if (!std.mem.eql(u8, self.name, other.name)) return false;
        if (self.children.items.len != other.children.items.len) return false;

        for (self.children.items, other.children.items) |*child1, *child2| {
            if (!child1.equals(child2)) return false;
        }

        return true;
    }
};

pub const IndentTree = struct {
    items: ArrayList(IndentItem),
    allocator: Allocator,

    const IndentItem = struct {
        level: i32,
        name: []const u8,
    };

    pub fn init(allocator: Allocator, nest: *const NestTree) !IndentTree {
        var items = ArrayList(IndentItem).init(allocator);
        const root_name = try allocator.dupe(u8, nest.getName());
        try items.append(IndentItem{ .level = 0, .name = root_name });

        var indent_tree = IndentTree{
            .items = items,
            .allocator = allocator,
        };

        try indent_tree.fromNest(nest, 0);
        return indent_tree;
    }

    pub fn deinit(self: *IndentTree) void {
        for (self.items.items) |item| {
            self.allocator.free(item.name);
        }
        self.items.deinit();
    }

    fn fromNest(self: *IndentTree, nest: *const NestTree, level: i32) !void {
        for (nest.getChildren()) |*child| {
            const child_name = try self.allocator.dupe(u8, child.getName());
            try self.items.append(IndentItem{ .level = level + 1, .name = child_name });
            try self.fromNest(child, level + 1);
        }
    }

    pub fn printTree(self: *const IndentTree) void {
        for (self.items.items) |item| {
            print("{} {s}\n", .{ item.level, item.name });
        }
    }

    pub fn toNest(self: *const IndentTree) !NestTree {
        if (self.items.items.len == 0) return error.EmptyIndentTree;

        var nest = try NestTree.init(self.allocator, self.items.items[0].name);
        _ = try self.toNestRecursive(&nest, 1, 0);
        return nest;
    }

    fn toNestRecursive(self: *const IndentTree, nest: *NestTree, pos: usize, level: i32) !usize {
        var current_pos = pos;

        while (current_pos < self.items.items.len and self.items.items[current_pos].level == level + 1) {
            try nest.addChild(self.items.items[current_pos].name);
            const child_index = nest.children.items.len - 1;
            if (nest.getChildMut(child_index)) |child| {
                current_pos = try self.toNestRecursive(child, current_pos + 1, level + 1);
            } else {
                current_pos += 1;
            }
        }

        return current_pos;
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var n = try NestTree.init(allocator, "RosettaCode");
    defer n.deinit();

    // Add children
    try n.addChild("rocks");
    try n.addChild("mocks");

    // Access children by index to avoid borrowing issues
    if (n.getChildMut(0)) |child1| {
        try child1.addChild("code");
        try child1.addChild("comparison");
        try child1.addChild("wiki");
    }

    if (n.getChildMut(1)) |child2| {
        try child2.addChild("trolling");
    }

    print("Initial nest format:\n" , .{});
    n.printTree();

    var i = try IndentTree.init(allocator, &n);
    defer i.deinit();

    print("\nIndent format:\n" , .{});
    i.printTree();

    var n2 = try i.toNest();
    defer n2.deinit();

    print("\nFinal nest format:\n" , .{} );
    n2.printTree();

    print("\nAre initial and final nest formats equal? {}\n", .{n.equals(&n2)});
}
