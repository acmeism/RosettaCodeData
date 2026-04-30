const std = @import("std");

/// Calculates the sum of proper divisors of n (excluding n itself)
fn chowla(n: usize) usize {
    var sum: usize = 0;
    var i: usize = 2;
    while (i * i <= n) : (i += 1) {
        if (n % i == 0) {
            const j = n / i;
            sum += i;
            if (i != j) sum += j;
        }
    }
    return sum;
}

/// Creates a sieve of Eratosthenes for finding primes
/// Returns a slice where true denotes composite, false denotes prime
fn sieve(limit: usize) []bool {
    const allocator = std.heap.page_allocator;
    const c = allocator.alloc(bool, limit) catch unreachable;
    @memset(c, false);

    var i: usize = 3;
    while (i * 3 < limit) : (i += 2) {
        if (!c[i] and chowla(i) == 0) {
            var j: usize = 3 * i;
            while (j < limit) : (j += 2 * i) {
                c[j] = true;
            }
        }
    }
    return c;
}

pub fn main() void {
    // Demonstrate chowla function for numbers 1-37
    var i: usize = 1;
    while (i <= 37) : (i += 1) {
        std.debug.print("chowla({}) = {}\n", .{ i, chowla(i) });
    }

    // Count primes up to 10 million
    const limit = 10_000_000;
    const c = sieve(limit);
    var count: usize = 1;
    var power: usize = 100;

    i = 3;
    while (i < limit) : (i += 2) {
        if (!c[i]) count += 1;
        if (i == power - 1) {
            std.debug.print("Count of primes up to {} = {}\n", .{ power, count });
            power *= 10;
        }
    }

    // Find perfect numbers using the formula: p = k * (k+1) / 2 where
    // p is perfect if and only if 2^k - 1 is prime (Mersenne prime)
    const perfect_limit = 35_000_000;
    var perfect_count: usize = 0;
    var k: usize = 2;
    var kk: usize = 3;

    while (true) {
        const p = k * kk;
        if (p > perfect_limit) break;
        if (chowla(p) == p - 1) {
            std.debug.print("{} is a number that is perfect\n", .{p});
            perfect_count += 1;
        }
        k = kk + 1;
        kk += k;
    }

    std.debug.print("There are {} perfect numbers <= 35,000,000\n", .{perfect_count});
}
