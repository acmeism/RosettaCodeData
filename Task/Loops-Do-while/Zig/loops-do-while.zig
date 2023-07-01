const std = @import("std");

pub fn main() !void {
    var a: u8 = 0;
    // no do-while in syntax, trust the optimizer to do
    // correct Loop inversion https://en.wikipedia.org/wiki/Loop_inversion
    // If the variable `alive` is independent to other variables and not in
    // diverging control flow, then the optimization is possible in general.
    var alive = true;
    while (alive == true or a % 6 != 0) {
        alive = false;
        a += 1;
        try std.io.getStdOut().writer().print("{d}\n", .{a});
    }
}
