const std = @import("std");
const math = std.math;
const stdout = std.io.getStdOut().writer();
const Allocator = std.mem.Allocator;

// AVL node
fn AVLnode(comptime T: type) type {
    return struct {
        const Self = @This();

        key: T,
        balance: i32,
        left: ?*Self,
        right: ?*Self,
        parent: ?*Self,

        fn init(k: T, p: ?*Self) Self {
            return Self{
                .key = k,
                .balance = 0,
                .parent = p,
                .left = null,
                .right = null,
            };
        }

        fn deinit(self: *Self, allocator: Allocator) void {
            if (self.left) |left| {
                left.deinit(allocator);
                allocator.destroy(left);
            }
            if (self.right) |right| {
                right.deinit(allocator);
                allocator.destroy(right);
            }
        }
    };
}

// AVL tree
fn AVLtree(comptime T: type) type {
    return struct {
        const Self = @This();
        const Node = AVLnode(T);

        root: ?*Node,
        allocator: Allocator,

        fn init(allocator: Allocator) Self {
            return Self{
                .root = null,
                .allocator = allocator,
            };
        }

        fn deinit(self: *Self) void {
            if (self.root) |root| {
                root.deinit(self.allocator);
                self.allocator.destroy(root);
            }
        }

        fn rotateLeft(self: *Self, a: *Node) *Node {
            var b = a.right.?;
            b.parent = a.parent;
            a.right = b.left;

            if (a.right != null) {
                a.right.?.parent = a;
            }

            b.left = a;
            a.parent = b;

            if (b.parent) |parent| {
                if (parent.right == a) {
                    parent.right = b;
                } else {
                    parent.left = b;
                }
            }

            self.setBalance(a);
            self.setBalance(b);
            return b;
        }

        fn rotateRight(self: *Self, a: *Node) *Node {
            var b = a.left.?;
            b.parent = a.parent;
            a.left = b.right;

            if (a.left != null) {
                a.left.?.parent = a;
            }

            b.right = a;
            a.parent = b;

            if (b.parent) |parent| {
                if (parent.right == a) {
                    parent.right = b;
                } else {
                    parent.left = b;
                }
            }

            self.setBalance(a);
            self.setBalance(b);
            return b;
        }

        fn rotateLeftThenRight(self: *Self, n: *Node) *Node {
            n.left = self.rotateLeft(n.left.?);
            return self.rotateRight(n);
        }

        fn rotateRightThenLeft(self: *Self, n: *Node) *Node {
            n.right = self.rotateRight(n.right.?);
            return self.rotateLeft(n);
        }

        fn height(self: *Self, n: ?*Node) i32 {
            if (n == null)
                return -1;
            return 1 + @max(self.height(n.?.left), self.height(n.?.right));
        }

        fn setBalance(self: *Self, n: *Node) void {
            n.balance = self.height(n.right) - self.height(n.left);
        }

        fn rebalance(self: *Self, _n: *Node) void {
            var n=_n;
            self.setBalance(n);

            if (n.balance == -2) {
                if (self.height(n.left.?.left) >= self.height(n.left.?.right)) {
                    n = self.rotateRight(n);
                } else {
                    n = self.rotateLeftThenRight(n);
                }
            } else if (n.balance == 2) {
                if (self.height(n.right.?.right) >= self.height(n.right.?.left)) {
                    n = self.rotateLeft(n);
                } else {
                    n = self.rotateRightThenLeft(n);
                }
            }

            if (n.parent != null) {
                self.rebalance(n.parent.?);
            } else {
                self.root = n;
            }
        }

        fn insert(self: *Self, key: T) !bool {
            if (self.root == null) {
                const node = try self.allocator.create(Node);
                node.* = Node.init(key, null);
                self.root = node;
            } else {
                var n = self.root.?;
                var parent: *Node = undefined;

                while (true) {
                    if (n.key == key)
                        return false;

                    parent = n;

                    const goLeft = n.key > key;
                    if (goLeft) {
                        if (n.left) |left| {
                            n = left;
                        } else {
                            const node = try self.allocator.create(Node);
                            node.* = Node.init(key, parent);
                            parent.left = node;
                            self.rebalance(parent);
                            break;
                        }
                    } else {
                        if (n.right) |right| {
                            n = right;
                        } else {
                            const node = try self.allocator.create(Node);
                            node.* = Node.init(key, parent);
                            parent.right = node;
                            self.rebalance(parent);
                            break;
                        }
                    }
                }
            }

            return true;
        }

        fn deleteKey(self: *Self, delKey: T) void {
            if (self.root == null)
                return;

            var n = self.root.?;
            var parent = self.root.?;
            var delNode: ?*Node = null;
            var child: ?*Node = self.root;

            while (child != null) {
                parent = n;
                n = child.?;
                child = if (delKey >= n.key) n.right else n.left;
                if (delKey == n.key)
                    delNode = n;
            }

            if (delNode) |node| {
                node.key = n.key;

                child = if (n.left != null) n.left else n.right;

                if (self.root.?.key == delKey) {
                    self.root = child;
                } else {
                    if (parent.left == n) {
                        parent.left = child;
                    } else {
                        parent.right = child;
                    }

                    self.rebalance(parent);
                }
            }
        }

        fn printBalance(self: *Self, n: ?*Node) !void {
            if (n != null) {
                try self.printBalance(n.?.left);
                try stdout.print("{} ", .{n.?.balance});
                try self.printBalance(n.?.right);
            }
        }

        fn printBalanceRoot(self: *Self) !void {
            try self.printBalance(self.root);
            try stdout.print("\n", .{});
        }
    };
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var t = AVLtree(i32).init(allocator);
    defer t.deinit();

    try stdout.print("Inserting integer values 1 to 10\n", .{});
    var i: i32 = 1;
    while (i <= 10) : (i += 1) {
        _ = try t.insert(i);
    }

    try stdout.print("Printing balance: ", .{});
    try t.printBalanceRoot();
}
