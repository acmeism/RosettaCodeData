const stdout = @import("std").io.getStdOut().writer();

const lim = 1000;
const n = lim - 2;

var primes: [n]?usize = undefined;

pub fn main() anyerror!void {
    var i: usize = 0;
    var m: usize = 0;

    while (i < n) : (i += 1) {
        primes[i] = i + 2;
    }

    i = 0;
    while (i < n) : (i += 1) {
        if (primes[i]) |prime| {
            m += 1;
            try stdout.print("{:5}", .{prime});
            if (m % 10 == 0) try stdout.print("\n", .{});
            var j: usize = i + prime;
            while (j < n) : (j += prime) {
                primes[j] = null;
            }
        }
    }
    try stdout.print("\n", .{});
}
