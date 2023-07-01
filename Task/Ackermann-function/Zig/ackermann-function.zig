pub fn ack(m: u64, n: u64) u64 {
    if (m == 0) return n + 1;
    if (n == 0) return ack(m - 1, 1);
    return ack(m - 1, ack(m, n - 1));
}

pub fn main() !void {
    const stdout = @import("std").io.getStdOut().writer();

    var m: u8 = 0;
    while (m <= 3) : (m += 1) {
        var n: u8 = 0;
        while (n <= 8) : (n += 1)
            try stdout.print("{d:>8}", .{ack(m, n)});
        try stdout.print("\n", .{});
    }
}
