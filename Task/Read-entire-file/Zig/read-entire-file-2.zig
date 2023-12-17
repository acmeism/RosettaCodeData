const std = @import("std");

const File = std.fs.File;

pub fn main() (File.OpenError || File.SeekError || std.os.MMapError)!void {
    const cwd = std.fs.cwd();

    var file = try cwd.openFile("input_file.txt", .{ .mode = .read_only });
    defer file.close();

    const file_size = (try file.stat()).size;

    const file_content = try std.os.mmap(null, file_size, std.os.PROT.READ, std.os.MAP.PRIVATE, file.handle, 0);
    defer std.os.munmap(file_content);

    std.debug.print("Read {d} octets. File content:\n", .{file_content.len});
    std.debug.print("{s}", .{file_content});
}
