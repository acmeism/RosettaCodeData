const std = @import("std");
const ps = @cImport({
    @cInclude("primesieve.h");
});

pub fn main() !void {
    var t0 = try std.time.Timer.start();

    const stdout = std.io.getStdOut().writer();

    const limit = 5500;
    var triplet_generator = try PrimeTripletGenerator.init(limit);
    defer triplet_generator.deinit();

    try stdout.writeAll("Primesieve prime triplets:\n");
    var count: usize = 0;
    while (try triplet_generator.next()) |triplet| {
        count += 1;
        try stdout.print("{d:4}, {d:4}, {d:4}\n", .{ triplet[0], triplet[1], triplet[2] });
    }
    try stdout.print("\n{d} triplets less than {d}\n\n", .{ count, limit });

    try stdout.print("Processed in {}\n", .{std.fmt.fmtDuration(t0.read())});
}

const PrimeTripletGeneratorError = error{PrimeSieveError};

const PrimeTripletGenerator = struct {
    stop: u64,
    it: ps.primesieve_iterator,
    prime1: u64,
    prime2: u64,

    fn init(stop: u64) !PrimeTripletGenerator {
        var it: ps.primesieve_iterator = undefined;
        ps.primesieve_init(&it);

        var primes: [2]u64 = undefined;
        for (&primes) |*prime| {
            prime.* = ps.primesieve_next_prime(&it);
            if (it.is_error != 0 or prime.* == ps.PRIMESIEVE_ERROR)
                return PrimeTripletGeneratorError.PrimeSieveError;
        }
        return PrimeTripletGenerator{
            .stop = stop,
            .it = it,
            .prime1 = primes[0],
            .prime2 = primes[1],
        };
    }
    fn deinit(self: *PrimeTripletGenerator) void {
        ps.primesieve_free_iterator(&self.it);
    }
    fn next(self: *PrimeTripletGenerator) !?[3]u64 {
        while (true) {
            const prime = ps.primesieve_next_prime(&self.it);
            if (self.it.is_error != 0 or prime == ps.PRIMESIEVE_ERROR)
                return PrimeTripletGeneratorError.PrimeSieveError;
            if (prime >= self.stop)
                return null;
            const prime0 = self.prime1;
            self.prime1 = self.prime2;
            self.prime2 = prime;
            if ((self.prime1 - prime0) == 2 and (prime - prime0) == 6)
                return .{ prime0, self.prime1, prime };
        }
    }
};
