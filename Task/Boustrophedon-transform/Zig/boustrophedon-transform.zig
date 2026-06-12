const std = @import("std");

fn BoustrophedonIterator(comptime SequenceContext: type) type {
    return struct {
        index: i32,
        context: SequenceContext,
        cache: std.AutoHashMap(u32, std.AutoHashMap(u32, i64)),
        allocator: std.mem.Allocator,

        const Self = @This();

        fn init(allocator: std.mem.Allocator, context: SequenceContext) Self {
            return .{
                .index = -1,
                .context = context,
                .cache = std.AutoHashMap(u32, std.AutoHashMap(u32, i64)).init(allocator),
                .allocator = allocator,
            };
        }

        fn deinit(self: *Self) void {
            var it = self.cache.iterator();
            while (it.next()) |entry| {
                entry.value_ptr.deinit();
            }
            self.cache.deinit();
        }

        fn next(self: *Self) !i64 {
            self.index += 1;
            const index = @as(u32, @intCast(self.index));
            return self.transform(index, index);
        }

        fn transform(self: *Self, k: u32, n: u32) !i64 {
            if (n == 0) {
                return self.context.call(k);
            }

            if (self.cache.get(k)) |inner_map| {
                if (inner_map.get(n)) |value| {
                    return value;
                }
            }

            const value = try self.transform(k, n - 1) + try self.transform(k - 1, k - n);

            if (!self.cache.contains(k)) {
                try self.cache.put(k, std.AutoHashMap(u32, i64).init(self.allocator));
            }

            var inner_map = self.cache.getPtr(k).?;
            try inner_map.put(n, value);
            return value;
        }
    };
}

fn sievePrimes(limit: u32, primes: *std.ArrayList(u32), allocator: std.mem.Allocator) !void {
    try primes.append(2);
    const half_limit = (limit + 1) / 2;
    var composite = try allocator.alloc(bool, half_limit);
    defer allocator.free(composite);
    @memset(composite, false);

    var i: u32 = 1;
    var p: u32 = 3;

    while (i < half_limit) {
        if (!composite[i]) {
            try primes.append(p);
            var a = i + p;
            while (a < half_limit) {
                composite[a] = true;
                a += p;
            }
        }
        p += 2;
        i += 1;
    }
}

const OneOneContext = struct {
    pub fn call(_: @This(), number: u32) i64 {
        return if (number == 0) 1 else 0;
    }
};

const AllOnesContext = struct {
    pub fn call(_: @This(), _: u32) i64 {
        return 1;
    }
};

const AlternatingContext = struct {
    pub fn call(_: @This(), number: u32) i64 {
        return if (number % 2 == 0) 1 else -1;
    }
};

const PrimeContext = struct {
    primes: []const u32,

    pub fn call(self: @This(), number: u32) i64 {
        return @as(i64, @intCast(self.primes[number]));
    }
};

const FibonacciContext = struct {
    cache: *std.AutoHashMap(u32, i64),

    pub fn call(self: @This(), number: u32) !i64 {
        if (self.cache.get(number)) |value| {
            return value;
        }

        const value = if (number == 0 or number == 1)
            1
        else
            (try self.call(number - 2)) + (try self.call(number - 1));

        try self.cache.put(number, value);
        return value;
    }
};

const FactorialContext = struct {
    cache: *std.AutoHashMap(u32, i64),

    pub fn call(self: @This(), number: u32) !i64 {
        if (self.cache.get(number)) |value| {
            return value;
        }

        var value: i64 = 1;
        var i: u32 = 2;
        while (i <= number) : (i += 1) {
            value *= @as(i64, @intCast(i));
        }

        try self.cache.put(number, value);
        return value;
    }
};

fn display(title: []const u8, context: anytype, allocator: std.mem.Allocator) !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("{s}\n", .{title});

    var iterator = BoustrophedonIterator(@TypeOf(context)).init(allocator, context);
    defer iterator.deinit();

    var i: usize = 0;
    while (i < 15) : (i += 1) {
        try stdout.print("{} ", .{try iterator.next()});
    }
    try stdout.print("\n\n", .{});
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var primes = std.ArrayList(u32).init(allocator);
    defer primes.deinit();

    var fibonacci_cache = std.AutoHashMap(u32, i64).init(allocator);
    defer fibonacci_cache.deinit();

    var factorial_cache = std.AutoHashMap(u32, i64).init(allocator);
    defer factorial_cache.deinit();

    try sievePrimes(8_000, &primes, allocator);

    try display("One followed by an infinite series of zeros -> A000111", OneOneContext{}, allocator);
    try display("An infinite series of ones -> A000667", AllOnesContext{}, allocator);
    try display("(-1)^n: alternating 1, -1, 1, -1 -> A062162", AlternatingContext{}, allocator);
    try display("Sequence of prime numbers -> A000747", PrimeContext{ .primes = primes.items }, allocator);
    try display("Sequence of Fibonacci numbers -> A000744", FibonacciContext{ .cache = &fibonacci_cache }, allocator);
    try display("Sequence of factorial numbers -> A230960", FactorialContext{ .cache = &factorial_cache }, allocator);
}
