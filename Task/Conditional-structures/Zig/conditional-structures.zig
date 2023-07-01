const std = @import("std");
const builtin = @import("builtin");

fn printOpenSource(comptime is_open_source: bool) !void {
    if (is_open_source) {
        try std.io.getStdOut().writer().writeAll("Open source.\n");
    } else {
        try std.io.getStdOut().writer().writeAll("No open source.\n");
    }
}
fn printYesOpenSource() !void {
    try std.io.getStdOut().writer().writeAll("Open source.\n");
}
fn printNoOpenSource() !void {
    try std.io.getStdOut().writer().writeAll("No open source.\n");
}
const fnProto = switch (builtin.zig_backend) {
    .stage1 => fn () anyerror!void,
    else => *const fn () anyerror!void,
};
const Vtable = struct {
    fnptrs: [2]fnProto,
};

// dynamic dispatch: logic(this function) + vtable + data
fn printBySelectedType(data: bool, vtable: Vtable) !void {
    if (data) {
        try @call(.{}, vtable.fnptrs[0], .{});
    } else {
        try @call(.{}, vtable.fnptrs[1], .{});
    }
}

pub fn main() !void {
    // if-else
    if (true) {
        std.debug.assert(true);
    } else {
        std.debug.assert(false);
    }
    // comptime switch
    const open_source = comptime switch (builtin.os.tag) {
        .freestanding => true,
        .linux => true,
        .macos => false,
        .windows => false,
        else => unreachable,
    };
    // conditional compilation
    std.debug.assert(builtin.zig_backend != .stage2_llvm);
    // static dispatch (more complex examples work typically via comptime enums)
    try printOpenSource(open_source);
    // dynamic dispatch (runtime attach function pointer)
    var vtable = Vtable{
        .fnptrs = undefined,
    };
    // runtime-attach function pointers (dynamic dispatch)
    vtable.fnptrs[0] = printYesOpenSource;
    vtable.fnptrs[1] = printNoOpenSource;
    try printBySelectedType(open_source, vtable);

    // TODO Arithmetic if once https://github.com/ziglang/zig/issues/8220 is finished
}
