const std = @import("std");

fn DoubleWide(comptime n: anytype) type {
    const Signedness = std.builtin.Signedness;
    switch (@typeInfo(@TypeOf(n))) {
        .Int => |t|
            return std.meta.Int(t.signedness, t.bits * 2),
        .ComptimeInt => {
            const sz = @as(u16, @intFromFloat(@log2(@as(f64, @floatFromInt(n))))) + 1;
            return std.meta.Int(Signedness.signed, sz * 2);
        },
        else =>
            @compileError("must have integral type for DoubleWide")
    }
}

fn sumdiv(n: anytype, d: anytype) DoubleWide(n) {
    var m: DoubleWide(n) = @divFloor(n, d);
    return @divExact(m * (m + 1), 2) * d;
}

fn sum3or5(n: anytype) DoubleWide(n) {
    return sumdiv(n, 3) + sumdiv(n, 5) - sumdiv(n, 15);
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    var s: usize = 0;
    for (1..1000) |n| {
        if (n % 3 == 0 or n % 5 == 0)
            s += n;
    }
    try stdout.print("The sum of the multiples of 3 and 5 below 1000 is {}\n", .{s});
    try stdout.print("The sum of the multiples of 3 and 5 below 1e20 is {}\n", .{sum3or5(99_999_999_999_999_999_999)});
}
