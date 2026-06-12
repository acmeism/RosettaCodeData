//! includes the XOR version of the encryption scheme

const std = @import("std");
const print = std.debug.print;

const MSG: []const u8 = "a Top Secret secret";
const KEY: []const u8 = "this is my secret key";

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var isaac = Isaac.new();
    try isaac.seed(KEY, true);
    const encr = try isaac.vernam(allocator, MSG);
    defer allocator.free(encr);

    print("msg: {s}\n", .{MSG});
    print("key: {s}\n", .{KEY});
    print("XOR: ", .{});
    for (encr) |a| {
        print("{X:0>2}", .{a});
    }

    var isaac2 = Isaac.new();
    try isaac2.seed(KEY, true);
    const decr = try isaac2.vernam(allocator, encr);
    defer allocator.free(decr);

    print("\nXOR dcr: {s}\n", .{decr});
}

fn mixV(a: *[8]u32) void {
    a[0] ^= a[1] << 11; a[3] = a[3] +% a[0]; a[1] = a[1] +% a[2];
    a[1] ^= a[2] >> 2;  a[4] = a[4] +% a[1]; a[2] = a[2] +% a[3];
    a[2] ^= a[3] << 8;  a[5] = a[5] +% a[2]; a[3] = a[3] +% a[4];
    a[3] ^= a[4] >> 16; a[6] = a[6] +% a[3]; a[4] = a[4] +% a[5];
    a[4] ^= a[5] << 10; a[7] = a[7] +% a[4]; a[5] = a[5] +% a[6];
    a[5] ^= a[6] >> 4;  a[0] = a[0] +% a[5]; a[6] = a[6] +% a[7];
    a[6] ^= a[7] << 8;  a[1] = a[1] +% a[6]; a[7] = a[7] +% a[0];
    a[7] ^= a[0] >> 9;  a[2] = a[2] +% a[7]; a[0] = a[0] +% a[1];
}

const Isaac = struct {
    mm: [256]u32,
    aa: u32,
    bb: u32,
    cc: u32,
    rand_rsl: [256]u32,
    rand_cnt: u32,

    fn new() Isaac {
        return .{
            .mm = [_]u32{0} ** 256,
            .aa = 0,
            .bb = 0,
            .cc = 0,
            .rand_rsl = [_]u32{0} ** 256,
            .rand_cnt = 0,
        };
    }

    fn isaac(self: *Isaac) void {
        self.cc = self.cc +% 1;
        self.bb = self.bb +% self.cc;

        var i: usize = 0;
        while (i < 256) : (i += 1) {
            const x = self.mm[i];
            switch (i % 4) {
                0 => self.aa ^= self.aa << 13,
                1 => self.aa ^= self.aa >> 6,
                2 => self.aa ^= self.aa << 2,
                3 => self.aa ^= self.aa >> 16,
                else => unreachable,
            }

            self.aa = self.aa +% self.mm[((i + 128) % 256)];
            const y = self.mm[((x >> 2) % 256)] +% self.aa +% self.bb;
            self.mm[i] = y;
            self.bb = self.mm[((y >> 10) % 256)] +% x;
            self.rand_rsl[i] = self.bb;
        }

        self.rand_cnt = 0;
    }

    fn randInit(self: *Isaac, flag: bool) void {
        var a_v = [_]u32{0x9e3779b9} ** 8;

        var i: usize = 0;
        while (i < 4) : (i += 1) {
            // scramble it
            mixV(&a_v);
        }

        i = 0;
        while (i < 256) : (i += 8) {
            // fill in mm[] with messy stuff
            if (flag) {
                // use all the information in the seed
                var j: usize = 0;
                while (j < 8) : (j += 1) {
                    a_v[j] = a_v[j] +% self.rand_rsl[i + j];
                }
            }
            mixV(&a_v);
            var j: usize = 0;
            while (j < 8) : (j += 1) {
                self.mm[i + j] = a_v[j];
            }
        }

        if (flag) {
            // do a second pass to make all of the seed affect all of mm
            i = 0;
            while (i < 256) : (i += 8) {
                var j: usize = 0;
                while (j < 8) : (j += 1) {
                    a_v[j] = a_v[j] +% self.mm[i + j];
                }
                mixV(&a_v);
                j = 0;
                while (j < 8) : (j += 1) {
                    self.mm[i + j] = a_v[j];
                }
            }
        }

        self.isaac(); // fill in the first set of results
        self.rand_cnt = 0; // prepare to use the first set of results
    }

    /// Get a random 32-bit value
    fn iRandom(self: *Isaac) u32 {
        const r = self.rand_rsl[self.rand_cnt];
        self.rand_cnt += 1;
        if (self.rand_cnt > 255) {
            self.isaac();
            self.rand_cnt = 0;
        }
        return r;
    }

    /// Seed ISAAC with a string
    fn seed(self: *Isaac, seed_str: []const u8, flag: bool) !void {
        // Initialize arrays
        for (0..256) |i| {
            self.mm[i] = 0;
            self.rand_rsl[i] = 0;
        }

        // Copy seed data into rand_rsl
        for (seed_str, 0..) |b, i| {
            if (i >= 256) break;
            self.rand_rsl[i] = @as(u32, b);
        }

        // initialize ISAAC with seed
        self.randInit(flag);
    }

    /// Get a random character in printable ASCII range
    fn iRandAscii(self: *Isaac) u8 {
        return @as(u8, @truncate((self.iRandom() % 95) + 32));
    }

    /// XOR message
    fn vernam(self: *Isaac, allocator: std.mem.Allocator, msg: []const u8) ![]u8 {
        var result = try allocator.alloc(u8, msg.len);
        for (msg, 0..) |b, i| {
            result[i] = self.iRandAscii() ^ b;
        }
        return result;
    }
};
