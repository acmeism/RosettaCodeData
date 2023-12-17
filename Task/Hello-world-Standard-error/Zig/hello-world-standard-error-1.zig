const std = @import("std");

pub fn main() std.fs.File.WriteError!void {
    const stderr = std.io.getStdErr();

    try stderr.writeAll("Goodbye, World!\n");
}
