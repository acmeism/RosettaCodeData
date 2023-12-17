const std = @import("std");

pub fn main() std.fs.File.WriteError!void {
    const stdout = std.io.getStdOut();

    try stdout.writeAll("Hello world!\n");
}
