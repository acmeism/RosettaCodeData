// - Install zig from https://ziglang.org/download/.
// - Extract into your path
// - `zig run newbie.zig`
const std = @import("std");

pub fn main() void {
    // If you only want to quickly debug things and panic on failure,
    // you can use `debug.print` to print to standard error
    // Do not use debug code in production.
    std.debug.print("Hello, World!\n");
}
