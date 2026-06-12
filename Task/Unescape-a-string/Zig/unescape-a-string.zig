const std = @import("std");
const print = std.debug.print;
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

const UnescapeError = error{
    InvalidEscape,
    InvalidUnicodeEscape,
    UnexpectedLowSurrogate,
    IncompleteEscapeSequence,
    UnexpectedCodePoint,
    InvalidCharacter,
    InvalidCodePoint,
    OutOfMemory,
};

fn parseHexDigits(digits: []const u8) UnescapeError!u32 {
    var code_point: u32 = 0;

    for (digits) |digit| {
        code_point <<= 4;
        switch (digit) {
            '0'...'9' => code_point |= @as(u32, digit - '0'),
            'a'...'f' => code_point |= @as(u32, digit - 'a' + 10),
            'A'...'F' => code_point |= @as(u32, digit - 'A' + 10),
            else => return UnescapeError.InvalidUnicodeEscape,
        }
    }

    return code_point;
}

fn isHighSurrogate(code_point: u32) bool {
    return code_point >= 0xD800 and code_point <= 0xDBFF;
}

fn isLowSurrogate(code_point: u32) bool {
    return code_point >= 0xDC00 and code_point <= 0xDFFF;
}

fn encodeUtf8(allocator: Allocator, code_point: u32) UnescapeError![]u8 {
    var buf: [4]u8 = undefined;
    const len = std.unicode.utf8Encode(@as(u21, @intCast(code_point)), &buf) catch {
        return UnescapeError.InvalidCodePoint;
    };

    const result = allocator.dupe(u8, buf[0..len]) catch {
        return UnescapeError.OutOfMemory;
    };

    return result;
}

fn unescapeJsonString(allocator: Allocator, input: []const u8) UnescapeError![]u8 {
    var result = ArrayList(u8).init(allocator);
    defer result.deinit();

    var index: usize = 0;
    const length = input.len;

    while (index < length) {
        const byte = input[index];
        index += 1;

        if (byte == '\\') {
            if (index >= length) {
                return UnescapeError.InvalidEscape;
            }

            const escape_char = input[index];
            index += 1;

            switch (escape_char) {
                '"' => try result.append('"'),
                '\\' => try result.append('\\'),
                '/' => try result.append('/'),
                'b' => try result.append('\u{0008}'), // backspace
                'f' => try result.append('\u{000C}'), // form feed
                'n' => try result.append('\n'),
                'r' => try result.append('\r'),
                't' => try result.append('\t'),
                'u' => {
                    // Decode 4 hex digits
                    if (index + 4 > length) {
                        return UnescapeError.InvalidUnicodeEscape;
                    }

                    const hex_str = input[index..index + 4];
                    const code_point = parseHexDigits(hex_str) catch {
                        return UnescapeError.InvalidUnicodeEscape;
                    };
                    index += 4;

                    if (isLowSurrogate(code_point)) {
                        return UnescapeError.UnexpectedLowSurrogate;
                    }

                    const final_code_point = if (isHighSurrogate(code_point)) blk: {
                        // Check for low surrogate pair
                        if (index + 6 > length or input[index] != '\\' or input[index + 1] != 'u') {
                            return UnescapeError.IncompleteEscapeSequence;
                        }

                        const low_hex_str = input[index + 2..index + 6];
                        const low_surrogate = parseHexDigits(low_hex_str) catch {
                            return UnescapeError.InvalidUnicodeEscape;
                        };
                        index += 6;

                        if (!isLowSurrogate(low_surrogate)) {
                            return UnescapeError.UnexpectedCodePoint;
                        }

                        // Combine high and low surrogates into a Unicode code point
                        break :blk 0x10000 + (((code_point & 0x03FF) << 10) | (low_surrogate & 0x03FF));
                    } else code_point;

                    const utf8_bytes = encodeUtf8(allocator, final_code_point) catch |err| {
                        return err;
                    };
                    defer allocator.free(utf8_bytes);
                    try result.appendSlice(utf8_bytes);
                },
                else => return UnescapeError.InvalidEscape,
            }
        } else {
            // Handle UTF-8 sequences and validate control characters
            if ((byte & 0x80) == 0) {
                // Single-byte code point (ASCII)
                if (byte <= 0x1F) {
                    return UnescapeError.InvalidCharacter;
                }
                try result.append(byte);
            } else if ((byte & 0xE0) == 0xC0) {
                // Two-byte UTF-8 sequence
                if (index + 1 > length) {
                    return UnescapeError.InvalidCodePoint;
                }

                const utf8_bytes = input[index - 1..index + 1];
                if (!std.unicode.utf8ValidateSlice(utf8_bytes)) {
                    return UnescapeError.InvalidCodePoint;
                }
                try result.appendSlice(utf8_bytes);
                index += 1;
            } else if ((byte & 0xF0) == 0xE0) {
                // Three-byte UTF-8 sequence
                if (index + 2 > length) {
                    return UnescapeError.InvalidCodePoint;
                }

                const utf8_bytes = input[index - 1..index + 2];
                if (!std.unicode.utf8ValidateSlice(utf8_bytes)) {
                    return UnescapeError.InvalidCodePoint;
                }
                try result.appendSlice(utf8_bytes);
                index += 2;
            } else if ((byte & 0xF8) == 0xF0) {
                // Four-byte UTF-8 sequence
                if (index + 3 > length) {
                    return UnescapeError.InvalidCodePoint;
                }

                const utf8_bytes = input[index - 1..index + 3];
                if (!std.unicode.utf8ValidateSlice(utf8_bytes)) {
                    return UnescapeError.InvalidCodePoint;
                }
                try result.appendSlice(utf8_bytes);
                index += 3;
            } else {
                return UnescapeError.InvalidCharacter;
            }
        }
    }

    return result.toOwnedSlice();
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const test_cases = [_][]const u8{
        "abc",
        "a☺c",
        "a\\\"c",
        "\\u0061\\u0062\\u0063",
        "a\\\\c",
        "a\\u263Ac",
        "a\\\\u263Ac",
        "a\\uD834\\uDD1Ec",
        "a\\ud834\\udd1ec",
        "a\\u263",
        "a\\u263Xc",
        "a\\uDD1Ec",
        "a\\uD834c",
        "a\\uD834\\u263Ac",
    };

    for (test_cases) |test_case| {
        if (unescapeJsonString(allocator, test_case)) |unescaped| {
            defer allocator.free(unescaped);
            print("{s} -> {s}\n", .{ test_case, unescaped });
        } else |err| {
            print("{s} -> {}\n", .{ test_case, err });
        }
    }
}
