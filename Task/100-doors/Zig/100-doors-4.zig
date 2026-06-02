const std = @import("std");

pub fn main(init: std.process.Init) !void {
    var stdout_writer = std.Io.File.stdout().writer(init.io, &.{});
    const stdout = &stdout_writer.interface;

    for (1..11) |door| {
        try stdout.print("Door {d} is open\n", .{door * door});
    }
}
