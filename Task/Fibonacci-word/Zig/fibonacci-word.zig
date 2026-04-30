const std = @import("std");

fn findEntropy(fiboword: []const u8) f64 {
    // Instead of using a hash map (like std::map in C++), using a flat
    // array is extremely fast for mapping bytes to frequency counts.
    var frequencies = [_]usize{0} ** 256;
    for (fiboword) |c| {
        frequencies[c] += 1;
    }

    const numlen: f64 = @floatFromInt(fiboword.len);
    var infocontent: f64 = 0;

    for (frequencies) |count| {
        if (count > 0) {
            const freq = @as(f64, @floatFromInt(count)) / numlen;
            infocontent += freq * std.math.log2(freq);
        }
    }

    // Multiply by -1 as in the original code
    // Use `+ 0.0` trick to avoid negative zero (-0.0) if infocontent is 0
    return -infocontent + 0.0;
}

fn printLine(writer: anytype, fiboword: []const u8, n: u32) !void {
    const entropy = findEntropy(fiboword);

    // Formatting equivalents:
    // {d:<5}   -> std::setw(5) << std::left << n
    // {d:>12}  -> std::setw(12) << std::right << fiboword.size()
    // {d:<16.13} -> std::setw(16) << std::setprecision(13) << std::left << entropy
    try writer.print("{d:<5}{d:>12}  {d:<16.13}\n", .{ n, fiboword.len, entropy });
}

pub fn main() !void {
    // A GeneralPurposeAllocator works perfectly for the large strings we will generate.
    // Fib(37) string length expands to ~24 Megabytes.
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const stdout = std.io.getStdOut().writer();

    // Print header
    try stdout.print("{s:<5}{s:>12}  {s:<16}\n", .{ "N", "length", "entropy" });

    // We start off by allocating the base strings on the heap so they
    // can be naturally freed in the memory cycle below without compiler complaints.
    var first: []const u8 = try allocator.dupe(u8, "1");
    var n: u32 = 1;
    try printLine(stdout, first, n);

    var second: []const u8 = try allocator.dupe(u8, "0");
    n += 1;
    try printLine(stdout, second, n);

    while (n < 37) {
        // Concatenate `first` and `second` into a new allocated string
        const result = try std.mem.concat(allocator, u8, &.{ first, second });

        // C++ uses `.assign()`, which copies the string's characters.
        // Here we can simply free the oldest string, step the slice references
        // forward, and save execution time avoiding memory copy overhead!
        allocator.free(first);
        first = second;
        second = result;

        n += 1;
        try printLine(stdout, result, n);
    }

    // Clean up our remaining two string references
    allocator.free(first);
    allocator.free(second);
}
