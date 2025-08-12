const std = @import("std");

fn gcd(a: u64, b: u64) u64 {
    if (b == 0) return a;
    return gcd(b, a % b);
}

fn sternBrocot(allocator: std.mem.Allocator, up_to: u64) !std.ArrayList(u64) {
    var seq = std.ArrayList(u64).init(allocator);
    try seq.append(1);
    try seq.append(1);

    var last: u64 = 1;
    var idx: usize = 1;

    while (last < up_to) {
        last = seq.items[idx];
        try seq.append(last + seq.items[idx - 1]);
        try seq.append(last);
        idx += 1;
    }

    return seq;
}

fn testSternBrocot() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var seq = try sternBrocot(allocator, 100);

    // Print first 15 in sequence
    std.debug.print("First 15 in sequence: ", .{});
    std.debug.print("[", .{});
    for (seq.items[0..15], 0..) |val, i| {
        if (i > 0) std.debug.print(", ", .{});
        std.debug.print("{d}", .{val});
    }
    std.debug.print("]\n", .{});

    // Print first positions of integers 1 through 10
    std.debug.print("First positions of integers 1 through 10:\n", .{});
    for (1..11) |i| {
        const i_u64 = @as(u64, i);
        var found = false;
        for (seq.items, 0..) |val, pos| {
            if (val == i_u64) {
                std.debug.print("    {d:>2} at position {d}\n", .{i, pos + 1});
                found = true;
                break;
            }
        }
        if (!found) {
            std.debug.print("Error finding position of {d}\n", .{i});
        }
    }

    // Find position of 100
    for (seq.items, 0..) |val, pos| {
        if (val == 100) {
            std.debug.print("   100 at position {d}\n", .{pos + 1});
            break;
        }
    }

    // Check if first 999 consecutive pairs have gcd of 1
    var all_gcd_one = true;
    for (1..1000) |i| {
        if (i >= seq.items.len) break;
        if (gcd(seq.items[i - 1], seq.items[i]) != 1) {
            all_gcd_one = false;
            break;
        }
    }
    std.debug.print("The first 999 consecutive pairs have gcd of 1: {any}.\n", .{all_gcd_one});
}

pub fn main() !void {
    try testSternBrocot();
}
