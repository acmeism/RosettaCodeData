const std = @import("std");
const expect = std.testing.expect;
const stdout = std.io.getStdOut().outStream();

pub fn main() !void {
    var i: u32 = 2;
    try stdout.print("The first few perfect numbers are: ", .{});
    while (i <= 10_000) : (i += 2) if (propersum(i) == i)
        try stdout.print("{} ", .{i});
    try stdout.print("\n", .{});
}

fn propersum(n: u32) u32 {
    var sum: u32 = 1;
    var d: u32 = 2;
    while (d * d <= n) : (d += 1) if (n % d == 0) {
        sum += d;
        const q = n / d;
        if (q > d)
            sum += q;
    };
    return sum;
}

test "Proper divisors" {
    expect(propersum(28) == 28);
    expect(propersum(71) == 1);
    expect(propersum(30) == 42);
}
