const std = @import("std");
const mem = std.mem;
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

// Only covers ISO-8859-1 accented characters plus, for consistency, Ÿ
const UC_ACCENTS = [_][]const u8{ "ÀÁÂÃÄÅ", "Ç", "ÈÉÊË", "ÌÍÎÏ", "Ñ", "ÒÓÔÕÖØ", "ÙÚÛÜ", "ÝŸ" };
const LC_ACCENTS = [_][]const u8{ "àáâãäå", "ç", "èéêë", "ìíîï", "ñ", "òóôõöø", "ùúûü", "ýÿ" };
const UC_UNACCENTS = [_][]const u8{ "A", "C", "E", "I", "N", "O", "U", "Y" };
const LC_UNACCENTS = [_][]const u8{ "a", "c", "e", "i", "n", "o", "u", "y" };

// Only the more common ligatures
const UC_LIGATURES = [_][]const u8{ "Æ", "Ĳ", "Œ" };
const LC_LIGATURES = [_][]const u8{ "æ", "ĳ", "œ" };
const UC_SEPARATES = [_][]const u8{ "AE", "IJ", "OE" };
const LC_SEPARATES = [_][]const u8{ "ae", "ij", "oe" };

// Miscellaneous replacements
const MISC_LETTERS = [_][]const u8{ "ß", "ſ", "ʒ" };
const MISC_REPLACEMENTS = [_][]const u8{ "ss", "s", "s" };

// Remove leading spaces
fn leftTrim(allocator: Allocator, text: []const u8) ![]u8 {
    var i: usize = 0;
    while (i < text.len and text[i] == ' ') : (i += 1) {}
    return allocator.dupe(u8, text[i..]);
}

// Replace multiple spaces with a single space
fn replaceSpaces(allocator: Allocator, text: []const u8) ![]u8 {
    var result = ArrayList(u8).init(allocator);
    defer result.deinit();

    var i: usize = 0;
    var inSpaces = false;
    while (i < text.len) : (i += 1) {
        if (text[i] == ' ') {
            if (!inSpaces) {
                try result.append(' ');
                inSpaces = true;
            }
        } else {
            try result.append(text[i]);
            inSpaces = false;
        }
    }

    return result.toOwnedSlice();
}

// Replace whitespace with a single space
fn replaceWhitespace(allocator: Allocator, text: []const u8) ![]u8 {
    var result = ArrayList(u8).init(allocator);
    defer result.deinit();

    var i: usize = 0;
    var inWhitespace = false;
    while (i < text.len) : (i += 1) {
        if (std.ascii.isWhitespace(text[i])) {
            if (!inWhitespace) {
                try result.append(' ');
                inWhitespace = true;
            }
        } else {
            try result.append(text[i]);
            inWhitespace = false;
        }
    }

    return result.toOwnedSlice();
}

// Display strings including whitespace as if the latter were literal characters
fn toDisplayString(allocator: Allocator, text: []const u8) ![]u8 {
    const whitespace_1 = [_][]const u8{ "\t", "\n", "\x0B", "\x0C", "\r" };
    const whitespace_2 = [_][]const u8{ "\\t", "\\n", "\\u000b", "\\u000c", "\\r" };

    var result = ArrayList(u8).init(allocator);
    defer result.deinit();

    var i: usize = 0;
    while (i < text.len) : (i += 1) {
        var replaced = false;
        for (whitespace_1, 0..) |ws, j| {
            if (i + ws.len <= text.len and mem.eql(u8, text[i..i+ws.len], ws)) {
                try result.appendSlice(whitespace_2[j]);
                i += ws.len - 1;
                replaced = true;
                break;
            }
        }

        if (!replaced) {
            try result.append(text[i]);
        }
    }

    return result.toOwnedSlice();
}

// Transform the string into lower case
fn toLowerCase(allocator: Allocator, text: []const u8) ![]u8 {
    var result = try allocator.alloc(u8, text.len);
    errdefer allocator.free(result);

    for (text, 0..) |c, i| {
        result[i] = std.ascii.toLower(c);
    }

    return result;
}

