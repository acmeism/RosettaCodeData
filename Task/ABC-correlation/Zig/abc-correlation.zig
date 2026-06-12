pub fn abc_word(word: []const u8) bool {
    const a = std.mem.count(u8, word, "a");
    const b = std.mem.count(u8, word, "b");
    const c = std.mem.count(u8, word, "c");
    return a == b and a == c;
}
