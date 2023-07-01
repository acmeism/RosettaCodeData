pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer {
        const ok = gpa.deinit();
        std.debug.assert(ok == .ok);
    }
    const allocator = gpa.allocator();

    {
        const nc = try getCombs(allocator, 1, 7, true);
        defer allocator.free(nc.combinations);
        _ = try stdout.print("{d} unique solutions in 1 to 7\n", .{nc.num});
        _ = try stdout.print("{any}\n", .{nc.combinations});
    }
    {
        const nc = try getCombs(allocator, 3, 9, true);
        defer allocator.free(nc.combinations);
        _ = try stdout.print("{d} unique solutions in 3 to 9\n", .{nc.num});
        _ = try stdout.print("{any}\n", .{nc.combinations});
    }
    {
        const nc = try getCombs(allocator, 0, 9, false);
        defer allocator.free(nc.combinations);
        _ = try stdout.print("{d} non-unique solutions in 0 to 9\n", .{nc.num});
    }
}
