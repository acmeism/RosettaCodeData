const std = @import("std");

const Link = struct {
    value: i32,
    next: ?*Link,

    fn new(allocator: std.mem.Allocator, value: i32, next: ?*Link) !*Link {
        const link = try allocator.create(Link);
        link.* = .{ .value = value, .next = next };
        return link;
    }

    pub fn format(
        self: *const Link,
        comptime fmt: []const u8,
        options: std.fmt.FormatOptions,
        writer: anytype,
    ) !void {
        _ = fmt;
        _ = options;

        try writer.print("[{}", .{self.value});

        var current = self.next;
        while (current) |link| {
            try writer.print(" {}", .{link.value});
            current = link.next;
        }

        try writer.print("]", .{});
    }
};

// Function to free all nodes in a linked list
fn freeList(allocator: std.mem.Allocator, list: ?*Link) void {
    var current = list;
    while (current) |node| {
        const next = node.next;
        allocator.destroy(node);
        current = next;
    }
}

fn linkInts(allocator: std.mem.Allocator, s: []const i32) !?*Link {
    if (s.len == 0) {
        return null;
    } else {
        return try Link.new(allocator, s[0], try linkInts(allocator, s[1..]));
    }
}

fn strandSort(allocator: std.mem.Allocator, a: ?*Link) !?*Link {
    var result: ?*Link = null;
    var current_a = a;

    while (current_a) |head| {
        // Take the first element for our sublist
        current_a = head.next;
        head.next = null;

        // Build sublist
        const sublist: ?*Link = head;
        var sublist_tail = sublist.?;

        // Process the remaining elements in the original list
        var current = current_a;
        current_a = null;

        // Start building a new 'a' list
        var new_a: ?*Link = null;
        var new_a_tail: ?*Link = null;

        while (current) |node| {
            current = node.next;
            node.next = null;

            if (node.value > sublist_tail.value) {
                // Append to sublist
                sublist_tail.next = node;
                sublist_tail = node;
            } else {
                // Add to the new 'a' list
                if (new_a == null) {
                    new_a = node;
                    new_a_tail = node;
                } else {
                    new_a_tail.?.next = node;
                    new_a_tail = node;
                }
            }
        }

        current_a = new_a;

        // If result is empty, set it to the sublist
        if (result == null) {
            result = sublist;
            continue;
        }

        // Merge sublist with result
        result = try merge(allocator, result, sublist);
    }

    return result;
}

fn merge(allocator: std.mem.Allocator, list1: ?*Link, list2: ?*Link) !?*Link {
    _ = allocator; // Allocator is not needed here, but keeping for consistency

    if (list1 == null) return list2;
    if (list2 == null) return list1;

    var head1 = list1.?;
    var head2 = list2.?;

    // Start with the smaller value
    var result: ?*Link = null;
    var current: *Link = undefined;

    if (head1.value <= head2.value) {
        result = head1;
        current = head1;
        head1 = head1.next orelse {
            current.next = head2;
            return result;
        };
    } else {
        result = head2;
        current = head2;
        head2 = head2.next orelse {
            current.next = head1;
            return result;
        };
    }

    // Merge the rest
    while (true) {
        if (head1.value <= head2.value) {
            current.next = head1;
            current = head1;
            head1 = head1.next orelse {
                current.next = head2;
                break;
            };
        } else {
            current.next = head2;
            current = head2;
            head2 = head2.next orelse {
                current.next = head1;
                break;
            };
        }
    }

    return result;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        const deinit_status = gpa.deinit();
        if (deinit_status == .leak) @panic("MEMORY LEAK");
    }

    const array = [_]i32{ 170, 45, 75, -90, -802, 24, 2, 66 };
    const a = try linkInts(allocator, &array);

    const stdout = std.io.getStdOut().writer();
    try stdout.print("before: ", .{});
    if (a) |link| {
        try stdout.print("{}", .{link});
    } else {
        try stdout.print("None", .{});
    }
    try stdout.print("\n", .{});

    const b = try strandSort(allocator, a);
    try stdout.print("after:  ", .{});
    if (b) |link| {
        try stdout.print("{}", .{link});
    } else {
        try stdout.print("None", .{});
    }
    try stdout.print("\n", .{});

    // Free memory
    freeList(allocator, b);
}
