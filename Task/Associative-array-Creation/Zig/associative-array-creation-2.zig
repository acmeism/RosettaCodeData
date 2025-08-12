const std = @import("std");

const Entity = struct {
    name: []const u8,
    hp: i32,
};

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var hash_map = std.AutoHashMap(u32, Entity).init(allocator);
    defer hash_map.deinit();

    try hash_map.put(123, .{ .name = "Zombie", .hp = 20 });
    try hash_map.put(456, .{ .name = "Bat",    .hp =  6 });
    try hash_map.put(789, .{ .name = "Pig",    .hp = 10 });

    try stdout.print("{s:6}:  HP = {d:3}\n", hash_map.get(123).?);
    try stdout.print("{s:6}:  HP = {d:3}\n", hash_map.get(456).?);
    try stdout.print("{s:6}:  HP = {d:3}\n", hash_map.get(789).?);
}
