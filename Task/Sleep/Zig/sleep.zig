const std = @import("std");
const time = std.time;
const warn = std.debug.warn;

pub fn main() void {
    warn("Sleeping...\n");

    time.sleep(1000000000); // `sleep` uses nanoseconds

    warn("Awake!\n");
}
