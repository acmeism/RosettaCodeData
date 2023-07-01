const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut();
    // `try` is a shorthand for `fn_call() catch |err| return err;`.
    // See also documentation for `catch`, `defer` and `errdefer`
    // for code flow adjustments
    try stdout.writer().writeAll("Hello world!\n");
}
