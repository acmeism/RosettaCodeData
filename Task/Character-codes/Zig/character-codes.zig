const std = @import("std");
const unicode = std.unicode;

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    try characterAsciiCodes(stdout);
    try characterUnicodeCodes(stdout);
}

fn characterAsciiCodes(writer: anytype) !void {
    try writer.writeAll("Sample ASCII characters and codes:\n");

    // Zig's string is just an array of bytes (u8).
    const message: []const u8 = "ABCabc";

    for (message) |val| {
        try writer.print("  '{c}' code: {d} [hexa: 0x{x}]\n", .{ val, val, val });
    }
    try writer.writeByte('\n');
}

fn characterUnicodeCodes(writer: anytype) !void {
    try writer.writeAll("Sample Unicode characters and codes:\n");

    const message: []const u8 = "あいうえお";

    const utf8_view = unicode.Utf8View.initUnchecked(message);
    var iter = utf8_view.iterator();

    while (iter.nextCodepoint()) |val| {
        var array: [4]u8 = undefined;
        const slice = array[0..try unicode.utf8Encode(val, &array)];

        try writer.print("  '{s}' code: {d} [hexa: U+{x}]\n", .{ slice, val, val });
    }
    try writer.writeByte('\n');
}
