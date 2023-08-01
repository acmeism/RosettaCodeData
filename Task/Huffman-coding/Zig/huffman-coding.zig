const std = @import("std");

const Node = struct {
    frequency: usize,
    kind: union(enum) {
        internal: struct {
            left: *Node,
            right: *Node,
        },
        leaf: u8,
    },

    fn initLeaf(frequency: usize, ch: u8) Node {
        return .{
            .frequency = frequency,
            .kind = .{ .leaf = ch },
        };
    }

    fn initInternal(
        allocator: std.mem.Allocator,
        left_child: Node,
        right_child: Node,
    ) !Node {
        const left = try allocator.create(Node);
        const right = try allocator.create(Node);
        left.* = left_child;
        right.* = right_child;
        return .{
            .frequency = left_child.frequency + right_child.frequency,
            .kind = .{ .internal = .{ .left = left, .right = right } },
        };
    }

    fn deinit(self: Node, allocator: std.mem.Allocator) void {
        switch (self.kind) {
            .internal => |inner| {
                inner.left.deinit(allocator);
                inner.right.deinit(allocator);
                allocator.destroy(inner.left);
                allocator.destroy(inner.right);
            },
            .leaf => {},
        }
    }

    fn compare(context: void, a: Node, b: Node) std.math.Order {
        _ = context;
        return std.math.order(a.frequency, b.frequency);
    }
};

pub fn main() !void {
    const text = "this is an example for huffman encoding";

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.assert(gpa.deinit() == .ok);

    const allocator = gpa.allocator();
    var frequencies = std.AutoHashMap(u8, usize).init(allocator);
    defer frequencies.deinit();

    for (text) |ch| {
        const gop = try frequencies.getOrPut(ch);
        if (gop.found_existing) {
            gop.value_ptr.* += 1;
        } else {
            gop.value_ptr.* = 1;
        }
    }

    var prioritized_frequencies =
        std.PriorityQueue(Node, void, Node.compare).init(allocator, {});
    defer prioritized_frequencies.deinit();

    var freq_it = frequencies.iterator();
    while (freq_it.next()) |counted_char| {
        try prioritized_frequencies.add(Node.initLeaf(
            counted_char.value_ptr.*,
            counted_char.key_ptr.*,
        ));
    }

    while (prioritized_frequencies.len > 1) {
        try prioritized_frequencies.add(try Node.initInternal(
            allocator,
            prioritized_frequencies.remove(),
            prioritized_frequencies.remove(),
        ));
    }

    const root = prioritized_frequencies.items[0];
    defer root.deinit(allocator);

    var codes = std.AutoArrayHashMap(u8, []const u8).init(allocator);
    defer codes.deinit();

    var arena = std.heap.ArenaAllocator.init(allocator);
    defer arena.deinit();

    try generateCodes(arena.allocator(), &root, &.{}, &codes);

    const stdout = std.io.getStdOut().writer();
    var code_it = codes.iterator();
    while (code_it.next()) |item| {
        try stdout.print("{c}: {s}\n", .{
            item.key_ptr.*,
            item.value_ptr.*,
        });
    }
}

fn generateCodes(
    arena: std.mem.Allocator,
    node: *const Node,
    prefix: []const u8,
    out_codes: *std.AutoArrayHashMap(u8, []const u8),
) !void {
    switch (node.kind) {
        .internal => |inner| {
            const left_prefix = try arena.alloc(u8, prefix.len + 1);
            std.mem.copy(u8, left_prefix, prefix);
            left_prefix[prefix.len] = '0';
            try generateCodes(arena, inner.left, left_prefix, out_codes);

            const right_prefix = try arena.alloc(u8, prefix.len + 1);
            std.mem.copy(u8, right_prefix, prefix);
            right_prefix[prefix.len] = '1';
            try generateCodes(arena, inner.right, right_prefix, out_codes);
        },
        .leaf => |ch| {
            try out_codes.put(ch, prefix);
        },
    }
}
