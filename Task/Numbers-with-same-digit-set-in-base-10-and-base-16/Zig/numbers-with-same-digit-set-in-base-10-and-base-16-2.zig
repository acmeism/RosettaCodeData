const std = @import("std");
const print = std.debug.print;

const LIMIT = 100_000;

pub fn main() void {
    var count: usize = 0;
    var i: u64 = 0;
    while (i < LIMIT) : (i += 1)
        if (calcDigitSet(i, 10).eql(calcDigitSet(i, 16))) {
            count += 1;
            print("{d:5}{c}", .{ i, @as(u8, if (count % 10 != 0) ' ' else '\n') });
        };
}

fn calcDigitSet(n_: u64, comptime base: u5) std.StaticBitSet(16) {
    if (base < 2 or base > 16)
        @compileError("calcDigitSet() base must be in the closed interval 2 to 16");

    var n = n_;
    var set = std.StaticBitSet(16).initEmpty();

    while (n != 0) : (n /= base)
        set.set(n % base);
    return set;
}
