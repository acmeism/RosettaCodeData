const std = @import("std");
const math = std.math;
const heap = std.heap;

pub fn main() !void {
    var arena = heap.ArenaAllocator.init(heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    var candidates = std.PriorityQueue(u32, void, u32cmp).init(allocator, {});
    defer candidates.deinit();

    const stdout = std.io.getStdOut().writer();

    try stdout.print("The circular primes are:\n", .{});
    try stdout.print("{:10}" ** 4, .{ 2, 3, 5, 7 });

    var c: u32 = 4;
    try candidates.add(0);
    while (true) {
        var n = candidates.remove();
        if (n > 1_000_000)
            break;
        if (n > 10 and circular(n)) {
            try stdout.print("{:10}", .{n});
            c += 1;
            if (c % 10 == 0)
                try stdout.print("\n", .{});
        }
        try candidates.add(10 * n + 1);
        try candidates.add(10 * n + 3);
        try candidates.add(10 * n + 7);
        try candidates.add(10 * n + 9);
    }
    try stdout.print("\n", .{});
}

fn u32cmp(_: void, a: u32, b: u32) math.Order {
    return math.order(a, b);
}

fn circular(n0: u32) bool {
    if (!isPrime(n0))
        return false
    else {
        var n = n0;
        var d: u32 = @intFromFloat(@log10(@as(f32, @floatFromInt(n))));
        return while (d > 0) : (d -= 1) {
            n = rotate(n);
            if (n < n0 or !isPrime(n))
                break false;
        } else true;
    }
}

fn rotate(n: u32) u32 {
    if (n == 0)
        return 0
    else {
        const d: u32 = @intFromFloat(@log10(@as(f32, @floatFromInt(n)))); // digit count - 1
        const m = math.pow(u32, 10, d);
        return (n % m) * 10 + n / m;
    }
}

fn isPrime(n: u32) bool {
    if (n < 2)
        return false;

    inline for ([3]u3{ 2, 3, 5 }) |p| {
        if (n % p == 0)
            return n == p;
    }

    const wheel235 = [_]u3{
        6, 4, 2, 4, 2, 4, 6, 2,
    };
    var i: u32 = 1;
    var f: u32 = 7;
    return while (f * f <= n) {
        if (n % f == 0)
            break false;
        f += wheel235[i];
        i = (i + 1) & 0x07;
    } else true;
}
