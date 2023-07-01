const std = @import("std");

fn printResults(alloc: std.mem.Allocator, string: []const u8) !void {
    const cnt_codepts_utf8 = try std.unicode.utf8CountCodepoints(string);
    // There is no sane and portable extended ascii, so the best
    // we get is counting the bytes and assume regular ascii.
    const cnt_bytes_utf8 = string.len;
    const stdout_wr = std.io.getStdOut().writer();
    try stdout_wr.print("utf8  codepoints = {d}, bytes = {d}\n", .{ cnt_codepts_utf8, cnt_bytes_utf8 });

    const utf16str = try std.unicode.utf8ToUtf16LeWithNull(alloc, string);
    const cnt_codepts_utf16 = try std.unicode.utf16CountCodepoints(utf16str);
    const cnt_2bytes_utf16 = try std.unicode.calcUtf16LeLen(string);
    try stdout_wr.print("utf16 codepoints = {d}, bytes = {d}\n", .{ cnt_codepts_utf16, 2 * cnt_2bytes_utf16 });
}

pub fn main() !void {
    var arena_instance = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena_instance.deinit();
    const arena = arena_instance.allocator();
    const string1: []const u8 = "Hello, world!";
    try printResults(arena, string1);
    const string2: []const u8 = "møøse";
    try printResults(arena, string2);
    const string3: []const u8 = "𝔘𝔫𝔦𝔠𝔬𝔡𝔢";
    try printResults(arena, string3);
    // \u{332} is underscore of previous character, which the browser may not
    // copy correctly
    const string4: []const u8 = "J\u{332}o\u{332}s\u{332}e\u{301}\u{332}";
    try printResults(arena, string4);
}
