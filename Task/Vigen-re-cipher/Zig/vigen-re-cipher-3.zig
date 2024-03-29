pub fn main() anyerror!void {
    // ------------------------------------------ allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer {
        const ok = gpa.deinit();
        std.debug.assert(ok == .ok);
    }
    const allocator = gpa.allocator();
    // --------------------------------------------- stdout
    const stdout = std.io.getStdOut().writer();
    // ----------------------------------------------------
    const key = "VIGENERECIPHER";
    const text = "Beware the Jabberwock, my son! The jaws that bite, the claws that catch!";

    const encoded = try vigenere(allocator, text, key, .encode);
    defer allocator.free(encoded);
    try stdout.print("{s}\n", .{encoded});

    const decoded = try vigenere(allocator, encoded, key, .decode);
    defer allocator.free(decoded);
    try stdout.print("{s}\n", .{decoded});
}
