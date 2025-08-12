const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var hash_map = std.StringHashMap(f64).init(allocator);
    defer hash_map.deinit();

    try hash_map.put("pi",  3.14159265);
    try hash_map.put("e",   2.71828183);
    try hash_map.put("phi", 1.61803399);

    try stdout.print("{d}\n", .{hash_map.get("pi").?});
    try stdout.print("{d}\n", .{hash_map.get("e").?});
    try stdout.print("{d}\n", .{hash_map.get("phi").?});
}
