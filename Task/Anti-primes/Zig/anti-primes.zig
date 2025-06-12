const std = @import("std");

fn sieve(allocator: std.mem.Allocator, n: usize) ![]i32 {
    var is_prime = try allocator.alloc(i32, n);
    var primes = std.ArrayList(i32).init(allocator);
    defer allocator.free(is_prime);
    for (is_prime) |*p| {
        p.* = 1;
    }
    is_prime[0] = 0;
    is_prime[1] = 0;
    for (2..n) |i| {
        if (is_prime[i] == 1) {
            var j = i * i;
            while (j < n) : (j += i) {
                is_prime[j] = 0;
            }
        }
    }
    for (2..n) |i| {
        if (is_prime[i] == 1) {
            try primes.append(@intCast(i));
        }
    }
    return primes.toOwnedSlice();
}

const AntiPrime = struct {
    value: i32,
    divisors_count: i32,
    factorization: std.ArrayList(i32),

    pub fn init(allocator: std.mem.Allocator, value: i32, divisors_count: i32, factors: []i32) !AntiPrime {
        var factorization = try std.ArrayList(i32).initCapacity(allocator, factors.len);
        errdefer factorization.deinit();
        try factorization.appendSlice(factors);
        return AntiPrime{
            .value = value,
            .divisors_count = divisors_count,
            .factorization = factorization,
        };
    }

    pub fn deinit(self: *AntiPrime) void {
        self.factorization.deinit();
    }

    pub fn asc(context: void, a: AntiPrime, b: AntiPrime) bool {
        _ = context;
        if (a.value < b.value) return true;
        if (a.value > b.value) return false;
        if (a.divisors_count < b.divisors_count) return true;
        if (a.divisors_count > b.divisors_count) return false;
        if (a.factorization.items.len < b.factorization.items.len) return true;
        if (a.factorization.items.len > b.factorization.items.len) return false;
        for (a.factorization.items, b.factorization.items) |a_factor, b_factor| {
            if (a_factor < b_factor) return true;
            if (a_factor > b_factor) return false;
        }
        return false;
    }

    pub fn clone(self: *AntiPrime) !AntiPrime {
        var new_factorization = try std.ArrayList(i32).initCapacity(self.factorization.allocator, self.factorization.items.len);
        errdefer new_factorization.deinit();
        try new_factorization.appendSlice(self.factorization.items);
        return AntiPrime{
            .value = self.value,
            .divisors_count = self.divisors_count,
            .factorization = new_factorization,
        };
    }
};
const MAXN = 100000000;
fn generate_anti_primes(allocator: std.mem.Allocator) ![]AntiPrime {
    var anti_primes = std.ArrayList(AntiPrime).init(allocator);
    try anti_primes.append(try AntiPrime.init(allocator, 1, 1, &[_]i32{}));
    const primes = try (sieve(allocator, 1000));
    defer allocator.free(primes);

    for (primes, 0..) |prime, i| {
        var new_anti_primes = std.ArrayList(AntiPrime).init(allocator);
        defer {
            for (new_anti_primes.items) |*new_anti_prime| {
                new_anti_prime.*.deinit();
            }
            new_anti_primes.deinit();
        }
        for (anti_primes.items) |*el| {
            try new_anti_primes.append(try el.*.clone());
            if (el.*.factorization.items.len < i) continue;
            const e_max = if (i >= 1) el.*.factorization.items[i - 1] else @as(i32, @intCast(std.math.log2(MAXN)));
            var n1 = el.*.value;
            var e: i32 = 1;
            while (e <= e_max) : (e += 1) {
                n1 *= prime;
                if (n1 > MAXN) break;
                const div = el.*.divisors_count * (e + 1);
                var exponents = std.ArrayList(i32).init(allocator);
                defer exponents.deinit();
                try exponents.appendSlice(el.*.factorization.items);
                try exponents.append(e);
                try new_anti_primes.append(try AntiPrime.init(
                    allocator,
                    @as(i32, n1),
                    div,
                    exponents.items,
                ));
            }
        }
        std.mem.sort(AntiPrime, new_anti_primes.items, {}, AntiPrime.asc);
        for (anti_primes.items) |*anti_prime| {
            anti_prime.*.deinit();
        }
        try anti_primes.resize(0);
        try anti_primes.append(try AntiPrime.init(
            allocator,
            1,
            1,
            &[_]i32{},
        ));

        for (new_anti_primes.items) |*el| {
            if (el.divisors_count > anti_primes.getLast().divisors_count) {
                try anti_primes.append(try el.*.clone());
            }
        }
    }

    return anti_primes.toOwnedSlice();
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        const result = gpa.deinit();
        if (result == .leak) {
            std.debug.panic("Memory leak detected in GeneralPurposeAllocator deinit", .{});
        }
    }
    const stdout = std.io.getStdOut().writer();
    const n = 20;

    const anti_primes = try generate_anti_primes(allocator);
    defer {
        for (anti_primes) |*anti_prime| {
            anti_prime.*.deinit();
        }
        allocator.free(anti_primes);
    }

    try stdout.print("The first 20 anti-primes:\n", .{});
    for (anti_primes[0..n], 0..) |anti_prime, index| {
        try stdout.print("{} ", .{anti_prime.value});
        if (index % 10 == 9) {
            try stdout.print("\n", .{});
        }
    }
}
