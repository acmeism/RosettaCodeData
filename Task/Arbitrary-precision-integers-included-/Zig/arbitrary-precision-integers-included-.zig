const std = @import("std");
const bigint = std.math.big.int.Managed;

pub fn main() !void {
    var a = try bigint.initSet(std.heap.c_allocator, 5);
    try a.pow(&a, try std.math.powi(u32, 4, try std.math.powi(u32, 3, 2)));
    defer a.deinit();

    var as = try a.toString(std.heap.c_allocator, 10, .lower);
    defer std.heap.c_allocator.free(as);

    std.debug.print("{s}...{s}\n", .{ as[0..20], as[as.len - 20 ..] });
    std.debug.print("{} digits\n", .{as.len});
}
