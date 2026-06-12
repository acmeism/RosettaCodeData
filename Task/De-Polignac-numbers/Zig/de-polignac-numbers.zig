const std = @import("std");

fn isPrime(n: i32) bool {
    if (n < 2) return false;
    if (@rem(n, 2) == 0) return n == 2;
    if (@rem(n, 3) == 0) return n == 3;

    var p: i32 = 5;
    while (p * p <= n) {
        if (@rem(n, p) == 0) return false;
        p += 2;
        if (@rem(n, p) == 0) return false;
        p += 2;
    }
    return true;
}

fn isDepolignacNumber(n: i32) bool {
    var p: i32 = 1;
    while (p < n) : (p <<= 1) {
        if (isPrime(n - p)) return false;
    }
    return true;
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    try stdout.print("First 50 de Polignac numbers:\n", .{});

    var n: i32 = 1;
    var count: i32 = 0;

    while (count < 10000) : (n += 2) {
        if (isDepolignacNumber(n)) {
            count += 1;

            if (count <= 50) {
                try stdout.print("{d:5}", .{n});
                if (@rem(count, 10) == 0) {
                    try stdout.print("\n", .{});
                } else {
                    try stdout.print(" ", .{});
                }
            } else if (count == 1000) {
                try stdout.print("\nOne thousandth: {d}\n", .{n});
            } else if (count == 10000) {
                try stdout.print("\nTen thousandth: {d}\n", .{n});
            }
        }
    }
}
