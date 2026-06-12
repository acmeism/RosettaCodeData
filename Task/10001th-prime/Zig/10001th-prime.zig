const std = @import("std");
const stdout = @import("std").io.getStdOut().writer();

const limit = 10001;

fn isPrime(x: usize) bool {
    if (x % 2 == 0) return false;

    var i: usize = 3;
    while (i * i <= x) : (i += 2) {
        if (x % i == 0) return false;
    }
    return true;
}

pub fn main() !void {
    var cnt: usize = 0;
    var last: usize = 0;
    var n: usize = 1;

    while (cnt < limit) : (n += 1) {
        if (isPrime(n)) {
            cnt += 1;
            last = n;
        }
    }
    try stdout.print("{d}st prime number is: {d}\n", .{ limit, last });
}
