const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const allocator = init.gpa;

    const file = try std.Io.Dir.cwd().openFile(io, "input_file.txt", .{});
    defer file.close(io);

    var file_reader = file.reader(io, &.{});
    const file_content = try file_reader.interface.readAlloc(allocator, try file_reader.getSize());
    defer allocator.free(file_content);

    std.debug.print("Read {d} bytes. File content:\n", .{file_content.len});
    std.debug.print("{s}", .{file_content});
}
