const std = @import("std");

pub fn main() (error{OutOfMemory} || std.fs.File.OpenError || std.fs.File.ReadError || std.fs.File.WriteError)!void {
    var gpa: std.heap.GeneralPurposeAllocator(.{}) = .{};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const cwd = std.fs.cwd();

    var input_file = try cwd.openFile("input.txt", .{ .mode = .read_only });
    defer input_file.close();

    var output_file = try cwd.createFile("output.txt", .{});
    defer output_file.close();

    // Restrict input_file's size to "up to 10 MiB".
    var input_file_content = try input_file.readToEndAlloc(allocator, 10 * 1024 * 1024);
    defer allocator.free(input_file_content);

    try output_file.writeAll(input_file_content);
    return;
}
