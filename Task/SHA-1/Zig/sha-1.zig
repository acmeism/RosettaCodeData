const std = @import("std");
const Sha1 = std.crypto.hash.Sha1;

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const message = "Rosetta Code";
    var stdout_wr = std.Io.File.stdout().writer(io, &.{});

    var out: [Sha1.digest_length]u8 = undefined;
    Sha1.hash(message, &out, .{});
    try stdout_wr.interface.print("{x}\n", .{&out});
}
