const std = @import("std");
const print = std.debug.print;
const Order = std.math.Order;

// Generic merge function for two sorted slices
fn merge2(comptime T: type, c1: []const T, c2: []const T, action: *const fn (T) void) void {
    var idx1: usize = 0;
    var idx2: usize = 0;

    while (idx1 < c1.len and idx2 < c2.len) {
        if (std.math.order(c1[idx1], c2[idx2]) != .gt) {
            action(c1[idx1]);
            idx1 += 1;
        } else {
            action(c2[idx2]);
            idx2 += 1;
        }
    }

    while (idx1 < c1.len) {
        action(c1[idx1]);
        idx1 += 1;
    }

    while (idx2 < c2.len) {
        action(c2[idx2]);
        idx2 += 1;
    }
}

// Generic merge function for n sorted slices
fn mergeN(comptime T: type, action: *const fn (T) void, all: []const []const T, allocator: std.mem.Allocator) !void {
    // Create iterator tracking (current_index, end_index) for each slice
    var vit = try allocator.alloc(struct { start: usize, end: usize }, all.len);
    defer allocator.free(vit);

    // Initialize iterators
    for (all, 0..) |slice, i| {
        vit[i] = .{ .start = 0, .end = slice.len };
    }

    while (true) {
        var done = true;
        var least: ?usize = null;

        // Find the slice with the smallest current element
        for (vit, 0..) |*iter, i| {
            if (iter.start < iter.end) {
                if (least == null) {
                    least = i;
                } else if (least) |l| {
                    if (std.math.order(all[i][iter.start], all[l][vit[l].start]) == .lt) {
                        least = i;
                    }
                }
            }
        }

        if (least) |l| {
            if (vit[l].start < vit[l].end) {
                done = false;
                action(all[l][vit[l].start]);
                vit[l].start += 1;
            }
        }

        if (done) {
            break;
        }
    }
}

fn display(num: i32) void {
    print("{d} ", .{num});
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const v1 = [_]i32{ 0, 3, 6 };
    const v2 = [_]i32{ 1, 4, 7 };
    const v3 = [_]i32{ 2, 5, 8 };

    merge2(i32, &v2, &v1, display);
    print("\n" , .{});

    try mergeN(i32, display, &[_][]const i32{&v1}, allocator);
    print("\n" , .{});

    try mergeN(i32, display, &[_][]const i32{ &v3, &v2, &v1 }, allocator);
    print("\n" , .{});
}
