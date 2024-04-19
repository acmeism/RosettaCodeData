const std = @import("std");
const stdout = @import("std").io.getStdOut().writer();

pub fn rot(txt: []u8, key: u8) void {
    for (txt, 0..txt.len) |c, i| {
        if (std.ascii.isLower(c)) {
            txt[i] = (c - 'a' + key) % 26 + 'a';
        } else if (std.ascii.isUpper(c)) {
            txt[i] = (c - 'A' + key) % 26 + 'A';
        }
    }
}

pub fn main() !void {
    const key = 3;
    var txt = "The five boxing wizards jump quickly".*;

    try stdout.print("Original:  {s}\n", .{txt});
    rot(&txt, key);
    try stdout.print("Encrypted: {s}\n", .{txt});
    rot(&txt, 26 - key);
    try stdout.print("Decrypted: {s}\n", .{txt});
}
