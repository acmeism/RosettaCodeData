const std = @import("std");

const debug = std.debug;
const unicode = std.unicode;

test "character codes" {
    debug.warn("\n", .{});

    // Zig's string is just an array of bytes (u8).
    const message = "ABCabc";

    for (message) |val| {
        debug.warn("  '{c}' code: {} [hexa: 0x{x}]\n", .{ val, val, val });
    }
}

test "character (uni)codes" {
    debug.warn("\n", .{});

    const message = "あいうえお";

    const utf8_view = unicode.Utf8View.initUnchecked(message);
    var iter = utf8_view.iterator();

    while (iter.nextCodepoint()) |val| {
        var array: [4]u8 = undefined;
        var slice = array[0..try unicode.utf8Encode(val, &array)];

        debug.warn("  '{}' code: {} [hexa: U+{x}]\n", .{ slice, val, val });
    }
}
