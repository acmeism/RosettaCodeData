const std = @import("std");

fn add(a: i32, b: i32) i32 {
    return a + b;
}

fn mul(a: i32, b: i32) i32 {
    return a * b;
}

fn min(a: i32, b: i32) i32 {
    return @min(a, b);
}

fn max(a: i32, b: i32) i32 {
    return @max(a, b);
}

pub fn main() void {
    const arr: [5]i32 = .{ 1, 2, 3, 4, 5 };
    std.debug.print("Array: {any}\n", .{arr});
    std.debug.print(" * Reduce with add: {d}\n", .{reduce(i32, add, &arr)});
    std.debug.print(" * Reduce with mul: {d}\n", .{reduce(i32, mul, &arr)});
    std.debug.print(" * Reduce with min: {d}\n", .{reduce(i32, min, &arr)});
    std.debug.print(" * Reduce with max: {d}\n", .{reduce(i32, max, &arr)});
}
