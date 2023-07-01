const std = @import("std");
const Vector = std.meta.Vector;

pub fn main() !void {
    const a: Vector(3, i32) = [_]i32{1, 3, -5};
    const b: Vector(3, i32) = [_]i32{4, -2, -1};
    var dot: i32 = @reduce(.Add, a*b);

    try std.io.getStdOut().writer().print("{d}\n", .{dot});
}
