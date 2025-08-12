const std = @import("std");

const REPLACEMENT_TABLE = [8][16]u8{
    [_]u8{ 4, 10, 9, 2, 13, 8, 0, 14, 6, 11, 1, 12, 7, 15, 5, 3 },
    [_]u8{ 14, 11, 4, 12, 6, 13, 15, 10, 2, 3, 8, 1, 0, 7, 5, 9 },
    [_]u8{ 5, 8, 1, 13, 10, 3, 4, 2, 14, 15, 12, 7, 6, 0, 9, 11 },
    [_]u8{ 7, 13, 10, 1, 0, 8, 9, 15, 14, 4, 6, 12, 11, 2, 5, 3 },
    [_]u8{ 6, 12, 7, 1, 5, 15, 13, 8, 4, 10, 9, 14, 0, 3, 11, 2 },
    [_]u8{ 4, 11, 10, 0, 7, 2, 1, 13, 3, 6, 8, 5, 9, 12, 15, 14 },
    [_]u8{ 13, 11, 4, 1, 3, 15, 5, 9, 0, 10, 14, 7, 6, 8, 2, 12 },
    [_]u8{ 1, 15, 13, 0, 5, 7, 10, 4, 9, 2, 3, 14, 6, 11, 8, 12 },
};

const KEYS = [8]u32{
    0xE2C1_04F9,
    0xE41D_7CDE,
    0x7FE5_E857,
    0x0602_65B4,
    0x281C_CC85,
    0x2E2C_929A,
    0x4746_4503,
    0xE00_CE510,
};

fn mainStep(text_block: []const u8, key_element: u32) ![8]u8 {
    var n: [8]u8 = undefined;
    @memcpy(&n, text_block[0..8]);

    var s: u32 = @as(u32, n[0]) << 24 | @as(u32, n[1]) << 16 | @as(u32, n[2]) << 8 | @as(u32, n[3]);
    s = s +% key_element;

    var new_s: u32 = 0;
    var mid: u32 = 0;
    while (mid < 4) : (mid += 1) {
        const cell = (s >> @as(u5, @as(u5, @intCast(mid)) << @as(u5, 3))) & 0xFF;
        new_s += (@as(u32, REPLACEMENT_TABLE[(mid * 2)][(cell & 0x0f)]) +
                 (@as(u32, REPLACEMENT_TABLE[(mid * 2 + 1)][(cell >> 4)]) << 4)) <<
                 @as(u5, @intCast(mid << 3) );
    }

    s = ((new_s << 11) +% (new_s >> 21)) ^
        (@as(u32, n[4]) << 24 | @as(u32, n[5]) << 16 | @as(u32, n[6]) << 8 | @as(u32, n[7]));

    n[4] = n[0];
    n[5] = n[1];
    n[6] = n[2];
    n[7] = n[3];
    n[0] = @intCast((s >> 24) & 0xFF);
    n[1] = @intCast((s >> 16) & 0xFF);
    n[2] = @intCast((s >> 8) & 0xFF);
    n[3] = @intCast(s & 0xFF);

    return n;
}

fn encode(allocator: std.mem.Allocator, text_block: []const u8) ![]u8 {
    const step = try allocator.dupe(u8, text_block);
    defer allocator.free(step);

    var result: [8]u8 = undefined;
    @memcpy(&result, step);

    var i: usize = 0;
    while (i < 24) : (i += 1) {
        result = try mainStep(&result, KEYS[i % 8]);
    }

    i = 8;
    while (i > 0) : (i -= 1) {
        result = try mainStep(&result, KEYS[i - 1]);
    }

    return try allocator.dupe(u8, &result);
}

fn decode(allocator: std.mem.Allocator, text_block: []const u8) ![]u8 {
    var step: [8]u8 = undefined;
    @memcpy(step[0..4], text_block[4..8]);
    @memcpy(step[4..8], text_block[0..4]);

    for (KEYS) |key| {
        step = try mainStep(&step, key);
    }

    var i: usize = 24;
    while (i > 0) : (i -= 1) {
        step = try mainStep(&step, KEYS[(i - 1) % 8]);
    }

    var ans: [8]u8 = undefined;
    @memcpy(ans[0..4], step[4..8]);
    @memcpy(ans[4..8], step[0..4]);

    return try allocator.dupe(u8, &ans);
}

