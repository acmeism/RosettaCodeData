/// Caller owns the returned slice memory.
fn vigenere(allocator: Allocator, text: []const u8, key: []const u8, mode: Vigenere) Allocator.Error![]u8 {
    var dynamic_string = std.ArrayList(u8).init(allocator);
    var key_index: usize = 0;
    for (text) |letter| {
        const c = if (std.ascii.isLower(letter)) std.ascii.toUpper(letter) else letter;
        if (std.ascii.isUpper(c)) {
            const k = key[key_index];
            const n = switch (mode) {
                .encode => ((c - 'A') + (k - 'A')),
                .decode => 26 + c - k,
            };
            try dynamic_string.append(n % 26 + 'A'); // A-Z
            key_index += 1;
            key_index %= key.len;
        }
    }
    return dynamic_string.toOwnedSlice();
}
