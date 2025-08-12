const std = @import("std");

fn grayEncode(b: u32) u32 {
    return b ^ (b >> 1);
}

fn grayDecode(g: u32) u32 {
    var result = g;
    var bit: u32 = 1 << 31;
    while (bit > 1) {
        if (result & bit != 0) result ^= bit >> 1;
        bit >>= 1;
    }
    return result;
}

fn toBinary(value: u32, buffer: []u8) []const u8 {
    if (value == 0) return "0";

    var temp = value;
    var highest_bit: u5 = 0;
    // Find the highest bit set
    while (temp != 0) : (temp >>= 1) {
        highest_bit += 1;
    }

    // Fill buffer from right to left
    var i: usize = highest_bit;
    temp = value;
    while (i > 0) {
        i -= 1;
        buffer[i] = if (temp & 1 == 1) '1' else '0';
        temp >>= 1;
    }

    // Find first '1'
    for (buffer[0..highest_bit], 0..) |c, index| {
        if (c == '1') {
            return buffer[index..highest_bit];
        }
    }

    return "0"; // Fallback
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Number\tBinary\tGray\tDecoded\n", .{});

    // Pre-allocate a buffer big enough for 32-bit numbers
    var binary_buffer: [32]u8 = undefined;
    var gray_buffer: [32]u8 = undefined;

    for (0..32) |n| {
        const n_u32: u32 = @intCast(n);
        const g = grayEncode(n_u32);
        std.debug.assert(grayDecode(g) == n_u32);

        const binary = toBinary(n_u32, &binary_buffer);
        const grayBinary = toBinary(g, &gray_buffer);

        try stdout.print("{d}\t{s}\t{s}\t{d}\n", .{ n, binary, grayBinary, g });
    }
}