// Pad each numeric character with leading zeros to a total length of 20
fn zeroPadding(allocator: Allocator, text: []const u8) ![]u8 {
    var result = ArrayList(u8).init(allocator);
    defer result.deinit();

    var i: usize = 0;
    while (i < text.len) {
        if (std.ascii.isDigit(text[i]) or (text[i] == '-' and i + 1 < text.len and std.ascii.isDigit(text[i+1]))) {
            const start = i;
            if (text[i] == '-') {
                i += 1;
            }
            while (i < text.len and std.ascii.isDigit(text[i])) : (i += 1) {}

            const numStr = text[start..i];
            const padding = if (numStr.len < 20) 20 - numStr.len else 0;

            for (0..padding) |_| {
                try result.append('0');
            }
            try result.appendSlice(numStr);
        } else {
            try result.append(text[i]);
            i += 1;
        }
    }

    return result.toOwnedSlice();
}

fn removeTitle(allocator: Allocator, text: []const u8) ![]u8 {
    if (text.len >= 4 and mem.eql(u8, text[0..4], "The ")) {
        return allocator.dupe(u8, text[4..]);
    } else if (text.len >= 3 and mem.eql(u8, text[0..3], "An ")) {
        return allocator.dupe(u8, text[3..]);
    } else if (text.len >= 2 and mem.eql(u8, text[0..2], "A ")) {
        return allocator.dupe(u8, text[2..]);
    } else {
        return allocator.dupe(u8, text);
    }
}

// Replace accented letters with their unaccented equivalent
fn replaceAccents(allocator: Allocator, text: []const u8) ![]u8 {
    var result = ArrayList(u8).init(allocator);
    defer result.deinit();

    var i: usize = 0;
    while (i < text.len) {
        // Handle UTF-8 characters
        var char: [4]u8 = undefined;
        var char_len: usize = 0;

        if ((text[i] & 0x80) == 0) {
            // ASCII character
            try result.append(text[i]);
            i += 1;
            continue;
        }

        // Extract UTF-8 character
        if ((text[i] & 0xE0) == 0xC0) {
            char_len = 2;
        } else if ((text[i] & 0xF0) == 0xE0) {
            char_len = 3;
        } else if ((text[i] & 0xF8) == 0xF0) {
            char_len = 4;
        } else {
            // Invalid UTF-8, just copy
            try result.append(text[i]);
            i += 1;
            continue;
        }

        if (i + char_len > text.len) {
            // Incomplete UTF-8 sequence
            try result.append(text[i]);
            i += 1;
            continue;
        }

        @memcpy(char[0..char_len], text[i..i+char_len]);

        var replaced = false;
        const charSlice = char[0..char_len];

        for (UC_ACCENTS, 0..) |accents, j| {
            if (containsUtf8Char(accents, charSlice)) {
                try result.appendSlice(UC_UNACCENTS[j]);
                replaced = true;
                break;
            }
        }

        if (!replaced) {
            for (LC_ACCENTS, 0..) |accents, j| {
                if (containsUtf8Char(accents, charSlice)) {
                    try result.appendSlice(LC_UNACCENTS[j]);
                    replaced = true;
                    break;
                }
            }
        }

        if (!replaced) {
            try result.appendSlice(charSlice);
        }

        i += char_len;
    }

    return result.toOwnedSlice();
}

// Helper function to check if a UTF-8 string contains a character
fn containsUtf8Char(haystack: []const u8, needle: []const u8) bool {
    var i: usize = 0;
    while (i < haystack.len) {
        const char_len = utf8CharLen(haystack[i]);
        if (i + char_len <= haystack.len and mem.eql(u8, haystack[i..i+char_len], needle)) {
            return true;
        }
        i += char_len;
    }
    return false;
}

// Helper function to get UTF-8 character length
fn utf8CharLen(first_byte: u8) usize {
    if ((first_byte & 0x80) == 0) return 1;
    if ((first_byte & 0xE0) == 0xC0) return 2;
    if ((first_byte & 0xF0) == 0xE0) return 3;
    if ((first_byte & 0xF8) == 0xF0) return 4;
    return 1; // invalid UTF-8, treat as single byte
}

