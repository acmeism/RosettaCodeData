pub fn main() !void {
    const stdout = @import("std").io.getStdOut().writer();

    var sum: u32 = 0;
    var i: u32 = 0;

    while (i < 50) : (i += 1) {
        sum += i * i * i;
        try stdout.print("{d:8}", .{sum});
        if (i % 5 == 4) try stdout.print("\n", .{});
    }
}
