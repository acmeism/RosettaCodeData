const std = @import("std");

pub fn main() !void {
    const writer = std.io.getStdOut().writer();

    try printSolvedPell(61, writer);
    try printSolvedPell(109, writer);
    try printSolvedPell(181, writer);
    try printSolvedPell(277, writer);
}

const Pair = struct {
    v1: u256,
    v2: u256,

    fn init(a: u256, b: u256) Pair {
        return Pair{
            .v1 = a,
            .v2 = b,
        };
    }
};

fn solvePell(n: u256) Pair {
    const x: u256 = std.math.sqrt(n);

    // n is a perfect square - no solution other than 1,0
    if (x * x == n)
        return Pair.init(1, 0);

    // there are non-trivial solutions
    var y = x;
    var z: u256 = 1;
    var r = 2 * x;
    var e = Pair.init(1, 0);
    var f = Pair.init(0, 1);
    var a: u256 = 0;
    var b: u256 = 0;

    while (true) {
        y = r * z - y;
        z = (n - y * y) / z;
        r = (x + y) / z;
        e = Pair.init(e.v2, r * e.v2 + e.v1);
        f = Pair.init(f.v2, r * f.v2 + f.v1);
        a = e.v2 + x * f.v2;
        b = f.v2;
        const ov = @subWithOverflow(a * a, n * b * b);
        if (ov[1] != 0)
            continue;
        if (ov[0] == 1) // a * a, n * b * b == 1
            break;
    }
    return Pair.init(a, b);
}

fn printSolvedPell(n: u256, writer: anytype) !void {
    const r = solvePell(n);
    try writer.print("x^2 - {d:3} * y^2 = 1 for x = {d:21} and y = {d:19}\n", .{ n, r.v1, r.v2 });
}