fn bytesToHexString(allocator: std.mem.Allocator, bytes: []const u8) ![]u8 {
    var result = try allocator.alloc(u8, bytes.len * 3);
    var i: usize = 0;
    while (i < bytes.len) : (i += 1) {
        _ = try std.fmt.bufPrint(result[(i * 3)..][0..3], "{X:0>2} ", .{bytes[i]});
    }
    return result;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    const stdout = std.io.getStdOut().writer();

    if (args.len < 2) {
        const plain_text = [_]u8{ 0x04, 0x3B, 0x04, 0x21, 0x04, 0x32, 0x04, 0x30 };

        const hex_str = try bytesToHexString(allocator, &plain_text);
        defer allocator.free(hex_str);
        try stdout.print("Before one step: {s}\n\n", .{hex_str});

        const encoded_text = try mainStep(&plain_text, KEYS[0]);
        const encoded_hex = try bytesToHexString(allocator, &encoded_text);
        defer allocator.free(encoded_hex);
        try stdout.print("After one step : {s}\n\n", .{encoded_hex});
    } else {
        const text = args[1];
        const padding = (8 - text.len % 8) % 8;

        var t = try allocator.alloc(u8, text.len + padding);
        defer allocator.free(t);

        @memcpy(t[0..text.len], text);
        @memset(t[text.len..], ' ');

        const chunks_count = t.len / 8;
        var plain_text = std.ArrayList([]u8).init(allocator);
        defer {
            for (plain_text.items) |chunk| {
                allocator.free(chunk);
            }
            plain_text.deinit();
        }

        var i: usize = 0;
        try stdout.print("Plain text  : ", .{});
        while (i < chunks_count) : (i += 1) {
            const chunk = try allocator.dupe(u8, t[(i * 8)..][0..8]);
            try plain_text.append(chunk);

            const hex = try bytesToHexString(allocator, chunk);
            defer allocator.free(hex);
            try stdout.print("[{s}]", .{hex[0..23]});
        }
        try stdout.print("\n\n", .{});

        var encoded_text = std.ArrayList([]u8).init(allocator);
        defer {
            for (encoded_text.items) |chunk| {
                allocator.free(chunk);
            }
            encoded_text.deinit();
        }

        try stdout.print("Encoded text: ", .{});
        for (plain_text.items) |chunk| {
            const encoded = try encode(allocator, chunk);
            try encoded_text.append(encoded);

            const hex = try bytesToHexString(allocator, encoded);
            defer allocator.free(hex);
            try stdout.print("[{s}]", .{hex[0..23]});
        }
        try stdout.print("\n\n", .{});

        var decoded_text = std.ArrayList([]u8).init(allocator);
        defer {
            for (decoded_text.items) |chunk| {
                allocator.free(chunk);
            }
            decoded_text.deinit();
        }

        try stdout.print("Decoded text: ", .{});
        for (encoded_text.items) |chunk| {
            const decoded = try decode(allocator, chunk);
            try decoded_text.append(decoded);

            const hex = try bytesToHexString(allocator, decoded);
            defer allocator.free(hex);
            try stdout.print("[{s}]", .{hex[0..23]});
        }
        try stdout.print("\n\n", .{});

        var total_size: usize = 0;
        for (decoded_text.items) |chunk| {
            total_size += chunk.len;
        }

        var recovered_bytes = try allocator.alloc(u8, total_size);
        defer allocator.free(recovered_bytes);

        var offset: usize = 0;
        for (decoded_text.items) |chunk| {
            @memcpy(recovered_bytes[offset..][0..chunk.len], chunk);
            offset += chunk.len;
        }

        // Remove padding spaces at the end
        var end = recovered_bytes.len;
        while (end > 0 and recovered_bytes[end - 1] == ' ') {
            end -= 1;
        }

        try stdout.print("Recovered text: {s}\n\n", .{recovered_bytes[0..end]});
    }
}
