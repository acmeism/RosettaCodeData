const std = @import("std");

pub fn main() void {
    const clrs = [7][3]u8{
        [_]u8{255, 0, 0},   // red
        [_]u8{255, 128, 0}, // orange
        [_]u8{255, 255, 0}, // yellow
        [_]u8{0, 255, 0},   // green
        [_]u8{0, 0, 255},   // blue
        [_]u8{75, 0, 130},  // indigo
        [_]u8{128, 0, 255}, // violet
    };
    const s = "RAINBOW";
    for(0..7) |i| {
        std.debug.print("\x1B[38;2;{d};{d};{d}m{c}", .{clrs[i][0], clrs[i][1], clrs[i][2], s[i]});
    }
    std.debug.print("\n", .{});
}
