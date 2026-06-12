const std = @import("std");
const print = std.debug.print;
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

const Node = struct {
    sub: []u8,           // substring of the input string
    ch: ArrayList(usize), // vector of child node indices
    allocator: Allocator,

    fn init(allocator: Allocator) Node {
        return Node{
            .sub = &[_]u8{},
            .ch = ArrayList(usize).init(allocator),
            .allocator = allocator,
        };
    }

    fn initWithData(allocator: Allocator, sub: []const u8, children: []const usize) !Node {
        var node = Node{
            .sub = try allocator.dupe(u8, sub),
            .ch = ArrayList(usize).init(allocator),
            .allocator = allocator,
        };

        for (children) |child| {
            try node.ch.append(child);
        }

        return node;
    }

    fn deinit(self: *Node) void {
        if (self.sub.len > 0) {
            self.allocator.free(self.sub);
        }
        self.ch.deinit();
    }
};

const SuffixTree = struct {
    nodes: ArrayList(Node),
    allocator: Allocator,

    fn init(allocator: Allocator, s: []const u8) !SuffixTree {
        var tree = SuffixTree{
            .nodes = ArrayList(Node).init(allocator),
            .allocator = allocator,
        };

        try tree.nodes.append(Node.init(allocator));

        for (0..s.len) |i| {
            try tree.addSuffix(s[i..]);
        }

        return tree;
    }

    fn deinit(self: *SuffixTree) void {
        for (self.nodes.items) |*node| {
            node.deinit();
        }
        self.nodes.deinit();
    }

    fn visualize(self: *const SuffixTree) void {
        if (self.nodes.items.len == 0) {
            print("<empty>\n" , .{});
            return;
        }

        self.visualizeNode(0, "");
    }

    fn visualizeNode(self: *const SuffixTree, n: usize, pre: []const u8) void {
        const children = &self.nodes.items[n].ch;

        if (children.items.len == 0) {
            print("- {s}\n", .{self.nodes.items[n].sub});
            return;
        }

        print("+ {s}\n", .{self.nodes.items[n].sub});

        for (children.items, 0..) |child, i| {
            if (i == children.items.len - 1) {
                // Last child
                print("{s}+-", .{pre});
                // Create new prefix for recursion
                var new_pre = std.ArrayList(u8).init(self.allocator);
                defer new_pre.deinit();
                new_pre.appendSlice(pre) catch return;
                new_pre.appendSlice("  ") catch return;
                self.visualizeNode(child, new_pre.items);
            } else {
                print("{s}+-", .{pre});
                // Create new prefix for recursion
                var new_pre = std.ArrayList(u8).init(self.allocator);
                defer new_pre.deinit();
                new_pre.appendSlice(pre) catch return;
                new_pre.appendSlice("| ") catch return;
                self.visualizeNode(child, new_pre.items);
            }
        }
    }

    fn addSuffix(self: *SuffixTree, suf: []const u8) !void {
        var n: usize = 0;
        var i: usize = 0;

        while (i < suf.len) {
            const b = suf[i];
            var x2: usize = 0;
            var n2: usize = undefined;

            while (true) {
                const children = &self.nodes.items[n].ch;
                if (x2 == children.items.len) {
                    // no matching child, remainder of suf becomes new node
                    n2 = self.nodes.items.len;
                    const new_node = try Node.initWithData(self.allocator, suf[i..], &[_]usize{});
                    try self.nodes.append(new_node);
                    try self.nodes.items[n].ch.append(n2);
                    return;
                }

                const child_idx = children.items[x2];
                if (self.nodes.items[child_idx].sub.len > 0 and self.nodes.items[child_idx].sub[0] == b) {
                    n2 = child_idx;
                    break;
                }
                x2 += 1;
            }

            // find prefix of remaining suffix in common with child
            const sub2 = self.nodes.items[n2].sub;
            var j: usize = 0;

            while (j < sub2.len and i + j < suf.len) {
                if (suf[i + j] != sub2[j]) {
                    // split n2
                    const n3 = n2;
                    // new node for the part in common
                    const new_n2 = self.nodes.items.len;
                    const common_part = sub2[0..j];
                    const new_node = try Node.initWithData(self.allocator, common_part, &[_]usize{n3});
                    try self.nodes.append(new_node);

                    // old node loses the part in common
                    const remaining_part = try self.allocator.dupe(u8, sub2[j..]);
                    self.allocator.free(self.nodes.items[n3].sub);
                    self.nodes.items[n3].sub = remaining_part;

                    self.nodes.items[n].ch.items[x2] = new_n2;
                    break; // continue down the tree
                }
                j += 1;
            }

            i += j; // advance past part in common
            n = if (j < sub2.len)
                // We split the node, use the new intermediate node
                self.nodes.items.len - 1
            else
                n2; // continue down the tree
        }
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var tree = try SuffixTree.init(allocator, "banana$");
    defer tree.deinit();

    tree.visualize();
}
