const std = @import("std");
const stdout = std.io.getStdOut().outStream();

pub fn main() !void {
    try sieve(1000);
}

// using a comptime limit ensures that there's no need for dynamic memory.
fn sieve(comptime limit: usize) !void {
    var prime = [_]bool{true} ** limit;
    prime[0] = false;
    prime[1] = false;
    var i: usize = 2;
    while (i*i < limit) : (i += 1) {
        if (prime[i]) {
            var j = i*i;
            while (j < limit) : (j += i)
                prime[j] = false;
        }
    }
    var c: i32 = 0;
    for (prime) |yes, p|
        if (yes) {
            c += 1;
            try stdout.print("{:5}", .{p});
            if (@rem(c, 10) == 0)
                try stdout.print("\n", .{});
        };
    try stdout.print("\n", .{});
}
