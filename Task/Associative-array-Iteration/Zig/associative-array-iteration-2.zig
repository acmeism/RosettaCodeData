const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var hash_map = std.AutoArrayHashMap(u8, []const u8).init(allocator);
    defer hash_map.deinit();

    try hash_map.put('A', "Alpha");
    try hash_map.put('B', "Bravo");
    try hash_map.put('C', "Charlie");

    for (hash_map.keys()) |key| {
        try stdout.print("{c}\n", .{key});
    }

    for (hash_map.values()) |value| {
        try stdout.print("{s}\n", .{value});
    }

    var iter = hash_map.iterator();
    while (iter.next()) |entry| {
        const key = entry.key_ptr.*;
        const value = entry.value_ptr.*;

        try stdout.print("{c}, {s}\n", .{key, value});
    }
}
