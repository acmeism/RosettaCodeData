const std = @import("std");

pub fn main() !void {
    var bw = std.io.bufferedWriter(std.io.getStdOut().writer());
    const writer = bw.writer();

    const limit = 1_000_000;
    try writer.print("Adjacent primes under {} whose difference is a square > 36:\n", .{limit});

    var a: u32 = undefined;
    var b: u32 = 3;
    while (b < limit) : (b = a) {
        a = nextPrime(b);
        const diff = a - b;
        if (diff > 36 and isSquare(diff))
            try writer.print("{} - {} = {}\n", .{ a, b, diff });
    }
    try bw.flush();
}

fn nextPrime(n_: anytype) @TypeOf(n_) {
    const T = @TypeOf(n_);
    if (@typeInfo(T) != .int or @typeInfo(T).int.signedness != .unsigned)
        @compileError("nextPrime() expected unsigned integer argument, found " ++ @typeName(T));

    if (n_ < 2) return 2;
    if (n_ == 2) return 3;
    if (n_ % 2 == 0) return n_ + 1;

    var n = n_ + 2;
    while (!isPrime(n))
        n += 2;
    return n;
}

fn isPrime(n: anytype) bool {
    const T = @TypeOf(n);
    if (@typeInfo(T) != .int or @typeInfo(T).int.signedness != .unsigned)
        @compileError("isPrime() expected unsigned integer argument, found " ++ @typeName(T));

    if (n < 2) return false;

    inline for ([3]u3{ 2, 3, 5 }) |p| if (n % p == 0) return n == p;

    const wheel = comptime [_]u3{ 4, 2, 4, 2, 4, 6, 2, 6 };

    var p: T = 7;
    while (true)
        for (wheel) |w| {
            if (p * p > n) return true;
            if (n % p == 0) return false;
            p += w;
        };
}

fn isSquare(n: anytype) bool {
    const T = @TypeOf(n);
    if (@typeInfo(T) != .int or @typeInfo(T).int.signedness != .unsigned)
        @compileError("isSquare() expected unsigned integer argument, found " ++ @typeName(T));

    const root: T = std.math.sqrt(n);
    return root * root == n;
}
