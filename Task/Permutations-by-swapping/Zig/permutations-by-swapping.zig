const std = @import("std");

// Generic function to generate permutations
fn generate(comptime T: type, a: []T, output: fn ([]const T, i64) void) void {
    const n = a.len;
    var c = std.heap.page_allocator.alloc(usize, n) catch unreachable;
    defer std.heap.page_allocator.free(c);

    @memset(c, 0);

    var i: usize = 1;
    var sign: i64 = 1;
    output(a, sign);

    while (i < n) {
        if (c[i] < i) {
            if ((i & 1) == 0) {
                std.mem.swap(T, &a[0], &a[i]);
            } else {
                std.mem.swap(T, &a[c[i]], &a[i]);
            }
            sign = -sign;
            output(a, sign);
            c[i] += 1;
            i = 1;
        } else {
            c[i] = 0;
            i += 1;
        }
    }
}

// Function to print permutation and its sign
fn printPermutation(comptime T: type) fn ([]const T, i64) void {
    return struct {
        fn inner(a: []const T, sign: i64) void {
            std.debug.print("{any} {}\n", .{ a, sign });
        }
    }.inner;
}

pub fn main() !void {
    std.debug.print("Permutations and signs for three items:\n", .{});
    var a = [_]i32{ 0, 1, 2 };
    generate(i32, &a, printPermutation(i32));

    std.debug.print("\nPermutations and signs for four items:\n", .{});
    var b = [_]i32{ 0, 1, 2, 3 };
    generate(i32, &b, printPermutation(i32));
}
