const std = @import("std");

pub fn main() !void {
    var gpa: std.heap.GeneralPurposeAllocator(.{}) = .{};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const cwd = std.fs.cwd();

    var input_file = try cwd.openFile("input.txt", .{});
    defer input_file.close();

    var output_file = try cwd.createFile("output.txt", .{});
    defer output_file.close();

    const input_file_content = try input_file.readToEndAlloc(allocator, (try input_file.stat()).size);
    defer allocator.free(input_file_content);

    try output_file.writeAll(input_file_content);
    return;
}
