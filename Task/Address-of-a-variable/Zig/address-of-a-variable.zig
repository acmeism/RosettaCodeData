const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    var stdout = std.Io.File.stdout().writer(io, &.{});
    var i: usize = 42;
    const mutable_ptr = &i;
    mutable_ptr.* = 67;
    const const_ptr: i32 = 76;
    try stdout.interface.print("mutable ptr: {d} {*}\n", .{
        mutable_ptr.*,
        mutable_ptr,
    });
    try stdout.interface.print("const ptr: {d} {*}\n", .{
        (&const_ptr).*,
        &const_ptr
    });
}
