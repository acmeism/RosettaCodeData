const MAX = 200;  // max number to check
const N = u16;    // smallest integer type that fits

pub fn reverse(n: N) N {
    var r: N = 0;
    var nn = n;
    while (nn > 0) : (nn /= 10)
        r = r*10 + nn%10;
    return r;
}

pub fn special(n: N) bool {
    var r = reverse(n);
    var d: N = 1;
    while (d <= n/2) : (d += 1)
        if (n % d == 0 and r % reverse(d) != 0)
            return false;
    return true;
}

pub fn main() !void {
    const stdout = @import("std").io.getStdOut().writer();

    var c: N = 0;
    var n: N = 1;
    while (n <= MAX) : (n += 1) {
        if (special(n)) {
            try stdout.print("{d:4}", .{n});
            c += 1;
            if (c % 10 == 0) try stdout.print("\n", .{});
        }
    }
    try stdout.print("\n", .{});
}
