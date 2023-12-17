const std = @import("std");

const File = std.fs.File;

pub fn main() (error{OutOfMemory} || File.OpenError || File.ReadError)!void {
    var gpa: std.heap.GeneralPurposeAllocator(.{}) = .{};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const cwd = std.fs.cwd();

    var file = try cwd.openFile("input_file.txt", .{ .mode = .read_only });
    defer file.close();

    const file_content = try file.readToEndAlloc(allocator, comptime std.math.maxInt(usize));
    defer allocator.free(file_content);

    std.debug.print("Read {d} octets. File content:\n", .{file_content.len});
    std.debug.print("{s}", .{file_content});
}
