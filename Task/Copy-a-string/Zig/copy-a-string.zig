const std = @import("std");

const debug = std.debug;
const mem = std.mem;

test "copy a string" {
    const source = "A string.";

    // Variable `dest1` will have the same type as `source`, which is
    // `*const [9:0]u8`.
    const dest1 = source;

    // Variable `dest2`'s type is [9]u8.
    //
    // The difference between the two is that `dest1` string is null-terminated,
    // while `dest2` is not.
    var dest2: [source.len]u8 = undefined;
    mem.copy(u8, dest2[0..], source[0..]);

    debug.assert(mem.eql(u8, dest1[0..], "A string."));
    debug.assert(mem.eql(u8, dest2[0..], "A string."));
}
