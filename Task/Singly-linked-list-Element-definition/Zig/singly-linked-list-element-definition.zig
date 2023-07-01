const std = @import("std");

var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);

const allocator = arena.allocator();

pub fn LinkedList(comptime Value: type) type {
    return struct {
        const This = @This();

        const Node = struct {
            value: Value,
            next: ?*Node,
        };

        head: ?*Node,
        tail: ?*Node,

        pub fn init() This {
            return LinkedList(Value) {
                .head = null,
                .tail = null,
            };
        }

        pub fn add(this: *This, value: Value) !void {
            var newNode = try allocator.create(Node);

            newNode.* = .{ .value = value, .next = null };

            if (this.tail) |tail| {
                tail.next = newNode;
                this.tail = newNode;
            } else if (this.head) |head| {
                head.next = newNode;
                this.tail = newNode;
            } else {
                this.head = newNode;
            }
        }
    };
}
