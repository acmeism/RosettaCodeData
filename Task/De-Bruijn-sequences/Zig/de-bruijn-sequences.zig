const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const math = std.math;

// Context for the recursive de Bruijn sequence generation (FKM algorithm)
const DbContext = struct {
    k: u8, // Alphabet size
    n: usize, // Subsequence length
    a: []u8, // Working array (Lyndon words decomposition) - MUST be mutable
    seq: *ArrayList(u8), // Result sequence accumulator

    fn generate(self: *DbContext, t: usize, p: usize) !void {
        if (t > self.n) {
            // Base case: append cycle a[1..p] if n is divisible by p
            if (self.n % p == 0) {
                try self.seq.appendSlice(self.a[0..p]);
            }
        } else {
            // Recursive step
            if (t > p) {
                self.a[t - 1] = self.a[t - p - 1];
            } else {
                self.a[t - 1] = 0;
            }
            try self.generate(t + 1, p);

            // Try subsequent symbols
            var j: u8 = if (t > p) self.a[t - p - 1] + 1 else 1;
            while (j < self.k) : (j += 1) {
                self.a[t - 1] = j;
                try self.generate(t + 1, t);
            }
        }
    }
};

fn deBruijn(allocator: Allocator, k: u8, n: usize) ![]u8 {
    if (k == 0 or n == 0) return ""; // Handle edge cases

    // Allocate working array 'a' and initialize to 0
    const a = try allocator.alloc(u8, k * n);
    errdefer allocator.free(a);
    @memset(a, 0); // Initialize array to 0

    // ArrayList to store the resulting sequence digits (0..k-1)
    var seq_digits = ArrayList(u8).init(allocator);
    defer seq_digits.deinit(); // Always deallocate seq_digits

    // Create and run the generation context
    var context = DbContext{
        .k = k,
        .n = n,
        .a = a,
        .seq = &seq_digits,
    };
    try context.generate(1, 1);

    // Convert sequence digits (0-9) to characters ('0'-'9') and append prefix
    var result = ArrayList(u8).init(allocator);
    errdefer result.deinit();

    // Reserve enough space: k^n + (n-1)
    const seq_len_exact_f = math.pow(f64, @as(f64, @floatFromInt(k)), @as(f64, @floatFromInt(n)));
    if (seq_len_exact_f > @as(f64, @floatFromInt(std.math.maxInt(usize)))) {
        std.debug.print("k^n is too large!\n", .{});
        return error.Overflow;
    }
    const seq_len_exact: usize = @intFromFloat(seq_len_exact_f);
    const final_len = seq_len_exact + (n - 1);

    try result.ensureTotalCapacity(final_len);

    // Convert digits to ASCII characters
    for (seq_digits.items) |digit| {
        if (digit >= 10) {
            std.debug.print("Error: digit >= 10 found in sequence for k=10\n", .{});
            return error.InvalidDigit;
        }
        result.appendAssumeCapacity('0' + digit);
    }

    // Append the first n-1 characters to make the sequence cyclic
    if (n > 1 and result.items.len >= n - 1) {
        result.appendSliceAssumeCapacity(result.items[0 .. n - 1]);
    }

    // Free the working array 'a'
    allocator.free(a);

    // Return the final string as an owned slice
    return result.toOwnedSlice();
}

pub fn main() !void {
    // Setup allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Generate the sequence for k=10, n=4
    const k: u8 = 10;
    const n: usize = 4;
    const db_sequence = try deBruijn(allocator, k, n);
    defer allocator.free(db_sequence);

    // Print basic output to verify
    const writer = std.io.getStdOut().writer();
    try writer.print("Generated de Bruijn sequence length: {d}\n", .{db_sequence.len});
    try writer.print("First 130 digits: {s}\n", .{db_sequence[0..@min(130, db_sequence.len)]});
}
