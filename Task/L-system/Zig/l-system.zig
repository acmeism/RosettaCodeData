const std = @import("std");
const print = std.debug.print;
const ArrayList = std.ArrayList;
const HashMap = std.HashMap;

fn lindenmayer(allocator: std.mem.Allocator, s: []const u8, rules: *const HashMap(u8, []const u8, std.hash_map.AutoContext(u8), std.hash_map.default_max_load_percentage), count: usize) !void {
    var current = try allocator.dupe(u8, s);
    defer allocator.free(current);

    var i: usize = 0;
    while (i < count) : (i += 1) {
        print("{s}\n", .{current});

        var next = ArrayList(u8).init(allocator);
        defer next.deinit();

        for (current) |c| {
            if (rules.get(c)) |rule| {
                try next.appendSlice(rule);
            } else {
                try next.append(c);
            }
        }

        allocator.free(current);
        current = try next.toOwnedSlice();
    }
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var rules = HashMap(u8, []const u8, std.hash_map.AutoContext(u8), std.hash_map.default_max_load_percentage).init(allocator);
    defer rules.deinit();

    try rules.put('I', "M");
    try rules.put('M', "MI");

    try lindenmayer(allocator, "I", &rules, 5);
}
