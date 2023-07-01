const std = @import("std");
// To replace exceptions, Zig has error enums to handle error states.

pub fn main() !void {
    // writing to stdout as file descriptor might fail,
    // if we are a child process and the parent process has closed it
    const stdout_wr = std.io.getStdOut().writer();
    try stdout_wr.writeAll("a");
    // Above code is identical to
    stdout_wr.writeAll("a") catch |err| return err;
    stdout_wr.writeAll("a") catch |err| {
        // usually std streams are leaked and the Kernel cleans them up
        var stdin = std.io.getStdIn();
        var stderr = std.io.getStdErr();
        stdin.close();
        stderr.close();
        return err;
    };
}
