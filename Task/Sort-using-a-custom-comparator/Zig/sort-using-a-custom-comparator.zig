const std = @import("std");

/// Sort by descending length and ascending lexicographical order.
/// If true, element will remain on it's place.
fn lessThanFn(context: void, left: []const u8, right: []const u8) bool {
    _ = context;
    // Sort by descending length
    switch (std.math.order(left.len, right.len)) {
        .lt => return false,
        .eq => {},
        .gt => return true,
    }

    // If length is equal, sort by ascending lexicographical order
    return switch (std.ascii.orderIgnoreCase(left, right)) {
        .lt => true,
        .eq => false,
        .gt => false,
    };
}

pub fn main() void {
    var words = [_][]const u8{ "Here", "are", "some", "sample", "strings", "to", "be", "sorted" };

    std.debug.print("Before: [ ", .{});
    for (words) |word| {
        std.debug.print("\"{s}\" ", .{word});
    }
    std.debug.print("]\n", .{});

    std.mem.sort([]const u8, &words, {}, lessThanFn);

    std.debug.print("After: [ ", .{});
    for (words) |word| {
        std.debug.print("\"{s}\" ", .{word});
    }
    std.debug.print("]\n", .{});
}
