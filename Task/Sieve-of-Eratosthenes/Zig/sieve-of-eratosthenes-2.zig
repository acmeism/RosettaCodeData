const std = @import("std");
const heap = std.heap;
const mem = std.mem;
const stdout = std.io.getStdOut().writer();

pub fn main() !void {
    const assert = std.debug.assert;

    var buf: [fixed_alloc_sz(1000)]u8 = undefined; // buffer big enough for 1,000 primes.
    var fba = heap.FixedBufferAllocator.init(&buf);

    const sieve = try SoE.init(1000, &fba.allocator);
    defer sieve.deinit(); // not needed for the FBA, but in general you would de-init the sieve

    // test membership functions
    assert(sieve.contains(997));
    assert(!sieve.contains(995));
    assert(!sieve.contains(994));
    assert(!sieve.contains(1009));

    try stdout.print("There are {} primes < 1000\n", .{sieve.size()});
    var c: u32 = 0;
    var iter = sieve.iterator();
    while (iter.next()) |p| {
        try stdout.print("{:5}", .{p});
        c += 1;
        if (c % 10 == 0)
            try stdout.print("\n", .{});
    }
    try stdout.print("\n", .{});
}

// return size to sieve n prmes if using the Fixed Buffer Allocator
//     adds some u64 words for FBA bookkeeping.
pub inline fn fixed_alloc_sz(limit: usize) usize {
    return (2 + limit / 128) * @sizeOf(u64);
}

pub const SoE = struct {
    const all_u64bits_on = 0xFFFF_FFFF_FFFF_FFFF;
    const empty = [_]u64{};

    sieve: []u64,
    alloc: *mem.Allocator,

    pub fn init(limit: u64, allocator: *mem.Allocator) error{OutOfMemory}!SoE {
        if (limit < 3)
            return SoE{
                .sieve = &empty,
                .alloc = allocator,
            };

        var bit_sz = (limit + 1) / 2 - 1;
        var q = bit_sz >> 6;
        var r = bit_sz & 0x3F;
        var sz = q + @boolToInt(r > 0);
        var sieve = try allocator.alloc(u64, sz);

        var i: usize = 0;
        while (i < q) : (i += 1)
            sieve[i] = all_u64bits_on;
        if (r > 0)
            sieve[q] = (@as(u64, 1) << @intCast(u6, r)) - 1;

        var bit: usize = 0;
        while (true) {
            while (sieve[bit >> 6] & @as(u64, 1) << @intCast(u6, bit & 0x3F) == 0)
                bit += 1;

            const p = 2 * bit + 3;
            q = p * p;
            if (q > limit)
                return SoE{
                    .sieve = sieve,
                    .alloc = allocator,
                };

            r = (q - 3) / 2;
            while (r < bit_sz) : (r += p)
                sieve[r >> 6] &= ~((@as(u64, 1)) << @intCast(u6, r & 0x3F));

            bit += 1;
        }
    }

    pub fn deinit(self: SoE) void {
        if (self.sieve.len > 0) {
            self.alloc.free(self.sieve);
        }
    }

    pub fn iterator(self: SoE) SoE_Iterator {
        return SoE_Iterator.init(self.sieve);
    }

    pub fn size(self: SoE) usize {
        var sz: usize = 1; // sieve doesn't include 2.
        for (self.sieve) |bits|
            sz += @popCount(u64, bits);
        return sz;
    }

    pub fn contains(self: SoE, n: u64) bool {
        if (n & 1 == 0)
            return n == 2
        else {
            const bit = (n - 3) / 2;
            const q = bit >> 6;
            const r = @intCast(u6, bit & 0x3F);
            return if (q >= self.sieve.len)
                false
            else
                self.sieve[q] & (@as(u64, 1) << r) != 0;
        }
    }
};

// Create an iterater object to enumerate primes we've generated.
const SoE_Iterator = struct {
    const Self = @This();

    start: u64,
    bits: u64,
    sieve: []const u64,

    pub fn init(sieve: []const u64) Self {
        return Self{
            .start = 0,
            .sieve = sieve,
            .bits = sieve[0],
        };
    }

    pub fn next(self: *Self) ?u64 {
        if (self.sieve.len == 0)
            return null;

        // start = 0 => first time, so yield 2.
        if (self.start == 0) {
            self.start = 3;
            return 2;
        }

        var x = self.bits;
        while (true) {
            if (x != 0) {
                const p = @ctz(u64, x) * 2 + self.start;
                x &= x - 1;
                self.bits = x;
                return p;
            } else {
                self.start += 128;
                self.sieve = self.sieve[1..];
                if (self.sieve.len == 0)
                    return null;
                x = self.sieve[0];
            }
        }
    }
};
