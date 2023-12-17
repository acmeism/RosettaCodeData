const std = @import("std");

fn recurse(i: c_uint) void {
    std.debug.print("{d}\n", .{i});
    // We use wrapping addition operator here to mirror C behaviour.
    @call(.always_tail, recurse, .{i +% 1});
}

pub fn main() void {
    recurse(0);
    return;
}
