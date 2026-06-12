const std = @import("std");
const ArrayList = std.ArrayList;
const StringHashMap = std.StringHashMap;
const AutoHashMap = std.AutoHashMap;

const Rule = struct {
    parts: []const []const u8,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Non-terminal symbols
    const non_terminals = [_][]const u8{ "NP", "Nom", "Det", "AP", "Adv", "A" };
    const terminals = [_][]const u8{ "book", "orange", "man", "tall", "heavy", "very", "muscular" };
    _ = non_terminals;
    _ = terminals;

    // Rules of the grammar
    var rules = StringHashMap(ArrayList(ArrayList([]const u8))).init(allocator);
    defer {
        var it = rules.iterator();
        while (it.next()) |entry| {
            for (entry.value_ptr.items) |*rule_list| {
                rule_list.deinit();
            }
            entry.value_ptr.deinit();
        }
        rules.deinit();
    }

    // Initialize rules
    try addRule(&rules, allocator, "NP", &[_][]const []const u8{
        &[_][]const u8{ "Det", "Nom" },
    });
    try addRule(&rules, allocator, "Nom", &[_][]const []const u8{
        &[_][]const u8{ "AP", "Nom" },
        &[_][]const u8{"book"},
        &[_][]const u8{"orange"},
        &[_][]const u8{"man"},
    });
    try addRule(&rules, allocator, "AP", &[_][]const []const u8{
        &[_][]const u8{ "Adv", "A" },
        &[_][]const u8{"heavy"},
        &[_][]const u8{"orange"},
        &[_][]const u8{"tall"},
    });
    try addRule(&rules, allocator, "Det", &[_][]const []const u8{
        &[_][]const u8{"a"},
    });
    try addRule(&rules, allocator, "Adv", &[_][]const []const u8{
        &[_][]const u8{"very"},
        &[_][]const u8{"extremely"},
    });
    try addRule(&rules, allocator, "A", &[_][]const []const u8{
        &[_][]const u8{"heavy"},
        &[_][]const u8{"orange"},
        &[_][]const u8{"tall"},
        &[_][]const u8{"muscular"},
    });

    // Given string
    const input = "a very heavy orange book";
    var word_list = ArrayList([]const u8).init(allocator);
    defer word_list.deinit();

    var it = std.mem.splitScalar(u8, input, ' ');
    while (it.next()) |word| {
        try word_list.append(word);
    }

    const w = try word_list.toOwnedSlice();
    defer allocator.free(w);

    // Function Call
    try cykParse(allocator, w, &rules);
}

fn addRule(
    rules: *StringHashMap(ArrayList(ArrayList([]const u8))),
    allocator: std.mem.Allocator,
    lhs: []const u8,
    rhs_list: []const []const []const u8,
) !void {
    var rule_array = ArrayList(ArrayList([]const u8)).init(allocator);

    for (rhs_list) |rhs| {
        var parts = ArrayList([]const u8).init(allocator);
        for (rhs) |part| {
            try parts.append(part);
        }
        try rule_array.append(parts);
    }

    try rules.put(lhs, rule_array);
}

fn cykParse(
    allocator: std.mem.Allocator,
    w: []const []const u8,
    rules: *StringHashMap(ArrayList(ArrayList([]const u8))),
) !void {
    const n = w.len;

    // Initialize the table with empty sets
    var table = try allocator.alloc([]StringHashMap(void), n);
    defer {
        for (table) |row| {
            for (row) |*cell| {
                cell.deinit();
            }
            allocator.free(row);
        }
        allocator.free(table);
    }

    for (table, 0..) |*row, i| {
        row.* = try allocator.alloc(StringHashMap(void), n);
        for (row.*, 0..) |*cell, j| {
            cell.* = StringHashMap(void).init(allocator);
            _ = i;
            _ = j;
        }
    }

    // Filling in the table
    var j: usize = 0;
    while (j < n) : (j += 1) {
        // Iterate over the rules
        var rule_it = rules.iterator();
        while (rule_it.next()) |entry| {
            const lhs = entry.key_ptr.*;
            const rule_list = entry.value_ptr;

            for (rule_list.items) |rhs| {
                // If a terminal is found
                if (rhs.items.len == 1 and std.mem.eql(u8, rhs.items[0], w[j])) {
                    try table[j][j].put(lhs, {});
                }
            }
        }

        if (j == 0) continue;

        var i: usize = j;
        while (true) : (i -= 1) {
            // Iterate over the range i to j
            var k = i;
            while (k < j) : (k += 1) {
                // Iterate over the rules
                var rule_it2 = rules.iterator();
                while (rule_it2.next()) |entry| {
                    const lhs = entry.key_ptr.*;
                    const rule_list = entry.value_ptr;

                    for (rule_list.items) |rhs| {
                        // If a non-terminal pair is found
                        if (rhs.items.len == 2 and
                            table[i][k].contains(rhs.items[0]) and
                            table[k + 1][j].contains(rhs.items[1]))
                        {
                            try table[i][j].put(lhs, {});
                        }
                    }
                }
            }

            if (i == 0) break;
        }
    }

    // If word can be formed by rules of given grammar
    if (table[0][n - 1].contains("NP")) {
        std.debug.print("True\n", .{});
    } else {
        std.debug.print("False\n", .{});
    }
}
