const std = @import("std");

fn printVector(list: []const i32) void {
    const stdout = std.io.getStdOut().writer();
    stdout.print("[", .{}) catch unreachable;
    for (0..list.len - 1) |i| {
        stdout.print("{}, ", .{list[i]}) catch unreachable;
    }
    stdout.print("{}]\n", .{list[list.len - 1]}) catch unreachable;
}

fn deconvolution(allocator: std.mem.Allocator, a: []const i32, b: []const i32) ![]i32 {
    const result_len = a.len - b.len + 1;
    var result = try allocator.alloc(i32, result_len);
    @memset(result, 0);

    for (0..result_len) |n| {
        result[n] = a[n];
        const start = @max(@as(i64, @intCast(n)) - @as(i64, @intCast(b.len)) + 1, 0);
        var i: usize = @intCast(start);
        while (i < n) : (i += 1) {
            result[n] -= result[i] * b[n - i];
        }
        result[n] = @divTrunc(result[n], b[0]);
    }
    return result;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const h = [_]i32{ -8, -9, -3, -1, -6, 7 };
    const f = [_]i32{ -3, -6, -1, 8, -6, 3, -1, -9, -9, 3, -2, 5, 2, -2, -7, -1 };
    const g = [_]i32{ 24, 75, 71, -34, 3, 22, -45, 23, 245, 25, 52, 25, -67, -96, 96, 31, 55, 36, 29, -43, -7 };

    const stdout = std.io.getStdOut().writer();
    try stdout.print("h =                   ", .{});
    printVector(&h);

    const deconv_gf = try deconvolution(allocator, &g, &f);
    defer allocator.free(deconv_gf);
    try stdout.print("deconvolution(g, f) = ", .{});
    printVector(deconv_gf);

    try stdout.print("f =                   ", .{});
    printVector(&f);

    const deconv_gh = try deconvolution(allocator, &g, &h);
    defer allocator.free(deconv_gh);
    try stdout.print("deconvolution(g, h) = ", .{});
    printVector(deconv_gh);
}
