const std = @import("std");
const fmt = std.fmt;
const warn = std.debug.warn;

pub fn main() void {
    var i: u8 = 0;
    var buf: [3]u8 = undefined;

    while (i < 255) : (i += 1) {
        _ = fmt.formatIntBuf(buf[0..], i, 8, false, 0); // buffer, value, base, uppercase, width
        warn("{}\n", buf);
    }
}
