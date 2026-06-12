const std = @import("std");

pub fn printSliceInt(slice: []const usize) !void {
    std.debug.print("[", .{});
    for (slice, 0..) |item, index| {
        if (index != 0) {
            std.debug.print(", ", .{});
        }
        std.debug.print("{}", .{item});
    }
    std.debug.print("]\n", .{});
}

pub fn kmp_table(allocator: std.mem.Allocator, pattern: []const u8) ![]usize {
    const m = pattern.len;
    var lps = try std.ArrayList(usize).initCapacity(allocator, m);
    try lps.resize(m);
    for (lps.items) |*item| {
        item.* = 0;
    }

    var length: usize = 0;
    var patternIndex: usize = 1;

    while (patternIndex < m) {
        if (pattern[patternIndex] == pattern[length]) {
            length += 1;
            lps.items[patternIndex] = length;
            patternIndex += 1;
        } else if (length > 0) {
            length = lps.items[length - 1];
        } else {
            lps.items[patternIndex] = 0;
            patternIndex += 1;
        }
    }
    return lps.toOwnedSlice();
}

pub fn kmp_search(allocator: std.mem.Allocator, pattern: []const u8, text: []const u8) ![]usize {
    const n = text.len;
    const m = pattern.len;

    const lps = try kmp_table(allocator, pattern);
    defer allocator.free(lps);

    var result = std.ArrayList(usize).init(allocator);

    var textIndex: usize = 0;
    var patternIndex: usize = 0;

    while (textIndex < n) {
        if (text[textIndex] == pattern[patternIndex]) {
            textIndex += 1;
            patternIndex += 1;
            if (patternIndex == m) {
                try result.append(textIndex - patternIndex);
                patternIndex = lps[patternIndex - 1];
            }
        } else if (patternIndex != 0) {
            patternIndex = lps[patternIndex - 1];
        } else {
            textIndex += 1;
        }
    }

    return result.toOwnedSlice();
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer {
        const health = gpa.deinit();
        if (health != .ok) {
            std.debug.print("Memory leak detected: {}\n", .{health});
        }
    }
    const allocator = gpa.allocator();

    const texts = [_][]const u8{ "GCTAGCTCTACGAGTCTA", "GGCTATAATGCGTA", "there would have been a time for such a word", "needle need noodle needle", "InhisbookseriesTheArtofComputerProgrammingpublishedbyAddisonWesleyDKnuthusesanimaginarycomputertheMIXanditsassociatedmachinecodeandassemblylanguagestoillustratetheconceptsandalgorithmsastheyarepresented", "Nearby farms grew a half acre of alfalfa on the dairy's behalf, with bales of all that alfalfa exchanged for milk." };
    for (texts, 0..) |text, index| {
        std.debug.print("Text{} = {s}\n", .{ index + 1, text });
    }
    std.debug.print("\n", .{});

    const patterns = [_][]const u8{ "TCTA", "TAATAAA", "word", "needle", "put", "and", "alfalfa" };
    for (patterns, 0..) |pattern, index| {
        const j = if (index < 5) index else index - 1;
        const results = try kmp_search(allocator, pattern, texts[j]);
        defer allocator.free(results);
        std.debug.print("Found pattern {s} in Text {} at indices ", .{ pattern, j + 1 });
        try printSliceInt(results);
    }
}
