const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    var stdout_wr = std.Io.File.stdout().writer(io, &.{});

    const is_terminal = try stdout_wr.file.isTty(io);

    try stdout_wr.interface.writeAll(if (is_terminal) "stdout is a terminal" else "stdout is not a terminal");
}
