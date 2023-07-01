const std = @import("std");
const c = @cImport({
    @cInclude("stdlib.h"); // `free`
    @cInclude("string.h"); // `strdup`
});

pub fn main() !void {
    const string = "Hello World!";
    var copy = c.strdup(string);

    try std.io.getStdOut().writer().print("{s}\n", .{copy});
    c.free(copy);
}
