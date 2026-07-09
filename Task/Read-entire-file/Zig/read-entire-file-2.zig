const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    const file = try std.Io.Dir.cwd().openFile(io, "input_file.txt", .{});
    defer file.close(io);

    var mmap = try file.createMemoryMap(io, .{ .len = (try file.stat(io)).size, .protection = .{
        .read = true,
        .write = false,
    } });

    defer mmap.destroy(io);

    std.debug.print("Read {d} bytes. File content:\n", .{mmap.memory.len});
    std.debug.print("{s}", .{mmap.memory});
}
