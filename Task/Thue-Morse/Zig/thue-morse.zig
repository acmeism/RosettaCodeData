const std = @import("std");

fn thueMorse(comptime T: type, n: T) bool {
    var r = n;
    var s: u8 = @sizeOf(T);

    while (s > 0) : (s >>= 1) r ^= std.math.shr(T, r, s);
    return r & 1 == 1;
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    for (0..63) |n|
        try stdout.writeByte(if (thueMorse(@TypeOf(n), n)) '1' else '0');
    try stdout.writeByte('\n');
}
