const std = @import("std");

const evenRoot = 0;
const oddRoot = 1;

const Node = struct {
    length: i32,
    edges: std.StringHashMap(usize),
    suffix: usize,

    fn init(l: i32) Node {
        return .{
            .length = l,
            .edges = std.StringHashMap(usize).init(std.heap.page_allocator),
            .suffix = 0,
        };
    }

    fn initWithValues(l: i32, s: usize) Node {
        return .{
            .length = l,
            .edges = std.StringHashMap(usize).init(std.heap.page_allocator),
            .suffix = s,
        };
    }

    fn deinit(self: *Node) void {
        self.edges.deinit();
    }
};

fn eertree(allocator: std.mem.Allocator, s: []const u8) !std.ArrayList(Node) {
    var tree = std.ArrayList(Node).init(allocator);

    // Initialize the two roots
    const node0 = Node.initWithValues(0, oddRoot);
    const node1 = Node.initWithValues(-1, oddRoot);

    try tree.append(node0);
    try tree.append(node1);

    var suffix: usize = oddRoot;
    var n: usize = 0;
    var k: i32 = 0;

    for (s, 0..) |c, i| {
        // Find the longest palindrome suffix
        n = suffix;
        while (true) {
            k = tree.items[n].length;
            const b: i64 = @as(i64, @intCast(i)) - k - 1;
            if (b >= 0 and s[@intCast(b)] == c) {
                break;
            }
            n = tree.items[n].suffix;
        }

        // Convert char to string key for the hashmap
        var c_buf: [1]u8 = undefined;
        c_buf[0] = c;
        const c_key = c_buf[0..];

        // Check if edge already exists
        if (tree.items[n].edges.get(c_key)) |found_suffix| {
            suffix = found_suffix;
            continue;
        }

        // Create new node
        suffix = tree.items.len;
        const new_node = Node.init(k + 2);
        try tree.append(new_node);

        try tree.items[n].edges.put(try allocator.dupe(u8, c_key), suffix);

        if (tree.items[suffix].length == 1) {
            tree.items[suffix].suffix = 0;
            continue;
        }

        // Find suffix link
        while (true) {
            n = tree.items[n].suffix;
            const b: i64 = @as(i64, @intCast(i)) - tree.items[n].length - 1;
            if (b >= 0 and s[@intCast(b)] == c) {
                break;
            }
        }

        const suffix_edge = tree.items[n].edges.get(c_key) orelse unreachable;
        tree.items[suffix].suffix = suffix_edge;
    }

    return tree;
}

fn subPalindromes(allocator: std.mem.Allocator, tree: std.ArrayList(Node)) !std.ArrayList([]const u8) {
    var results = std.ArrayList([]const u8).init(allocator);

    const collectChildren = struct {
        fn collect(
            alloc: std.mem.Allocator,
            results_list: *std.ArrayList([]const u8),
            tree_list: *const std.ArrayList(Node),
            node_idx: usize,
            palindrome: []const u8
        ) !void {
            var it = tree_list.items[node_idx].edges.iterator();
            while (it.next()) |entry| {
                const c = entry.key_ptr.*[0];
                const next_node = entry.value_ptr.*;

                // Create new palindrome by adding character to both sides
                var new_pal = try alloc.alloc(u8, palindrome.len + 2);
                new_pal[0] = c;
                @memcpy(new_pal[1 .. palindrome.len + 1], palindrome);
                new_pal[palindrome.len + 1] = c;

                try results_list.append(new_pal);
                try collect(alloc, results_list, tree_list, next_node, new_pal);
            }
        }
    }.collect;

    // Process even-length palindromes (from root 0)
    try collectChildren(allocator, &results, &tree, 0, "");

    // Process odd-length palindromes (from root 1)
    var it = tree.items[1].edges.iterator();
    while (it.next()) |entry| {
        const c = entry.key_ptr.*[0];
        const next_node = entry.value_ptr.*;

        // Single character palindrome
        var c_pal = try allocator.alloc(u8, 1);
        c_pal[0] = c;
        try results.append(c_pal);

        try collectChildren(allocator, &results, &tree, next_node, c_pal);
    }

    return results;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const input = "eertree";

    var tree = try eertree(allocator, input);
    defer {
        for (tree.items) |*node| {
            node.deinit();
        }
        tree.deinit();
    }

    var palindromes = try subPalindromes(allocator, tree);
    defer {
        for (palindromes.items) |pal| {
            allocator.free(pal);
        }
        palindromes.deinit();
    }

    // Print results
    const stdout = std.io.getStdOut().writer();
    try stdout.print("[", .{});

    if (palindromes.items.len > 0) {
        try stdout.print("{s}", .{palindromes.items[0]});

        for (palindromes.items[1..]) |pal| {
            try stdout.print(", {s}", .{pal});
        }
    }

    try stdout.print("]\n", .{});
}
