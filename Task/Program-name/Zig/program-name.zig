const std = @import("std");

pub fn main() void {
    var args = std.process.args();

    const program_name = args.next().?;

    std.debug.print("{s}\n", .{program_name});
}
