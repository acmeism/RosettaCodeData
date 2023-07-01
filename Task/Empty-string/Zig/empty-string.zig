const std = @import("std");

pub fn main() !void {
    // default is [:0]const u8, which is a 0-terminated string with len field
    const str = "";
    if (str.len == 0) {
        std.debug.print("string empty\n", .{});
    }
    if (str.len != 0) {
        std.debug.print("string not empty\n", .{});
    }
}
