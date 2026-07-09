const std = @import("std");
const Base64Decoder = std.base64.standard.Decoder;
pub fn main(init: std.process.Init) !void {
    const io = init.io;
    var stdout_wr = std.Io.File.stdout().writer(io, &.{});
    const input = "VG8gZXJyIGlzIGh1bWFuLCBidXQgdG8gcmVhbGx5IGZvdWwgdGhpbmdzIHVwIHlvdSBuZWVkIGEgY29tcHV0ZXIuCiAgICAtLVBhdWwgUi5FaHJsaWNo";

    var out: [try Base64Decoder.calcSizeForSlice(input)]u8 = undefined;
    try Base64Decoder.decode(&out, input);
    try stdout_wr.interface.print("Input: {s}\n", .{input});
    try stdout_wr.interface.print("Output: {s}\n", .{&out});
}
