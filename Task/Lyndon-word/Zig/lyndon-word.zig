const std = @import("std");

// Return the index of the given element in the given array
fn indexOf(words: []const []const u8, word: []const u8) i32 {
    for (words, 0..) |w, i| {
        if (std.mem.eql(u8, w, word)) {
            return @intCast(i);
        }
    }
    return -1;
}

// Using the Duval (1988) algorithm
fn nextWord(allocator: std.mem.Allocator, max_length: u32, word: []const u8, alphabet: []const []const u8) ![]u8 {
    // Step 1: Repeat the word and truncate
    var next_word = std.ArrayList(u8).init(allocator);
    defer next_word.deinit();

    while (next_word.items.len < max_length) {
        try next_word.appendSlice(word);
    }
    try next_word.resize(max_length);

    // Step 2: Remove last symbol of the next word if it is the last symbol in the alphabet
    const alphabet_last_symbol = alphabet[alphabet.len - 1];
    while (next_word.items.len > 0 and std.mem.endsWith(u8, next_word.items, alphabet_last_symbol)) {
        try next_word.resize(next_word.items.len - alphabet_last_symbol.len);
    }

    // Step 3: Replace the last symbol of the next word by its successor in the alphabet
    if (next_word.items.len > 0) {
        if (next_word.items.len >= 1) {
            const word_last_len=1;
            const word_last_symbol = next_word.items[next_word.items.len - word_last_len..];
            const index = @as(usize, @intCast(indexOf(alphabet, word_last_symbol) + 1));
            _ = next_word.pop();
            try next_word.appendSlice(alphabet[index]);
        } else {
            const word_last_len=0;
            const word_last_symbol = next_word.items[next_word.items.len - word_last_len..];
            const index = @as(usize, @intCast(indexOf(alphabet, word_last_symbol) + 1));
            _ = next_word.pop();
            try next_word.appendSlice(alphabet[index]);
        }
    }

    return next_word.toOwnedSlice();
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const alphabet = [_][]const u8{ "0", "1" };
    var word = try allocator.dupe(u8, alphabet[0]);
    defer allocator.free(word);

    while (word.len > 0) {
        const stdout = std.io.getStdOut().writer();
        try stdout.print("{s}\n", .{word});

        const new_word = try nextWord(allocator, 5, word, &alphabet);
        allocator.free(word);
        word = new_word;
    }
}
