const std = @import("std");

pub fn main() void {
    const vec: @Vector(5, i32) = .{ 1, 2, 3, 4, 5 };
    std.debug.print("Vec: {any}\n", .{vec});
    std.debug.print(" * Reduce with add: {d}\n", .{@reduce(.Add, vec)});
    std.debug.print(" * Reduce with mul: {d}\n", .{@reduce(.Mul, vec)});
    std.debug.print(" * Reduce with min: {d}\n", .{@reduce(.Min, vec)});
    std.debug.print(" * Reduce with max: {d}\n", .{@reduce(.Max, vec)});
}
