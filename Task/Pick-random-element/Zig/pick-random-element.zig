const std = @import("std");

const debug = std.debug;
const rand = std.rand;
const time = std.time;

test "pick random element" {
    var pcg = rand.Pcg.init(time.milliTimestamp());

    const chars = [_]u8{
        'A', 'B', 'C', 'D',
        'E', 'F', 'G', 'H',
        'I', 'J', 'K', 'L',
        'M', 'N', 'O', 'P',
        'Q', 'R', 'S', 'T',
        'U', 'V', 'W', 'X',
        'Y', 'Z', '?', '!',
        '<', '>', '(', ')',
    };

    var i: usize = 0;
    while (i < 32) : (i += 1) {
        if (i % 4 == 0) {
            debug.warn("\n  ", .{});
        }
        debug.warn("'{c}', ", .{chars[pcg.random.int(usize) % chars.len]});
    }

    debug.warn("\n", .{});
}
