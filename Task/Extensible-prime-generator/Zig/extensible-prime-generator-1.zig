const std = @import("std");
const builtin = std.builtin;
const heap = std.heap;
const mem = std.mem;
const meta = std.meta;

fn assertInt(comptime T: type) builtin.TypeInfo.Int {
    if (@typeInfo(T) != .Int)
        @compileError("data type must be an integer.");
    const int = @typeInfo(T).Int;
    if (int.is_signed == true or int.bits % 2 == 1 or int.bits < 4)
        @compileError("type must be an unsigned integer with even bit size (of at least 4 bits).");
    return int;
}

fn sqrtType(comptime T: type) type {
    const t = assertInt(T);
    return meta.Int(.unsigned, t.bits / 2);
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
    expect(sqrtType(u20) == u10);
    expect(autoSieveType(8000) == u14);
    expect(autoSieveType(9000) == u14);
    expect(autoSieveType(16384) == u14);
    expect(autoSieveType(16385) == u16);
    expect(autoSieveType(32768) == u16);
    expect(autoSieveType(1000) == u10);
    expect(autoSieveType(10) == u4);
    expect(autoSieveType(4) == u4);
    expect(autoSieveType(std.math.maxInt(u32)) == u32);
}

const wheel2357 = [48]u8{
    10, 2, 4, 2, 4, 6, 2,  6,
    4,  2, 4, 6, 6, 2, 6,  4,
    2,  6, 4, 6, 8, 4, 2,  4,
    2,  4, 8, 6, 4, 6, 2,  4,
    6,  2, 6, 6, 4, 2, 4,  6,
    2,  6, 4, 2, 4, 2, 10, 2,
};

fn Wheel2357Multiple(comptime Int: type) type {
    _ = assertInt(Int);
    return struct {
        multiple: Int,
        base_prime: Int,
        offset: u6,

        fn less(self: Wheel2357Multiple(Int), other: Wheel2357Multiple(Int)) bool {
            return self.multiple < other.multiple;
        }
    };
}

pub fn PrimeGen(comptime Int: type) type {
    _ = assertInt(Int);
    return struct {
        const Self = @This();

        initial_primes: u16,
        offset: u6,
        candidate: Int,
        multiples: std.PriorityQueue(Wheel2357Multiple(Int)),
        allocator: *mem.Allocator,
        count: u32,

        pub fn init(alloc: *mem.Allocator) Self {
            return Self{
                .initial_primes = 0xAC, // primes 2, 3, 5, 7 in a bitmask
                .offset = 0,
                .candidate = 1,
                .count = 0,
                .allocator = alloc,
                .multiples = std.PriorityQueue(Wheel2357Multiple(Int)).init(alloc, Wheel2357Multiple(Int).less),
            };
        }

        pub fn deinit(self: *PrimeGen(Int)) void {
            self.multiples.deinit();
        }

        pub fn next(self: *PrimeGen(Int)) !?Int {
            if (self.initial_primes != 0) { // use the bitmask up first
                const p = @as(Int, @ctz(u16, self.initial_primes));
                self.initial_primes &= self.initial_primes - 1;
                self.count += 1;
                return p;
            } else {
                while (true) {
                    // advance to the next prime candidate.
                    if (@addWithOverflow(Int, self.candidate, wheel2357[self.offset], &self.candidate))
                        return null;
                    self.offset = (self.offset + 1) % @as(u6, wheel2357.len);

                    // See if the composite number on top of the heap matches
                    // the candidate.
                    //
                    var top = self.multiples.peek();
                    if (top == null or self.candidate < top.?.multiple) {
                        // prime found, add the square and it's position on the wheel
                        // to the heap.
                        //
                        if (self.candidate <= std.math.maxInt(sqrtType(Int)))
                            try self.multiples.add(Wheel2357Multiple(Int){
                                .multiple = self.candidate * self.candidate,
                                .base_prime = self.candidate,
                                .offset = self.offset,
                            });
                        self.count += 1;
                        return self.candidate;
                    } else {
                        while (true) {
                            // advance the top of heap to the next prime multiple
                            // that is not a multiple of 2, 3, 5, 7.
                            //
                            var mult = self.multiples.remove();
                            // If the multiple becomes too big (greater than the the maximum
                            // sieve size), then there's no reason to add it back to the queue.
                            //
                            var tmp: Int = undefined;
                            if (!@mulWithOverflow(Int, mult.base_prime, wheel2357[mult.offset], &tmp) and
                                !@addWithOverflow(Int, tmp, mult.multiple, &mult.multiple))
                            {
                                mult.offset = (mult.offset + 1) % @as(u6, wheel2357.len);
                                try self.multiples.add(mult);
                            }
                            top = self.multiples.peek();
                            if (top == null or self.candidate != top.?.multiple)
                                break;
                        }
                    }
                }
            }
        }
    };
}
