pub fn main() anyerror!void {
    const stdout = std.io.getStdOut().writer();

    try stdout.print("Index Heading Compass point\n", .{});

    for (0..33) |i| {
        var heading = @as(f32, @floatFromInt(i)) * 11.25;
        heading += switch (i % 3) {
            1 => 5.62,
            2 => -5.62,
            else => 0,
        };
        const index = i % 32 + 1;
        try stdout.print("   {d:2} {d:>6.2}° {s}\n", .{ index, heading, degreesToCompassPoint(heading) });
    }
}
