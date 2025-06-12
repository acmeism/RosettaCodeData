const std = @import("std");

const debug = std.debug;
const rand = std.Random;
const time = std.time;

pub fn main() void {
    var pcg = rand.Pcg.init(@intCast(time.milliTimestamp()));

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


    for(0..32) |i| {
        if (i % 4 == 0) {
            debug.print("\n  ", .{});
        }
        debug.print("'{c}', ", .{chars[pcg.random().uintLessThan(usize, chars.len)]});
    }

    debug.print("\n", .{});
}
