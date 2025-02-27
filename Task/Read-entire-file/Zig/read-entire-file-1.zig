const std = @import("std");

pub fn main() !void {
    var gpa: std.heap.GeneralPurposeAllocator(.{}) = .{};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var file = try std.fs.cwd().openFile("input_file.txt", .{});
    defer file.close();

    const file_content = try file.readToEndAlloc(allocator, (try file.stat()).size);
    defer allocator.free(file_content);

    std.debug.print("Read {d} octets. File content:\n", .{file_content.len});
    std.debug.print("{s}", .{file_content});
}
