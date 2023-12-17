const std = @import("std");
const builtin = @import("builtin");

pub const bloop: i32 = -1_000;

pub fn abs(a: i32) i32 {
    return if (a < 0) -a else a;
}

pub fn main() error{NotSupported}!void {
    if (builtin.zig_version.order(.{ .major = 0, .minor = 11, .patch = 0 }) == .lt) {
        std.debug.print("Version {any} is less than 0.11.0, not suitable, exiting!\n", .{builtin.zig_version});
        return error.NotSupported;
    } else {
        std.debug.print("Version {any} is more or equal than 0.11.0, suitable, continuing!\n", .{builtin.zig_version});
    }

    if (@hasDecl(@This(), "bloop") and @hasDecl(@This(), "abs")) {
        std.debug.print("abs(bloop) = {d}\n", .{abs(bloop)});
    } else {
        std.debug.print("abs and/or bloop are not defined!\n", .{});
    }
}
