const std = @import("std");
const print = std.debug.print;
const Allocator = std.mem.Allocator;

const Color = enum(u8) {
    black = 0,
    red = 1,
};

const Node = struct {
    val: i32,
    parent: ?*Node,
    left: ?*Node,
    right: ?*Node,
    color: Color,

    fn init(allocator: Allocator, val: i32) !*Node {
        const node = try allocator.create(Node);
        node.* = Node{
            .val = val,
            .parent = null,
            .left = null,
            .right = null,
            .color = .red, // Red by default
        };
        return node;
    }

    fn deinit(self: *Node, allocator: Allocator) void {
        allocator.destroy(self);
    }
};

const RBTree = struct {
    allocator: Allocator,
    null_node: *Node,
    root: ?*Node,

    fn init(allocator: Allocator) !RBTree {
        const null_node = try Node.init(allocator, 0);
        null_node.color = .black;

        return RBTree{
            .allocator = allocator,
            .null_node = null_node,
            .root = null,
        };
    }

    fn deinit(self: *RBTree) void {
        if (self.root) |root| {
            self.deinitHelper(root);
        }
        self.null_node.deinit(self.allocator);
    }

    fn deinitHelper(self: *RBTree, node: *Node) void {
        if (node == self.null_node) return;

        if (node.left) |left| {
            self.deinitHelper(left);
        }
        if (node.right) |right| {
            self.deinitHelper(right);
        }
        node.deinit(self.allocator);
    }

    fn insertNode(self: *RBTree, key: i32) !void {
        const node = try Node.init(self.allocator, key);
        node.left = self.null_node;
        node.right = self.null_node;

        var y: ?*Node = null;
        var x = self.root;

        while (x) |current| {
            if (current == self.null_node) break;

            y = current;

            if (node.val < current.val) {
                const left = current.left;
                x = if (left != null and left != self.null_node) left else null;
            } else {
                const right = current.right;
                x = if (right != null and right != self.null_node) right else null;
            }
        }

        node.parent = y;

        if (y == null) {
            self.root = node;
        } else if (node.val < y.?.val) {
            y.?.left = node;
        } else {
            y.?.right = node;
        }

        if (y == null) {
            node.color = .black;
            return;
        }

        const parent = y.?;
        if (parent.parent == null) {
            return;
        }

        try self.fixInsert(node);
    }

    fn minimum(self: *RBTree, node: *Node) *Node {
        var current = node;
        while (current.left) |left| {
            if (left == self.null_node) break;
            current = left;
        }
        return current;
    }

    fn leftRotate(self: *RBTree, x: *Node) void {
        const y = x.right.?;
        x.right = y.left;

        if (y.left) |left| {
            if (left != self.null_node) {
                left.parent = x;
            }
        }

        y.parent = x.parent;

        if (x.parent == null) {
            self.root = y;
        } else if (x == x.parent.?.left) {
            x.parent.?.left = y;
        } else {
            x.parent.?.right = y;
        }

        y.left = x;
        x.parent = y;
    }

    fn rightRotate(self: *RBTree, x: *Node) void {
        const y = x.left.?;
        x.left = y.right;

        if (y.right) |right| {
            if (right != self.null_node) {
                right.parent = x;
            }
        }

        y.parent = x.parent;

        if (x.parent == null) {
            self.root = y;
        } else if (x == x.parent.?.right) {
            x.parent.?.right = y;
        } else {
            x.parent.?.left = y;
        }

        y.right = x;
        x.parent = y;
    }

    fn fixInsert(self: *RBTree, k_node: *Node) !void {
        var k = k_node;

        while (true) {
            const k_parent = k.parent orelse break;
            const k_grandparent = k_parent.parent orelse break;

            if (k_parent.color != .red) break;

            if (k_parent == k_grandparent.right) {
                const u = k_grandparent.left.?;

                if (u.color == .red) {
                    u.color = .black;
                    k_parent.color = .black;
                    k_grandparent.color = .red;
                    k = k_grandparent;
                } else {
                    if (k == k_parent.left) {
                        k = k_parent;
                        self.rightRotate(k);
                    }
                    const new_k_parent = k.parent.?;
                    const new_k_grandparent = new_k_parent.parent.?;
                    new_k_parent.color = .black;
                    new_k_grandparent.color = .red;
                    self.leftRotate(new_k_grandparent);
                }
            } else {
                const u = k_grandparent.right.?;

                if (u.color == .red) {
                    u.color = .black;
                    k_parent.color = .black;
                    k_grandparent.color = .red;
                    k = k_grandparent;
                } else {
                    if (k == k_parent.right) {
                        k = k_parent;
                        self.leftRotate(k);
                    }
                    const new_k_parent = k.parent.?;
                    const new_k_grandparent = new_k_parent.parent.?;
                    new_k_parent.color = .black;
                    new_k_grandparent.color = .red;
                    self.rightRotate(new_k_grandparent);
                }
            }

            if (k == self.root) break;
        }

        self.root.?.color = .black;
    }

    fn fixDelete(self: *RBTree, x_node: *Node) void {
        var x = x_node;

        while (x != self.root and x.color == .black) {
            const x_parent = x.parent.?;

            if (x == x_parent.left) {
                var s = x_parent.right.?;

                if (s.color == .red) {
                    s.color = .black;
                    x_parent.color = .red;
                    self.leftRotate(x_parent);
                    s = x.parent.?.right.?;
                }

                const s_left = s.left.?;
                const s_right = s.right.?;

                if (s_left.color == .black and s_right.color == .black) {
                    s.color = .red;
                    x = x_parent;
                } else {
                    if (s_right.color == .black) {
                        s_left.color = .black;
                        s.color = .red;
                        self.rightRotate(s);
                        s = x.parent.?.right.?;
                    }

                    s.color = x_parent.color;
                    x_parent.color = .black;
                    s.right.?.color = .black;
                    self.leftRotate(x_parent);
                    x = self.root.?;
                }
            } else {
                var s = x_parent.left.?;

                if (s.color == .red) {
                    s.color = .black;
                    x_parent.color = .red;
                    self.rightRotate(x_parent);
                    s = x.parent.?.left.?;
                }

                const s_left = s.left.?;
                const s_right = s.right.?;

                if (s_right.color == .black and s_left.color == .black) {
                    s.color = .red;
                    x = x_parent;
                } else {
                    if (s_left.color == .black) {
                        s_right.color = .black;
                        s.color = .red;
                        self.leftRotate(s);
                        s = x.parent.?.left.?;
                    }

                    s.color = x_parent.color;
                    x_parent.color = .black;
                    s.left.?.color = .black;
                    self.rightRotate(x_parent);
                    x = self.root.?;
                }
            }
        }
        x.color = .black;
    }

    fn rbTransplant(self: *RBTree, u: *Node, v: *Node) void {
        if (u.parent == null) {
            self.root = v;
        } else if (u == u.parent.?.left) {
            u.parent.?.left = v;
        } else {
            u.parent.?.right = v;
        }
        v.parent = u.parent;
    }

    fn deleteNodeHelper(self: *RBTree, node: ?*Node, key: i32) void {
        var z: ?*Node = self.null_node;
        var temp = node;

        while (temp) |current| {
            if (current.val == key) {
                z = current;
            }

            temp = if (current.val <= key) blk: {
                const right = current.right;
                break :blk if (right != null and right != self.null_node) right else null;
            } else blk: {
                const left = current.left;
                break :blk if (left != null and left != self.null_node) left else null;
            };
        }

        const z_node = z.?;
        if (z_node == self.null_node) {
            print("Value not present in Tree !!\n", .{});
            return;
        }

        const y = z_node;
        const y_original_color = y.color;
        var x: *Node = undefined;

        const z_left = z_node.left.?;
        const z_right = z_node.right.?;

        if (z_left == self.null_node) {
            x = z_right;
            self.rbTransplant(z_node, z_right);
        } else if (z_right == self.null_node) {
            x = z_left;
            self.rbTransplant(z_node, z_left);
        } else {
            const y_min = self.minimum(z_right);
            const y_min_original_color = y_min.color;
            const x_temp = y_min.right.?;
            x = x_temp;

            if (y_min.parent == z_node) {
                x.parent = y_min;
            } else {
                self.rbTransplant(y_min, x_temp);
                y_min.right = z_node.right;
                z_node.right.?.parent = y_min;
            }

            self.rbTransplant(z_node, y_min);
            y_min.left = z_node.left;
            z_node.left.?.parent = y_min;
            y_min.color = z_node.color;

            if (y_min_original_color == .black) {
                self.fixDelete(x);
                return;
            }
        }

        if (y_original_color == .black) {
            self.fixDelete(x);
        }
    }

    fn deleteNode(self: *RBTree, val: i32) void {
        if (self.root) |root_node| {
            self.deleteNodeHelper(root_node, val);
        }
    }

    fn printCall(self: *RBTree, node: ?*Node, indent: []const u8, last: bool, allocator: Allocator) void {
        if (node) |current| {
            if (current == self.null_node) return;

            print("{s}", .{indent});
            if (last) {
                print("R----" , .{});
            } else {
                print("L----" , .{});
            }

            const color = if (current.color == .red) "RED" else "BLACK";
            print("{d}({s})\n", .{ current.val, color });

            const new_indent = if (last)
                std.fmt.allocPrint(allocator, "{s}     ", .{indent}) catch return
            else
                std.fmt.allocPrint(allocator, "{s}|    ", .{indent}) catch return;
            defer allocator.free(new_indent);

            const left_child = if (current.left != null and current.left != self.null_node) current.left else null;
            const right_child = if (current.right != null and current.right != self.null_node) current.right else null;

            self.printCall(left_child, new_indent, false, allocator);
            self.printCall(right_child, new_indent, true, allocator);
        }
    }

    fn printTree(self: *RBTree, allocator: Allocator) void {
        if (self.root) |root| {
            self.printCall(root, "", true, allocator);
        }
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var bst = try RBTree.init(allocator);
    defer bst.deinit();

    print("State of the tree after inserting the 30 keys:\n", .{});
    var x: i32 = 1;
    while (x < 30) : (x += 1) {
        try bst.insertNode(x);
    }
    bst.printTree(allocator);

    print("\nState of the tree after deleting the 15 keys:\n", .{});
    x = 1;
    while (x < 15) : (x += 1) {
        bst.deleteNode(x);
    }
    bst.printTree(allocator);
}
