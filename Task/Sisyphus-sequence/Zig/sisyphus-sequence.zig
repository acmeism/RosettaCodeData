const primesieve = @cImport({
    @cInclude("primesieve.h");
});
const std = @import("std");
const mem = std.mem;

pub fn main() !void {
    var t0 = try std.time.Timer.start();
    // ------------------------------------------------------- stdout
    const stdout = std.io.getStdOut().writer();
    // ---------------------------------------------------- allocator
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();
    // --------------------------------------------------------------
    var counter = try Counter.init(allocator);
    defer counter.deinit();

    var sisyphus = try SisyphusSequenceGenerator.init();
    defer sisyphus.deinit();

    var number: u64 = undefined;
    for (0..10) |_| {
        for (0..10) |_| {
            number = try sisyphus.next();
            try counter.add(number);
            try stdout.print(" {d:3}", .{number});
        }
        try stdout.writeByte('\n');
    }
    try stdout.writeByte('\n');

    for ([_]usize{ 1_000, 10_000, 100_000, 1_000_000, 10_000_000, 100_000_000 }) |n| {
        while (counter.count != n) {
            number = try sisyphus.next();
            try counter.add(number);
        }
        try stdout.print(
            "{d:10}th member is {d:10} and highest prime needed is {d:9}\n",
            .{ n, number, sisyphus.prime },
        );
    }
    {
        try stdout.writeAll("\nThese numbers under 250 do not occur in the first 100,000,000 terms:\n");
        const missing = try counter.getMissing(allocator);
        defer allocator.free(missing);

        var sep: []const u8 = "";
        for (missing) |n| {
            try stdout.print("{s}{d}", .{ sep, n });
            sep = ", ";
        }
        try stdout.writeByte('\n');
    }
    {
        try stdout.writeAll("\nThese numbers under 250 occur the most in the first 100,000,000 terms:\n");
        const most = try counter.getMost(allocator);
        defer allocator.free(most.numbers);

        var sep: []const u8 = "";
        for (most.numbers) |n| {
            try stdout.print("{s}{d}", .{ sep, n });
            sep = ", ";
        }
        try stdout.print(" all occur {d} times.\n", .{most.max});
    }
    var count = counter.count; // Only need the count, not the found hashmap. Ditch counter.
    while (true) {
        number = try sisyphus.next();
        count += 1;
        if (number == 36) {
            try stdout.print(
                "\nMember {d} is {d} and highest prime needed is {d}\n",
                .{ count, number, sisyphus.prime },
            );
            break;
        }
    }
    try stdout.print("\nProcessed in {}\n", .{std.fmt.fmtDuration(t0.read())});
}

const SisyphusSequenceGeneratorError = error{
    PrimeSieveError,
};

const SisyphusSequenceGenerator = struct {
    it: primesieve.primesieve_iterator = undefined,
    next_: u64 = 1,
    prime: u64 = 0,

    fn init() !SisyphusSequenceGenerator {
        var si = SisyphusSequenceGenerator{};
        primesieve.primesieve_init(&si.it);
        return si;
    }
    fn deinit(self: *SisyphusSequenceGenerator) void {
        primesieve.primesieve_free_iterator(&self.it);
    }
    fn next(self: *SisyphusSequenceGenerator) SisyphusSequenceGeneratorError!u64 {
        const n = self.next_;
        if (self.next_ % 2 == 0) {
            self.next_ /= 2;
        } else {
            self.prime = primesieve.primesieve_next_prime(&self.it);
            if (self.it.is_error != 0 or self.prime == primesieve.PRIMESIEVE_ERROR)
                return SisyphusSequenceGeneratorError.PrimeSieveError;
            self.next_ += self.prime;
        }
        return n;
    }
};

const Counter = struct {
    found: std.AutoHashMap(u64, usize),
    count: usize = 0,

    fn init(allocator: mem.Allocator) !Counter {
        var found = std.AutoHashMap(u64, usize).init(allocator);
        try found.ensureTotalCapacity(250);
        for (1..250) |n|
            try found.put(@as(u64, n), 0);
        return Counter{ .found = found };
    }
    fn deinit(self: *Counter) void {
        self.found.deinit();
    }
    fn add(self: *Counter, n: u64) !void {
        self.count += 1;
        if (n < 250)
            self.found.getEntry(n).?.value_ptr.* += 1;
    }
    /// Caller owns returned slice memory.
    fn getMissing(self: *const Counter, allocator: mem.Allocator) ![]u64 {
        var missing_array = std.ArrayList(u64).init(allocator);
        var it = self.found.iterator();
        while (it.next()) |entry| {
            if (entry.value_ptr.* == 0)
                try missing_array.append(entry.key_ptr.*);
        }
        const missing = try missing_array.toOwnedSlice();
        mem.sort(u64, missing, {}, std.sort.asc(u64));
        return missing;
    }
    /// Caller owns returned 'numbers' slice memory.
    fn getMost(self: *const Counter, allocator: mem.Allocator) !struct { numbers: []u64, max: usize } {
        // Find the maximum count (there may be more than one at this value)
        var value_it = self.found.valueIterator();
        var max: usize = 0;
        while (value_it.next()) |count|
            max = @max(max, count.*);

        var most_array = std.ArrayList(u64).init(allocator);
        var it = self.found.iterator();
        while (it.next()) |entry| {
            if (entry.value_ptr.* == max)
                try most_array.append(entry.key_ptr.*);
        }
        const most = try most_array.toOwnedSlice();
        mem.sort(u64, most, {}, std.sort.asc(u64));
        return .{ .numbers = most, .max = max };
    }
};
