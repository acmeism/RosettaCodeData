const std = @import("std");

pub fn main() !void {
    // ArenaAllocator with its facility to reset obviates the
    // requirement to individually free()/deinit() any allocated
    // memory.
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer _ = arena.deinit();
    const allocator = arena.allocator();

    const writer = std.io.getStdOut().writer();
    // --------------------------------------------------- task 1
    try writer.writeAll("Number  Palindromes\n");
    var i: u32 = 100;
    while (i <= 125) : (i += 1) {
        var buf: [3]u8 = undefined;
        const s = try std.fmt.bufPrint(&buf, "{d}", .{i});
        const palindromes: [][]const u8 = try allPalindromes(allocator, s);
        defer _ = arena.reset(.retain_capacity);
        try writer.print("{}  ", .{i});
        std.mem.sort([]const u8, palindromes, {}, lessThan);
        for (palindromes) |palindrome|
            try writer.print("{s:5}", .{palindrome});
        try writer.writeByte('\n');
    }
    // --------------------------------------------------- task 2
    const numbers = [_][]const u8{
        "9",                         "169",                   "12769",
        "1238769",                   "123498769",             "12346098769",
        "1234572098769",             "123456832098769",       "12345679432098769",
        "1234567905432098769",       "123456790165432098769", "83071934127905179083",
        "1320267947849490361205695",
    };
    try writer.writeAll("\nNumber            Has no >= 2 digit palindromes\n");
    for (numbers) |number| {
        const palindromes = try allPalindromes(allocator, number);
        defer _ = arena.reset(.retain_capacity);
        const none = !hasSignificantStrings(palindromes);
        try writer.print("{s: <26} {}\n", .{ number, none });
    }
}
/// This function does not free any of its allocated memory.
/// Freeing relies upon the allocator's parent being reset
/// i.e. ArenaAllocator in this solution.
fn allPalindromes(allocator: std.mem.Allocator, number: []const u8) ![][]const u8 {
    var substrings = std.ArrayList([]const u8).init(allocator);
    for (0..number.len) |i|
        for (1..number.len - i + 1) |j|
            try substrings.append(number[i .. i + j]);

    var palindrome_set = std.StringArrayHashMap(void).init(allocator);
    for (substrings.items) |string|
        if (isPalindrome(string))
            try palindrome_set.put(string, {});
    return palindrome_set.keys();
}
fn isPalindrome(s: []const u8) bool {
    for (0..s.len / 2) |i|
        if (s[i] != s[s.len - i - 1])
            return false;
    return true;
}
fn hasSignificantStrings(strings: []const []const u8) bool {
    for (strings) |s|
        if (s.len > 1)
            return true;
    return false;
}
/// Lexicographically compare two strings. Returns true if a < b
fn lessThan(_: void, a: []const u8, b: []const u8) bool {
    const len = @min(a.len, b.len);
    for (a[0..len], b[0..len]) |c1, c2|
        return switch (std.math.order(c1, c2)) {
            .lt => true,
            .eq => continue,
            .gt => false,
        };
    return a.len < b.len;
}
// Some minimal tests...
const testing = std.testing;
test isPalindrome {
    try testing.expect(isPalindrome("0"));
    try testing.expect(isPalindrome("11"));
    try testing.expect(isPalindrome("121"));
    try testing.expect(!isPalindrome("12"));
    try testing.expect(!isPalindrome("122"));
}
test hasSignificantStrings {
    try testing.expect(hasSignificantStrings(&[_][]const u8{ "9", "10", "11" }));
    try testing.expect(!hasSignificantStrings(&[_][]const u8{}));
    try testing.expect(!hasSignificantStrings(&[_][]const u8{""}));
    try testing.expect(!hasSignificantStrings(&[_][]const u8{ "1", "2" }));
}
