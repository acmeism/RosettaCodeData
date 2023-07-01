const std = @import("std");

pub fn main() !void {
    var in = try std.fs.cwd().openFile("input.txt", .{});
    defer in.close();
    var out = try std.fs.cwd().openFile("output.txt", .{ .mode = .write_only });
    defer out.close();
    var file_reader = in.reader();
    var file_writer = out.writer();
    var buf: [100]u8 = undefined;
    var read: usize = 1;
    while (read > 0) {
        read = try file_reader.readAll(&buf);
        try file_writer.writeAll(buf[0..read]);
    }
}
