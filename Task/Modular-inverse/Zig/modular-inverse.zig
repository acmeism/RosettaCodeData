const std = @import("std");

fn mod_inv(a: isize, module: isize) isize {
    var mn_0 = module;
    var mn_1 = a;
    var xy_0: isize = 0;
    var xy_1: isize = 1;

    while (mn_1 != 0) {
        const xy_0_temp = xy_1;
        xy_1 = xy_0 - @divFloor(mn_0, mn_1) * xy_1;
        xy_0 = xy_0_temp;

        const mn_0_temp = mn_1;
        mn_1 = @rem(mn_0, mn_1);
        mn_0 = mn_0_temp;
    }

    while (xy_0 < 0) {
        xy_0 += module;
    }

    return xy_0;
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("{d}\n", .{mod_inv(42, 2017)});
}
