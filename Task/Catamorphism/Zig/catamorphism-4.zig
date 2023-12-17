const std = @import("std");

pub fn main() void {
    const vec: @Vector(2, i32) = .{ std.math.minInt(i32), std.math.minInt(i32) + 1 };
    std.debug.print("Vec: {any}\n", .{vec});
    std.debug.print(" * Reduce with .Add: {d}\n", .{@reduce(.Add, vec)});
    std.debug.print(" * Reduce with .Mul: {d}\n", .{@reduce(.Mul, vec)});

    var zero: usize = 0; // Small trick to make compiler not emit compile error for overflow below:
    std.debug.print(" * Reduce with regular add operator: {d}\n", .{vec[zero] + vec[1]});
    std.debug.print(" * Reduce with regular mul operator: {d}\n", .{vec[zero] * vec[1]});
}
