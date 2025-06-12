const std = @import("std");

const SHA1 = struct {
    const BLOCK_LENGTH: u32 = 64;

    fn messageDigest(message: []const u8) ![40]u8 {
        var state = [5]u32{ 0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476, 0xc3d2e1f0 };

        const bytes = try addPadding(message);
        var i: usize = 0;
        while (i < bytes.len / BLOCK_LENGTH) : (i += 1) {
            var values = [_]u32{0} ** 80;

            var j: u32 = 0;
            while (j < BLOCK_LENGTH) : (j += 1) {
                values[j / 4] |= @as(u32, @intCast(bytes[i * BLOCK_LENGTH + j] & 0xff)) << @intCast((3 - j % 4) * 8);
            }

            j = 16;
            while (j < 80) : (j += 1) {
                const value = values[j - 3] ^ values[j - 8] ^ values[j - 14] ^ values[j - 16];
                values[j] = std.math.rotl(u32, value, 1);
            }

            var a = state[0];
            var b = state[1];
            var c = state[2];
            var d = state[3];
            var e = state[4];
            var f: u32 = 0;
            var k: u32 = 0;

            j = 0;
            while (j < 80) : (j += 1) {
                switch (j / 20) {
                    0 => {
                        f = (b & c) | (~b & d);
                        k = 0x5a827999;
                    },
                    1 => {
                        f = b ^ c ^ d;
                        k = 0x6ed9eba1;
                    },
                    2 => {
                        f = (b & c) | (b & d) | (c & d);
                        k = 0x8f1bbcdc;
                    },
                    3 => {
                        f = b ^ c ^ d;
                        k = 0xca62c1d6;
                    },
                    else => unreachable,
                }

                // Use wrapping add to prevent integer overflow panics
                const rotated_a = std.math.rotl(u32, a, 5);
                const temp = @addWithOverflow(rotated_a, f)[0];
                const temp2 = @addWithOverflow(temp, e)[0];
                const temp3 = @addWithOverflow(temp2, k)[0];
                const temp4 = @addWithOverflow(temp3, values[j])[0];

                e = d;
                d = c;
                c = std.math.rotl(u32, b, 30);
                b = a;
                a = temp4;
            }

            // Use wrapping adds for state updates
            state[0] = @addWithOverflow(state[0], a)[0];
            state[1] = @addWithOverflow(state[1], b)[0];
            state[2] = @addWithOverflow(state[2], c)[0];
            state[3] = @addWithOverflow(state[3], d)[0];
            state[4] = @addWithOverflow(state[4], e)[0];
        }

        var result: [40]u8 = undefined;
        var buffer: [8]u8 = undefined;

        for (0..20) |my_i| {
            const byte_value: u8 = @intCast((state[my_i / 4] >> @intCast(24 - (my_i % 4) * 8)) & 0xff);
            _ = try std.fmt.bufPrint(buffer[0..2], "{x:0>2}", .{byte_value});
            result[my_i * 2] = buffer[0];
            result[my_i * 2 + 1] = buffer[1];
        }

        return result;
    }

    fn addPadding(message: []const u8) ![]u8 {
        const allocator = std.heap.page_allocator;

        // Initialize with the message
        var bytes = std.ArrayList(u8).init(allocator);
        defer bytes.deinit();

        try bytes.appendSlice(message);
        try bytes.append(0x80);

        var padding: u32 = BLOCK_LENGTH - @as(u32, @intCast(bytes.items.len % BLOCK_LENGTH));
        if (padding < 8) {
            padding += BLOCK_LENGTH;
        }

        var i: u32 = 0;
        while (i < padding - 8) : (i += 1) {
            try bytes.append(0x0);
        }

        const bit_length: u64 = 8 * message.len;
        i = 0;
        while (i < 8) : (i += 1) {
            const shift_amount: u6 = @intCast(8 * (7 - i)); // Explicit cast to u6 for shift
            try bytes.append(@intCast((bit_length >> shift_amount) & 0xff));
        }

        return bytes.toOwnedSlice();
    }
};

pub fn main() !void {
    const message = "Rosetta Code";
    const result = try SHA1.messageDigest(message);
    const stdout = std.io.getStdOut().writer();
    try stdout.print("{s}\n", .{result});
}
