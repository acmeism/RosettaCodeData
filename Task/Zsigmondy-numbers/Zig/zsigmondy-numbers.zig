const std = @import("std");

fn all_coprime(a: u64, b: u64, d: u64, n: u64) bool {
    for (1..n) |m| {
        const dm = std.math.pow(u64, a, m) - std.math.pow(u64, b, m);
        if (std.math.gcd(dm, d) != 1) return false;
    }
    return true;
}

fn zsigmondy(n: u64, a: u64, b: u64) u64 {
    const dn = std.math.pow(u64, a, n) - std.math.pow(u64, b, n);

    var maxdiv: u64 = 0;
    var d: u64 = 1;
    while (d*d <= dn) : (d += 1) {
        if (dn % d != 0) continue;
        if (d > maxdiv and all_coprime(a, b, d, n)) maxdiv = d;

        const dnd = dn / d;
        if (dnd > maxdiv and all_coprime(a, b, dnd, n)) maxdiv = dnd;
    }

    return maxdiv;
}

fn zsig_row(a: u64, b: u64) !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("zsigmondy(n, {d}, {d}):\n", .{a, b});
    for (1..21) |n| try stdout.print("{d} ", .{zsigmondy(n, a, b)});
    try stdout.writeByte('\n');
}

pub fn main() !void {
    const pairs = [_][2]u64{
        .{2, 1}, .{3, 1}, .{4, 1}, .{5, 1}, .{6, 1}, .{7, 1},
        .{3, 2}, .{5, 3}, .{7, 3}, .{7, 5}
    };

    for (pairs) |pair| try zsig_row(pair[0], pair[1]);
}
