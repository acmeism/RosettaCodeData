// Since in the common case (primes < 2^32 - 1), the stack only needs to be 8 16-bit words long
// (only twice the size of a pointer) the required stacks are stored in each cell, rather
// than using an indirection (e.g. linked list of integer cells)
//
const std = @import("std");
const builtin = std.builtin;
const meta = std.meta;
const mem = std.mem;

fn assertInt(comptime T: type) builtin.TypeInfo.Int {
    const Signedness = builtin.Signedness;
    if (@typeInfo(T) != .Int)
        @compileError("data type must be an integer.");
    const int = @typeInfo(T).Int;
    if (int.signedness == Signedness.signed or int.bits % 2 == 1 or int.bits < 4 or int.bits > 64)
        @compileError("type must be an unsigned integer with even bit size (of at least 4 bits).");
    return int;
}

// given a type, return the maximum stack size required by the algorthm.
fn listSize(comptime T: type) usize {
    _ = assertInt(T);
    const primes = [_]u6{
        2,  3,  5,  7,  11, 13, 17, 19,
        23, 29, 31, 37, 41, 43, 47, 53,
    };
    // Find the first primorial that will overflow type T.
    // the size of the list is the primorial index minus one,
    // since the sieve doesn't include 2.
    //
    var i: usize = 0;
    var pi: T = 1;
    while (!@mulWithOverflow(T, pi, primes[i], &pi))
        i += 1;
    return i - 1;
}

fn sqrtType(comptime T: type) type {
    const t = assertInt(T);
    return meta.Int(.unsigned, t.bits / 2);
}

// stack type (actually just an array list)
fn arrayList(comptime Int: type) type {
    return [listSize(Int)]sqrtType(Int);
}

// given an upper bound, max, return the most restrictive sieving data type.
pub fn autoSieveType(comptime max: u64) type {
    if (max == 0)
        @compileError("The maximum sieving size must be non-zero.");
    var bit_len = 64 - @clz(u64, max);
    if (max & (max - 1) == 0) // power of two
        bit_len -= 1;
    if (bit_len % 2 == 1)
        bit_len += 1;
    if (bit_len < 4)
        bit_len = 4;
    return meta.Int(.unsigned, bit_len);
}

test "type meta functions" {
    const expect = std.testing.expect;
    try expect(sqrtType(u20) == u10);
    try expect(autoSieveType(8000) == u14);
    try expect(autoSieveType(9000) == u14);
    try expect(autoSieveType(16384) == u14);
    try expect(autoSieveType(16385) == u16);
    try expect(autoSieveType(32768) == u16);
    try expect(autoSieveType(1000) == u10);
    try expect(autoSieveType(10) == u4);
    try expect(autoSieveType(4) == u4);
    try expect(autoSieveType(std.math.maxInt(u32)) == u32);
    try expect(listSize(u64) == 14);
    try expect(listSize(u32) == 8);
    try expect(@sizeOf(arrayList(u32)) == 16);
    try expect(@sizeOf(arrayList(u36)) == 36);
    try expect(@sizeOf(arrayList(u64)) == 56);
}

pub fn PrimeGen(comptime Int: type) type {
    _ = assertInt(Int);
    return struct {
        const Self = @This();
        const Sieve = std.ArrayList(arrayList(Int));

        sieve: Sieve,
        count: usize,
        candidate: Int,
        rt: sqrtType(Int),
        sq: Int,
        pos: usize,

        // grow the sieve by a comptime fixed amount
        fn growBy(self: *Self, comptime n: usize) !void {
            var chunk: [n]arrayList(Int) = undefined;
            for (chunk) |*a|
                mem.set(sqrtType(Int), a, 0);
            try self.sieve.appendSlice(&chunk);
        }

        // add a known prime number to the sieve at postion k
        fn add(self: *Self, p: sqrtType(Int), k: usize) void {
            for (self.sieve.items[k]) |*x|
                if (x.* == 0) {
                    x.* = p;
                    return;
                };
            // each bucket is precalculated for the max size.
            // If we get here, there's been a mistake somewhere.
            unreachable;
        }

        pub fn init(alloc: *mem.Allocator) Self {
            return Self{
                .count = 0,
                .sieve = Sieve.init(alloc),
                .candidate = 3,
                .rt = 3,
                .sq = 9,
                .pos = 0,
            };
        }

        pub fn deinit(self: *Self) void {
            self.sieve.deinit();
        }

        pub fn next(self: *Self) !?Int {
            self.count += 1;
            if (self.count == 1) {
                try self.growBy(1); // prepare sieve
                return 2;
            } else {
                var is_prime = false;
                while (!is_prime) {
                    is_prime = true;
                    // Step 1: check the list at self.pos; if there are divisors then
                    // the candidate is not prime.  Move each divisor to its next multiple
                    // in the sieve.
                    //
                    if (self.sieve.items[self.pos][0] != 0) {
                        is_prime = false;
                        for (self.sieve.items[self.pos]) |*x| {
                            const p = x.*;
                            x.* = 0;
                            if (p == 0)
                                break;
                            self.add(p, (p + self.pos) % self.sieve.items.len);
                        }
                    }
                    // Step 2: If we've hit the next perfect square, and we thought the number
                    // was prime from step 1, note that it wasn't prime but rather was a non p-smooth
                    // number.  Add the square root to the sieve.  In any case, look ahead to the next
                    // square number.
                    //
                    if (self.candidate == self.sq) {
                        if (is_prime) {
                            is_prime = false;
                            self.add(self.rt, (self.pos + self.rt) % self.sieve.items.len);
                        }
                        // advance to the next root; if doing so would cause overflow then just ignore it,
                        // since we'll never see the next square.
                        //
                        var rt: sqrtType(Int) = undefined;
                        if (!@addWithOverflow(sqrtType(Int), self.rt, 2, &rt)) {
                            self.rt = rt;
                            self.sq = @as(Int, rt) * rt;
                        }
                    }
                    // advance the iterator; Note if we overflow, the candidate cannot be prime
                    // since the bit count must be even and all integers of the form 2^n - 1 with
                    // even n (except 2) are composite.
                    //
                    if (@addWithOverflow(Int, self.candidate, 2, &self.candidate)) {
                        std.debug.assert(!is_prime);
                        return null;
                    }
                    self.pos += 1;
                    if (self.pos == self.sieve.items.len) {
                        // expand the array by 2 to maintain the invariant: sieve.items.len > √candidate
                        try self.growBy(2);
                        self.pos = 0;
                    }
                }
                return self.candidate - 2;
            }
        }
    };
}
