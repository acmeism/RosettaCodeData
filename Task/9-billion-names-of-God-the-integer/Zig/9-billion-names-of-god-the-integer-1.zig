const std = @import("std");
const print = std.debug.print;
const bigint = std.math.big.int.Managed;
const eql = std.mem.eql;
const Array = std.ArrayList;
const Array1 = Array(bigint);
const Array2 = Array(Array1);
var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

fn cumu(cache: *Array2, n: usize) !*Array1 {
    var y = cache.items.len;
    while (cache.items.len <= n) : (y += 1) {
        var roww = Array1.init(allocator);
        try roww.append(try bigint.init(allocator));
        for (1..y + 1) |x| {
            var cache_value = try cache.items[y - x].items[@min(x, y - x)].clone();
            try cache_value.add(&cache_value, &roww.getLast());
            try roww.append(cache_value);
        }
        try cache.append(roww);
    }
    return &(cache.items[n]);
}

fn row(cache: *Array2, n: usize) !void {
    const e = try cumu(cache, n);
    var v = try bigint.init(allocator);
    for (0..n) |i| {
        try v.sub(&e.items[i + 1], &e.items[i]);
        print(" {} ", .{v});
    }
    v.deinit();
    print("\n", .{});
}

pub fn main() !void {
    var cache = Array2.init(allocator);
    defer {
        cache.deinit();
    }
    defer {
        while (cache.popOrNull()) |l| {
            l.deinit();
        }
    }
    var cache0 = Array1.init(allocator);
    var v = try bigint.init(allocator);
    try v.set(1);
    try cache0.append(v);
    try cache.append(cache0);

    print("rows:\n", .{});
    for (1..1000) |x| {
        try row(&cache, x);
    }

    print("\nsums:\n", .{});
    for ([_]usize{ 23, 123, 999 }) |num| {
        const r = try cumu(&cache, num);
        print("{d: >4} {d}\n", .{ num, r.getLast() });
    }
}
