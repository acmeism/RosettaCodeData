const std = @import("std");
const Sha256 = std.crypto.hash.sha2.Sha256;

pub fn isValid(string: []const u8) bool {
    const chars = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz";

    var val: u256 = 0;

    for (string) |char| {
        const index = std.mem.indexOf(u8, chars, &[1]u8{char});
        if (index == null) {
            return false;
        }
        val = val * 58 + index.?;
    }

    var bytes: [25]u8 = undefined;

    var i: i8 = 24;
    var actualI: usize = 0;

    while (i >= 0) : (i -= 1) {
        const castI: u8 = @intCast(i);
        bytes[actualI] = @intCast((val >> castI * 8) & 0xFF);
        actualI += 1;
    }

    var hash: [Sha256.digest_length]u8 = undefined;
    const first21 = bytes[0..21];

    Sha256.hash(first21, &hash, .{});

    var hash2: [Sha256.digest_length]u8 = undefined;
    Sha256.hash(&hash, &hash2, .{});

    const firstFourHash = hash2[0..4];
    const lastFour = bytes[21..25];

    return std.mem.eql(u8, firstFourHash, lastFour);
}

pub fn main() !void {
    std.debug.print("{}\n", .{isValid("1AGNa15ZQXAZUgFiqJ3i7Z2DPU2J6hW62i")});
    std.debug.print("{}\n", .{isValid("17NdbrSGoUotzeGCcMMCqnFkEvLymoou9j")});
}