// Replace ligatures with separated letters
fn replaceLigatures(allocator: Allocator, text: []const u8) ![]u8 {
    var result = ArrayList(u8).init(allocator);
    defer result.deinit();
    try result.appendSlice(text);

    for (UC_LIGATURES, 0..) |ligature, i| {
        var newResult = ArrayList(u8).init(allocator);
        defer newResult.deinit();

        var j: usize = 0;
        while (j < result.items.len) {
            const char_len = utf8CharLen(result.items[j]);
            if (j + char_len <= result.items.len and isUtf8Char(result.items[j..j+char_len], ligature)) {
                try newResult.appendSlice(UC_SEPARATES[i]);
                j += char_len;
            } else {
                try newResult.append(result.items[j]);
                j += 1;
            }
        }

        result.clearAndFree();
        try result.appendSlice(newResult.items);
    }

    for (LC_LIGATURES, 0..) |ligature, i| {
        var newResult = ArrayList(u8).init(allocator);
        defer newResult.deinit();

        var j: usize = 0;
        while (j < result.items.len) {
            const char_len = utf8CharLen(result.items[j]);
            if (j + char_len <= result.items.len and isUtf8Char(result.items[j..j+char_len], ligature)) {
                try newResult.appendSlice(LC_SEPARATES[i]);
                j += char_len;
            } else {
                try newResult.append(result.items[j]);
                j += 1;
            }
        }

        result.clearAndFree();
        try result.appendSlice(newResult.items);
    }

    return result.toOwnedSlice();
}

// Helper function to compare UTF-8 characters
fn isUtf8Char(a: []const u8, b: []const u8) bool {
    return mem.eql(u8, a, b);
}

// Replace miscellaneous letters with their equivalent replacements
fn replaceCharacters(allocator: Allocator, text: []const u8) ![]u8 {
    var result = ArrayList(u8).init(allocator);
    defer result.deinit();
    try result.appendSlice(text);

    for (MISC_LETTERS, 0..) |letter, i| {
        var newResult = ArrayList(u8).init(allocator);
        defer newResult.deinit();

        var j: usize = 0;
        while (j < result.items.len) {
            const char_len = utf8CharLen(result.items[j]);
            if (j + char_len <= result.items.len and isUtf8Char(result.items[j..j+char_len], letter)) {
                try newResult.appendSlice(MISC_REPLACEMENTS[i]);
                j += char_len;
            } else {
                try newResult.append(result.items[j]);
                j += 1;
            }
        }

        result.clearAndFree();
        try result.appendSlice(newResult.items);
    }

    return result.toOwnedSlice();
}

