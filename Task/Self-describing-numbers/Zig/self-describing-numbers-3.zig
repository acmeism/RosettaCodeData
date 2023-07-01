pub fn main() anyerror!void {
    const stdout = std.io.getStdOut().writer();

    for (0..100_000_000) |number| {
        if (isSelfDescribing(@intCast(number)))
            _ = try stdout.print("{}\n", .{number});
    }
}
