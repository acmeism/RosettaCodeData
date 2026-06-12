pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var result: std.ArrayList(u64) = .empty;
    defer result.deinit(allocator);

    {
        var n: u64 = 3;
        while (n <= 5000) : (n += 2)
            if (digitSum(n) == 25 and isPrime(n))
                try result.append(allocator, n);
    }

    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
    const stdout = &stdout_writer.interface;

    for (result.items, 0..) |n, i|
        _ = try stdout.print("{d:4}{s}", .{ n, if ((i + 1) % 6 == 0) "\n" else " " });

    try stdout.flush();
}
