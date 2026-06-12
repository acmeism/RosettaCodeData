const std = @import("std");
const allocator = std.heap.page_allocator;

pub fn main() !void {
    const result = try generateSequence(5, 13);
    for (result) |item| {
        std.debug.print("{}", .{item});
    }
    std.debug.print("\n", .{});
}

fn generateSequence(_k: i32, _n: i32) ![]i32 {
    var k=_k; var n=_n;

    var s = std.ArrayList(std.ArrayList(i32)).init(allocator);

    for (0..@as(usize, @intCast(n))) |i| {
        var innerList = std.ArrayList(i32).init(allocator);
        if (i < k) {
            try innerList.append(1);
        } else {
            try innerList.append(0);
        }
        try s.append(innerList);
    }

    var d:i32 = n-k;
    n = @max(k, d);
    k = @min(k, d);
    var z = d;

    while (z > 0 or k > 1) {
        for (0..@as(usize, @intCast(k))) |i| {
            var lastList = s.items[s.items.len - 1 - i];
            for (lastList.items) |item| {
                try s.items[i].append(item);
            }
        }
        s.shrinkRetainingCapacity(s.items.len - @as(usize, @intCast(k)));
        z -= k;
        d = n - k;
        n = @max(k, d);
        k = @min(k, d);
    }

    var result = std.ArrayList(i32).init(allocator);

    for (s.items) |sublist| {
        for (sublist.items) |item| {
            try result.append(item);
        }
    }
    return result.toOwnedSlice();
}
