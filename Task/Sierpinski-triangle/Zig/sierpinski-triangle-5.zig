fn sierpinski_triangle(allocator: Allocator, writer: anytype, n: u8) !void {
    const len = std.math.shl(usize, 1, n + 1);

    var b = try allocator.alloc(u8, len);
    defer allocator.free(b);
    for (b) |*ptr| ptr.* = ' ';

    b[len >> 1] = '*';

    _ = try writer.print("{s}\n", .{b});

    for (0..len / 2 - 1) |_| {
        try rule_90(allocator, b);
        _ = try writer.print("{s}\n", .{b});
    }
}
