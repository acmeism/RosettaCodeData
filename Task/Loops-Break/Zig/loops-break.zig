const std = @import("std");

pub fn main() !void {
    const RndGen = std.rand.DefaultPrng;
    var rnd = RndGen.init(42);
    // possible improvement: make rng fair
    var rand_num1: u5 = undefined;
    var rand_num2: u5 = undefined;
    while (true) {
        rand_num1 = rnd.random().int(u5) % 20;
        try std.io.getStdOut().writer().print("{d}\n", .{rand_num1});
        if (rand_num1 == 10)
            break;
        rand_num2 = rnd.random().int(u5) % 20;
        try std.io.getStdOut().writer().print("{d}\n", .{rand_num2});
    }
}
