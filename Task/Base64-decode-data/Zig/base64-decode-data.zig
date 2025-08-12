const std = @import("std");
const print = std.debug.print;
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

const INPUT = "VG8gZXJyIGlzIGh1bWFuLCBidXQgdG8gcmVhbGx5IGZvdWwgdGhpbmdzIHVwIHlvdSBuZWVkIGEgY29tcHV0ZXIuCiAgICAtLVBhdWwgUi5FaHJsaWNo";
const UPPERCASE_OFFSET: i8 = -65;
const LOWERCASE_OFFSET: i8 = 26 - 97;
const NUM_OFFSET: i8 = 52 - 48;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    print("Input: {s}\n", .{INPUT});

    // Create a dynamic array to collect binary strings
    var binary_strings = ArrayList([]const u8).init(allocator);
    defer {
        for (binary_strings.items) |item| {
            allocator.free(item);
        }
        binary_strings.deinit();
    }

    // Process each character and convert to binary
    for (INPUT) |ch| {
        if (ch == '=') continue; // Filter '=' chars

        // Map char values using Base64 Characters Table
        const ascii: i8 = @intCast(ch);
        const convert: u8 = switch (ch) {
            '0'...'9' => @intCast(ascii + NUM_OFFSET),
            'a'...'z' => @intCast(ascii + LOWERCASE_OFFSET),
            'A'...'Z' => @intCast(ascii + UPPERCASE_OFFSET),
            '+' => 62,
            '/' => 63,
            else => {
                print("Not a valid base64 encoded string\n", .{});
                return;
            },
        };

        // Convert to binary format (6 bits for base64)
        const binary_str = try std.fmt.allocPrint(allocator, "{b:0>6}", .{convert});
        try binary_strings.append(binary_str);
    }

    // Concatenate all binary strings
    var total_len: usize = 0;
    for (binary_strings.items) |item| {
        total_len += item.len;
    }

    const concatenated = try allocator.alloc(u8, total_len);
    defer allocator.free(concatenated);

    var pos: usize = 0;
    for (binary_strings.items) |item| {
        @memcpy(concatenated[pos..pos + item.len], item);
        pos += item.len;
    }

    // Split into 8-character chunks and convert to bytes
    var result_bytes = ArrayList(u8).init(allocator);
    defer result_bytes.deinit();

    var i: usize = 0;
    while (i + 8 <= concatenated.len) : (i += 8) {
        const chunk = concatenated[i..i + 8];
        const byte_value = std.fmt.parseInt(u8, chunk, 2) catch |err| {
            print("Error parsing binary: {}\n", .{err});
            return;
        };
        try result_bytes.append(byte_value);
    }

    // Convert to UTF-8 string and print
    const result_str = result_bytes.items;
    if (std.unicode.utf8ValidateSlice(result_str)) {
        print("Output: {s}\n", .{result_str});
    } else {
        print("Invalid UTF-8 sequence\n", .{});
    }
}
