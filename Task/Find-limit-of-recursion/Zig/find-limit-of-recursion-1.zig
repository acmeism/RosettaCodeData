const std = @import("std");

fn recurse(i: c_uint) void {
    std.debug.print("{d}\n", .{i});
    // We use wrapping addition operator here to mirror C behaviour.
    recurse(i +% 1);
    // Line above is equivalent to:
    // @call(.auto, recurse, .{i +% 1});
}

pub fn main() void {
    recurse(0);
    return;
}
