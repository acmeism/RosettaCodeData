const std = @import("std");
const print = std.debug.print;

fn moebius(x_param: u64) i8 {
    var x = x_param;
    var prime_count: u32 = 0;

    // Helper function to divide x by a factor and count it
    // Returns true if we should return 0 (factor appears twice)
    const divideXBy = struct {
        fn call(x_ptr: *u64, factor: u64, prime_count_ptr: *u32) bool {
            if (x_ptr.* % factor == 0) {
                x_ptr.* /= factor;
                prime_count_ptr.* += 1;
                if (x_ptr.* % factor == 0) {
                    return true; // Return 0
                }
            }
            return false;
        }
    }.call;

    // Handle 2 and 3 separately
    if (divideXBy(&x, 2, &prime_count)) return 0;
    if (divideXBy(&x, 3, &prime_count)) return 0;

    // Use a wheel sieve to check the remaining factors <= √x
    var i: u64 = 5;
    const sqrt_x = isqrt(x);
    while (i <= sqrt_x) : (i += 6) {
        if (divideXBy(&x, i, &prime_count)) return 0;
        if (divideXBy(&x, i + 2, &prime_count)) return 0;
    }

    // There can exist one prime factor larger than √x,
    // in that case we can check if x is still larger than one, and then count it.
    if (x > 1) {
        prime_count += 1;
    }

    if (prime_count % 2 == 0) {
        return 1;
    } else {
        return -1;
    }
}

/// Returns the largest integer smaller than or equal to `√n`
fn isqrt(n: u64) u64 {
    if (n <= 1) {
        return n;
    } else {
        var x0: u64 = std.math.pow(u64, 2, @as(u32, @intFromFloat(@floor(@log2(@as(f64, @floatFromInt(n))) / 2.0))) + 1);
        var x1: u64 = (x0 + n / x0) / 2;
        while (x1 < x0) {
            x0 = x1;
            x1 = (x0 + n / x0) / 2;
        }
        return x0;
    }
}

pub fn main() void {
    const ROWS: u64 = 10;
    const COLS: u64 = 20;
    print("Values of the Möbius function, μ(x), for x between 0 and {}:\n", .{COLS * ROWS});

    for (0..ROWS) |i| {
        for (0..COLS + 1) |j| {
            const x = COLS * i + j;
            const mu = moebius(x);
            if (mu >= 0) {
                // Print an extra space if there's no minus sign in front of the output
                // in order to align the numbers in a nice grid.
                print(" ", .{});
            }
            print("{} ", .{mu});
        }
        print("\n" , .{});
    }

    const x = std.math.maxInt(u64);
    print("\nμ({}) = {}\n", .{ x, moebius(x) });
}
