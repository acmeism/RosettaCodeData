const std = @import("std");

fn vectorToString(comptime T: type, vec: []const T, allocator: std.mem.Allocator) ![]u8 {
    var result = std.ArrayList(u8).init(allocator);
    defer result.deinit();

    try result.append('[');
    for (vec, 0..) |item, i| {
        const str = try std.fmt.allocPrint(allocator, "{d}", .{item});
        defer allocator.free(str);
        try result.appendSlice(str);

        if (i < vec.len - 1) {
            try result.appendSlice(", ");
        }
    }
    try result.append(']');

    return result.toOwnedSlice();
}

fn jaccardIndex(a: []const i32, b: []const i32, allocator: std.mem.Allocator) !f64 {
    var set_a = std.AutoHashMap(i32, void).init(allocator);
    defer set_a.deinit();

    for (a) |item| {
        try set_a.put(item, {});
    }

    var intersection_count: u32 = 0;
    for (b) |item| {
        if (set_a.contains(item)) {
            intersection_count += 1;
        }
    }

    var union_set = std.AutoHashMap(i32, void).init(allocator);
    defer union_set.deinit();

    for (a) |item| {
        try union_set.put(item, {});
    }

    for (b) |item| {
        try union_set.put(item, {});
    }

    const union_count = union_set.count();

    if (union_count == 0) {
        return 1.0;
    } else if (intersection_count == 0) {
        return 0.0;
    } else {
        return @as(f64, @floatFromInt(intersection_count)) / @as(f64, @floatFromInt(union_count));
    }
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        const deinit_status = gpa.deinit();
        if (deinit_status == .leak) @panic("MEMORY LEAK");
    }

    const tests = [_][]const i32{
        &[_]i32{},
        &[_]i32{ 1, 2, 3, 4, 5 },
        &[_]i32{ 1, 3, 5, 7, 9 },
        &[_]i32{ 2, 4, 6, 8, 10 },
        &[_]i32{ 2, 3, 5, 7 },
        &[_]i32{ 8 },
    };

    const stdout = std.io.getStdOut().writer();
    try stdout.print("     Set A              Set B         J(A, B)\n", .{});
    try stdout.print("---------------------------------------------\n", .{});

    for (tests) |a| {
        for (tests) |b| {
            const a_str = try vectorToString(i32, a, allocator);
            defer allocator.free(a_str);

            const b_str = try vectorToString(i32, b, allocator);
            defer allocator.free(b_str);

            const index = try jaccardIndex(a, b, allocator);

            try stdout.print("{s: <19}{s: <19}{d:.5}\n", .{ a_str, b_str, index });
        }
    }
}
