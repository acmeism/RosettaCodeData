const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var hash_map = std.StringArrayHashMap(f32).init(allocator);
    defer hash_map.deinit();

    try hash_map.put("B3",  246.94);
    try hash_map.put("C4",  261.63);
    try hash_map.put("C#4", 277.18);

    for (hash_map.keys()) |key| {
        try stdout.print("{s}\n", .{key});
    }

    for (hash_map.values()) |value| {
        try stdout.print("{d}\n", .{value});
    }

    var iter = hash_map.iterator();
    while (iter.next()) |entry| {
        const key = entry.key_ptr.*;
        const value = entry.value_ptr.*;

        try stdout.print("{s}, {d}\n", .{key, value});
    }
}
