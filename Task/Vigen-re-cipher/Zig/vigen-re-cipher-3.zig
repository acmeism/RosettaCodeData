pub fn main() anyerror!void {
    // allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer {
        const ok = gpa.deinit();
        std.debug.assert(ok == .ok);
    }
    const allocator = gpa.allocator();
    //
    const stdout = std.io.getStdOut().writer();
    //
    const key = "VIGENERECIPHER";
    const text = "Beware the Jabberwock, my son! The jaws that bite, the claws that catch!";

    const encoded = try vigenere(allocator, text, key, true);
    defer allocator.free(encoded);
    _ = try stdout.print("{s}\n", .{encoded});

    const decoded = try vigenere(allocator, encoded, key, false);
    defer allocator.free(decoded);
    _ = try stdout.print("{s}\n", .{decoded});
}
