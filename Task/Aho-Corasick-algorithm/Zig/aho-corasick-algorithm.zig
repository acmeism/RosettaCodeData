const std = @import("std");

const Node = struct {
    son: [26]usize = [_]usize{0} ** 26,
    ans: usize = 0,
    fail: usize = 0,
    du: usize = 0,
    idx: usize = 0,
};

const ACAutomaton = struct {
    tr: []Node,
    tot: usize,
    final_ans: std.ArrayList(usize),
    pidx: usize,
    allocator: std.mem.Allocator,

    fn init(allocator: std.mem.Allocator, max_nodes: usize) !ACAutomaton {
        const nodes = try allocator.alloc(Node, max_nodes);
        @memset(nodes, .{});

        return ACAutomaton{
            .tr = nodes,
            .tot = 0,
            .final_ans = std.ArrayList(usize).init(allocator),
            .pidx = 0,
            .allocator = allocator,
        };
    }

    fn deinit(self: *ACAutomaton) void {
        self.allocator.free(self.tr);
        self.final_ans.deinit();
    }

    fn reset(self: *ACAutomaton) void {
        @memset(self.tr, .{});
        self.tot = 0;
        self.pidx = 0;
        self.final_ans.clearRetainingCapacity();
    }

    fn insert(self: *ACAutomaton, pattern: []const u8) !usize {
        var u: usize = 0;
        for (pattern) |c| {
            if (c < 'a' or c > 'z') {
                return error.InvalidCharacter;
            }
            const char_code = c - 'a';

            if (self.tr[u].son[char_code] == 0) {
                self.tot += 1;
                if (self.tot >= self.tr.len) {
                    return error.ExceededMaximumNodes;
                }
                self.tr[u].son[char_code] = self.tot;
            }

            u = self.tr[u].son[char_code];
        }

        if (self.tr[u].idx == 0) {
            self.pidx += 1;
            self.tr[u].idx = self.pidx;
        }

        return self.tr[u].idx;
    }

    fn build(self: *ACAutomaton) !void {
        var q = std.fifo.LinearFifo(usize, .Dynamic).init(self.allocator);
        defer q.deinit();

        for (0..26) |i| {
            if (self.tr[0].son[i] != 0) {
                try q.writeItem(self.tr[0].son[i]);
            }
        }

        while (q.readItem()) |u| {
            for (0..26) |i| {
                const son_node_idx = self.tr[u].son[i];
                const fail_node_idx_for_u = self.tr[u].fail;

                if (son_node_idx != 0) {
                    self.tr[son_node_idx].fail = self.tr[fail_node_idx_for_u].son[i];
                    const target_fail_node_idx = self.tr[son_node_idx].fail;
                    self.tr[target_fail_node_idx].du += 1;

                    try q.writeItem(son_node_idx);
                } else {
                    self.tr[u].son[i] = self.tr[fail_node_idx_for_u].son[i];
                }
            }
        }
    }

    fn query(self: *ACAutomaton, text: []const u8) void {
        var u: usize = 0;
        for (text) |c| {
            if (c < 'a' or c > 'z') {
                continue;
            }
            const char_code = c - 'a';
            u = self.tr[u].son[char_code];
            self.tr[u].ans += 1;
        }
    }

    fn calculateFinalAnswers(self: *ACAutomaton) !void {
        try self.final_ans.resize(self.pidx + 1);
        @memset(self.final_ans.items, 0);

        var q = std.fifo.LinearFifo(usize, .Dynamic).init(self.allocator);
        defer q.deinit();

        for (0..self.tot + 1) |i| {
            if (self.tr[i].du == 0) {
                try q.writeItem(i);
            }
        }

        while (q.readItem()) |u| {
            const node_idx = self.tr[u].idx;
            const current_ans = self.tr[u].ans;

            if (node_idx != 0) {
                if (node_idx > self.pidx) {
                    return error.InvalidNodeIndex;
                }
                self.final_ans.items[node_idx] = current_ans;
            }

            const v = self.tr[u].fail;
            self.tr[v].ans += current_ans;

            // Fix: Check if du is greater than 0 before decrementing
            if (self.tr[v].du > 0) {
                self.tr[v].du -= 1;
                if (self.tr[v].du == 0) {
                    try q.writeItem(v);
                }
            }
        }
    }

    fn getAns(self: *const ACAutomaton, pattern_id: usize) usize {
        if (pattern_id > 0 and pattern_id < self.final_ans.items.len) {
            return self.final_ans.items[pattern_id];
        } else {
            return 0;
        }
    }
};

pub fn main() !void {
    const MAX_NODES: usize = 200000 + 6;
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var ac = try ACAutomaton.init(allocator, MAX_NODES);
    defer ac.deinit();

    const n = 5;
    var pattern_end_node_ids = try allocator.alloc(usize, n + 1);
    defer allocator.free(pattern_end_node_ids);
    @memset(pattern_end_node_ids, 0);

    const my_input = [_][]const u8{ "a", "bb", "aa", "abaa", "abaaa" };
    const text = "abaaabaa";

    const stdout = std.io.getStdOut().writer();

    try stdout.print("Inserting patterns:\n", .{});
    for (0..n) |i| {
        const pattern = my_input[i];
        try stdout.print("  - \"{s}\"\n", .{pattern});
        pattern_end_node_ids[i + 1] = try ac.insert(pattern);
    }
    try stdout.print("Total nodes after insert: {}\n", .{ac.tot});
    try stdout.print("Pattern IDs assigned:", .{});
    for (1..n + 1) |i| {
        try stdout.print(" {}", .{pattern_end_node_ids[i]});
    }
    try stdout.print("\n\n", .{});

    try stdout.print("Building failure links...\n", .{});
    try ac.build();
    try stdout.print("Build complete.\n\n", .{});

    try stdout.print("Querying text: \"{s}\"\n", .{text});
    ac.query(text);
    try stdout.print("Query complete.\n\n", .{});

    try stdout.print("Calculating final answers...\n", .{});
    try ac.calculateFinalAnswers();
    try stdout.print("Calculation complete.\n\n", .{});

    try stdout.print("Results:\n", .{});
    for (1..n + 1) |i| {
        const unique_id = pattern_end_node_ids[i];
        const count = ac.getAns(unique_id);
        try stdout.print("Pattern \"{s}\" (ID {}): {}\n", .{ my_input[i - 1], unique_id, count });
    }
    try stdout.print("\n", .{});
}
