const std = @import("std");
const print = std.debug.print;
const ArrayList = std.ArrayList;
const HashMap = std.HashMap;
const Allocator = std.mem.Allocator;

const StringHashMap = HashMap([]const u8, i32, StringContext, std.hash_map.default_max_load_percentage);

const StringContext = struct {
    pub fn hash(self: @This(), s: []const u8) u64 {
        _ = self;
        return std.hash_map.hashString(s);
    }

    pub fn eql(self: @This(), a: []const u8, b: []const u8) bool {
        _ = self;
        return std.mem.eql(u8, a, b);
    }
};

fn findNgrams(allocator: Allocator, n: usize, s: []const u8) !StringHashMap {
    var ngrams = StringHashMap.init(allocator);

    // Convert string to array of UTF-8 codepoints
    var chars = ArrayList(u21).init(allocator);
    defer chars.deinit();

    var iter = std.unicode.Utf8Iterator{ .bytes = s, .i = 0 };
    while (iter.nextCodepoint()) |codepoint| {
        try chars.append(codepoint);
    }

    if (chars.items.len < n) {
        return ngrams;
    }

    const max_loc = chars.items.len - n;
    for (0..max_loc + 1) |i| {
        // Create ngram string from codepoints
        var ngram_bytes = ArrayList(u8).init(allocator);
        defer ngram_bytes.deinit();

        for (chars.items[i..i + n]) |codepoint| {
            var buf: [4]u8 = undefined;
            const len = std.unicode.utf8Encode(codepoint, &buf) catch continue;
            try ngram_bytes.appendSlice(buf[0..len]);
        }

        // Clone the string for storage in HashMap
        const ngram_str = try allocator.dupe(u8, ngram_bytes.items);

        const result = try ngrams.getOrPut(ngram_str);
        if (result.found_existing) {
            result.value_ptr.* += 1;
        } else {
            result.value_ptr.* = 1;
        }
    }

    return ngrams;
}

fn printNgrams(ngrams: *const StringHashMap) void {
    var col: usize = 0;
    var iter = ngrams.iterator();

    while (iter.next()) |entry| {
        print("'{s}' - {}", .{ entry.key_ptr.*, entry.value_ptr.* });
        if (col % 5 == 4) {
            print("\n", .{});
        } else {
            print("\t", .{});
        }
        col += 1;
    }
    print("\n", .{});
}

fn cleanupNgrams(allocator: Allocator, ngrams: *StringHashMap) void {
    var iter = ngrams.iterator();
    while (iter.next()) |entry| {
        allocator.free(entry.key_ptr.*);
    }
    ngrams.deinit();
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const s = "LIVE AND LET LIVE";

    for (2..5) |n| {
        print("{}-grams of '{s}':\n", .{ n, s });
        var ngrams = try findNgrams(allocator, n, s);
        defer cleanupNgrams(allocator, &ngrams);
        printNgrams(&ngrams);
    }
}
