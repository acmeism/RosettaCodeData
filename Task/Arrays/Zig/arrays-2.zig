const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    // ArrayLists are initialized in the heap
    var array = std.ArrayList(i32).init(allocator);
    defer array.deinit();

    // pushing elements to an ArrayList
    try array.append(-12);
    try array.append(345);
    try array.append(-7);

    // retrieving elements from an ArrayList
    try stdout.print("{d}, ", .{array.items[0]});
    try stdout.print("{d}, ", .{array.items[1]});
    try stdout.print("{d}\n", .{array.items[2]});
}
