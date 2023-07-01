const std = @import("std");
const warn = std.debug.warn;

const Allocator = std.mem.Allocator;

fn repeat(s: []const u8, times: u16, allocator: *Allocator) ![]u8 {
    const repeated = try allocator.alloc(u8, s.len*times);

    var i: usize = 0;
    while (i < s.len*times) : (i += 1) {
        repeated[i] = s[i % 2];
    }

    return repeated;
}

pub fn main() !void {
    const allocator = std.debug.global_allocator;
    const ex = try repeat("ha", 5, allocator);
    defer allocator.free(ex);
}
