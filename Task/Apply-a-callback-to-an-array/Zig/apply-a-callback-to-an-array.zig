pub fn main() !void {
    var array = [_]i32{1, 2, 3};
    apply(@TypeOf(array[0]), array[0..], func);
}

fn apply(comptime T: type, a: []T, f: fn(T) void) void {
    for (a) |item| {
        f(item);
    }
}

fn func(a: i32) void {
    const std = @import("std");
    std.debug.print("{d}\n", .{a-1});
}
