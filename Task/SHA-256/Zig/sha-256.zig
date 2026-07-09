const std = @import("std");
const Sha256 = std.crypto.hash.sha2.Sha256;

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const message = "Rosetta code";
    var stdout_wr = std.Io.File.stdout().writer(io, &.{});

    var out: [Sha256.digest_length]u8 = undefined;
    Sha256.hash(message, &out, .{});
    try stdout_wr.interface.print("{x}\n", .{&out});
}
