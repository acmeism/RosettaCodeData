const std = @import("std");

pub fn print(from: u32, to: u32) void {
    std.log.info("Moving disk from rod {} to rod {}", .{ from, to });
}

pub fn move(n: u32, from: u32, via: u32, to: u32) void {
    if (n > 1) {
        move(n - 1, from, to, via);
        print(from, to);
        move(n - 1, via, from, to);
    } else {
        print(from, to);
    }
}

pub fn main() !void {
    move(4, 1, 2, 3);
}
