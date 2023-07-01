const std = @import("std");
const math = std.math;
const stdout = std.io.getStdOut().writer();

pub fn main() !void {
    var n: u32 = 0;
    var state: u2 = 0;
    var p0: u64 = 0;
    var q0: u64 = 1;
    var p1: u64 = 1;
    var q1: u64 = 0;
    while (true) {
        var a: u64 = undefined;
        switch (state) {
            0 => {
                a = 2;
                state = 1;
            },
            1 => {
                a = 1;
                state = 2;
            },
            2 => {
                n += 2;
                a = n;
                state = 3;
            },
            3 => {
                a = 1;
                state = 1;
            },
        }
        var p2: u64 = undefined;
        var q2: u64 = undefined;
        if (@mulWithOverflow(u64, a, p1, &p2) or
            @addWithOverflow(u64, p2, p0, &p2) or
            @mulWithOverflow(u64, a, q1, &q2) or
            @addWithOverflow(u64, q2, q0, &q2))
        {
            break;
        }
        try stdout.print("e ~= {d:>19} / {d:>19} = ", .{p2, q2});
        try dec_print(stdout, p2, q2, 36);
        try stdout.writeByte('\n');
        p0 = p1;
        p1 = p2;
        q0 = q1;
        q1 = q2;
    }
}

fn dec_print(ostream: anytype, num: u64, den: u64, prec: usize) !void {
    // print out integer part.
    try ostream.print("{}.", .{num / den});

    // arithmetic with the remainders is done with u128, as the
    // multiply by 10 could potentially overflow a u64.
    //
    const m = @intCast(u128, den);
    var r = @as(u128, num) % m;
    var dec: usize = 0; // decimal place we're in.
    while (dec < prec and r > 0) {
        const n = 10 * r;
        r = n % m;
        dec += 1;
        const ch = @intCast(u8, n / m) + '0';
        try ostream.writeByte(ch);
    }
}