// Custom context for sort comparators
const SortContext = struct {
    allocator: Allocator,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const stdout = std.io.getStdOut().writer();
    try stdout.print("The 9 string lists, sorted 'naturally':\n", .{});

    var s1 = ArrayList([]const u8).init(allocator);
    defer s1.deinit();
    try s1.append("ignore leading spaces: 2-2");
    try s1.append(" ignore leading spaces: 2-1");
    try s1.append("  ignore leading spaces: 2+0");
    try s1.append("   ignore leading spaces: 2+1");

    try stdout.print("\n", .{});

    // Sort using leftTrim
    const ctx1 = SortContext{ .allocator = allocator };
    std.sort.insertion([]const u8, s1.items, ctx1, struct {
        fn lessThan(ctx: SortContext, lhs: []const u8, rhs: []const u8) bool {
            const l = leftTrim(ctx.allocator, lhs) catch return false;
            defer ctx.allocator.free(l);
            const r = leftTrim(ctx.allocator, rhs) catch return false;
            defer ctx.allocator.free(r);
            return mem.lessThan(u8, l, r);
        }
    }.lessThan);

    for (s1.items) |s| {
        try stdout.print("{s}\n", .{s});
    }

    var s2 = ArrayList([]const u8).init(allocator);
    defer s2.deinit();
    try s2.append("ignore m.a.s spaces: 2-2");
    try s2.append("ignore m.a.s  spaces: 2-1");
    try s2.append("ignore m.a.s   spaces: 2+0");
    try s2.append("ignore m.a.s    spaces: 2+1");

    try stdout.print("\n", .{});

    // Sort using replaceSpaces
    const ctx2 = SortContext{ .allocator = allocator };
    std.sort.insertion([]const u8, s2.items, ctx2, struct {
        fn lessThan(ctx: SortContext, lhs: []const u8, rhs: []const u8) bool {
            const l = replaceSpaces(ctx.allocator, lhs) catch return false;
            defer ctx.allocator.free(l);
            const r = replaceSpaces(ctx.allocator, rhs) catch return false;
            defer ctx.allocator.free(r);
            return mem.lessThan(u8, l, r);
        }
    }.lessThan);

    for (s2.items) |s| {
        try stdout.print("{s}\n", .{s});
    }

    var s3 = ArrayList([]const u8).init(allocator);
    defer s3.deinit();
    try s3.append("Equiv. spaces: 3-3");
    try s3.append("Equiv.\rspaces: 3-2");
    try s3.append("Equiv.\x0Cspaces: 3-1");
    try s3.append("Equiv.\x0Bspaces: 3+0");
    try s3.append("Equiv.\nspaces: 3+1");
    try s3.append("Equiv.\tspaces: 3+2");

    try stdout.print("\n", .{});

    // Sort using replaceWhitespace
    const ctx3 = SortContext{ .allocator = allocator };
    std.sort.insertion([]const u8, s3.items, ctx3, struct {
        fn lessThan(ctx: SortContext, lhs: []const u8, rhs: []const u8) bool {
            const l = replaceWhitespace(ctx.allocator, lhs) catch return false;
            defer ctx.allocator.free(l);
            const r = replaceWhitespace(ctx.allocator, rhs) catch return false;
            defer ctx.allocator.free(r);
            return mem.lessThan(u8, l, r);
        }
    }.lessThan);

    for (s3.items) |s| {
        const displayStr = try toDisplayString(allocator, s);
        defer allocator.free(displayStr);
        try stdout.print("{s}\n", .{displayStr});
    }

    var s4 = ArrayList([]const u8).init(allocator);
    defer s4.deinit();
    try s4.append("cASE INDEPENENT: 3-2");
    try s4.append("caSE INDEPENENT: 3-1");
    try s4.append("casE INDEPENENT: 3+0");
    try s4.append("case INDEPENENT: 3+1");

    try stdout.print("\n", .{});

    // Sort using toLowerCase
    const ctx4 = SortContext{ .allocator = allocator };
    std.sort.insertion([]const u8, s4.items, ctx4, struct {
        fn lessThan(ctx: SortContext, lhs: []const u8, rhs: []const u8) bool {
            const l = toLowerCase(ctx.allocator, lhs) catch return false;
            defer ctx.allocator.free(l);
            const r = toLowerCase(ctx.allocator, rhs) catch return false;
            defer ctx.allocator.free(r);
            return mem.lessThan(u8, l, r);
        }
    }.lessThan);

    for (s4.items) |s| {
        try stdout.print("{s}\n", .{s});
    }

    var s5 = ArrayList([]const u8).init(allocator);
    defer s5.deinit();
    try s5.append("foo100bar99baz0.txt");
    try s5.append("foo100bar10baz0.txt");
    try s5.append("foo1000bar99baz10.txt");
    try s5.append("foo1000bar99baz9.txt");

    try stdout.print("\n", .{});

    // Sort using zeroPadding
    const ctx5 = SortContext{ .allocator = allocator };
    std.sort.insertion([]const u8, s5.items, ctx5, struct {
        fn lessThan(ctx: SortContext, lhs: []const u8, rhs: []const u8) bool {
            const l = zeroPadding(ctx.allocator, lhs) catch return false;
            defer ctx.allocator.free(l);
            const r = zeroPadding(ctx.allocator, rhs) catch return false;
            defer ctx.allocator.free(r);
            return mem.lessThan(u8, l, r);
        }
    }.lessThan);

    for (s5.items) |s| {
        try stdout.print("{s}\n", .{s});
    }

    var s6 = ArrayList([]const u8).init(allocator);
    defer s6.deinit();
    try s6.append("The Wind in the Willows");
    try s6.append("The 40th step more");
    try s6.append("The 39 steps");
    try s6.append("Wanda");

    try stdout.print("\n", .{});

    // Sort using removeTitle
    const ctx6 = SortContext{ .allocator = allocator };
    std.sort.insertion([]const u8, s6.items, ctx6, struct {
        fn lessThan(ctx: SortContext, lhs: []const u8, rhs: []const u8) bool {
            const l = removeTitle(ctx.allocator, lhs) catch return false;
            defer ctx.allocator.free(l);
            const r = removeTitle(ctx.allocator, rhs) catch return false;
            defer ctx.allocator.free(r);
            return mem.lessThan(u8, l, r);
        }
    }.lessThan);

    for (s6.items) |s| {
        try stdout.print("{s}\n", .{s});
    }

    var s7 = ArrayList([]const u8).init(allocator);
    defer s7.deinit();
    try s7.append("Equiv. ý accents: 2-2");
    try s7.append("Equiv. Ý accents: 2-1");
    try s7.append("Equiv. y accents: 2+0");
    try s7.append("Equiv. Y accents: 2+1");

    try stdout.print("\n", .{});

    // Sort using replaceAccents
    const ctx7 = SortContext{ .allocator = allocator };
    std.sort.insertion([]const u8, s7.items, ctx7, struct {
        fn lessThan(ctx: SortContext, lhs: []const u8, rhs: []const u8) bool {
            const l = replaceAccents(ctx.allocator, lhs) catch return false;
            defer ctx.allocator.free(l);
            const r = replaceAccents(ctx.allocator, rhs) catch return false;
            defer ctx.allocator.free(r);
            return mem.lessThan(u8, l, r);
        }
    }.lessThan);

    for (s7.items) |s| {
        try stdout.print("{s}\n", .{s});
    }

    var s8 = ArrayList([]const u8).init(allocator);
    defer s8.deinit();
    try s8.append("Ĳ ligatured ij");
    try s8.append("no ligature");

    try stdout.print("\n", .{});

    // Sort using replaceLigatures
    const ctx8 = SortContext{ .allocator = allocator };
    std.sort.insertion([]const u8, s8.items, ctx8, struct {
        fn lessThan(ctx: SortContext, lhs: []const u8, rhs: []const u8) bool {
            const l = replaceLigatures(ctx.allocator, lhs) catch return false;
            defer ctx.allocator.free(l);
            const r = replaceLigatures(ctx.allocator, rhs) catch return false;
            defer ctx.allocator.free(r);
            return mem.lessThan(u8, l, r);
        }
    }.lessThan);

    for (s8.items) |s| {
        try stdout.print("{s}\n", .{s});
    }

    var s9 = ArrayList([]const u8).init(allocator);
    defer s9.deinit();
    try s9.append("Start with an ʒ: 2-2");
    try s9.append("Start with an ſ: 2-1");
    try s9.append("Start with an ß: 2+0");
    try s9.append("Start with an s: 2+1");

    try stdout.print("\n", .{});

    // Sort using replaceCharacters
    const ctx9 = SortContext{ .allocator = allocator };
    std.sort.insertion([]const u8, s9.items, ctx9, struct {
        fn lessThan(ctx: SortContext, lhs: []const u8, rhs: []const u8) bool {
            const l = replaceCharacters(ctx.allocator, lhs) catch return false;
            defer ctx.allocator.free(l);
            const r = replaceCharacters(ctx.allocator, rhs) catch return false;
            defer ctx.allocator.free(r);
            return mem.lessThan(u8, l, r);
        }
    }.lessThan);

    for (s9.items) |s| {
        try stdout.print("{s}\n", .{s});
    }
}
