const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

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
        const ov1 = @mulWithOverflow(a, p1);
        if (ov1[1] != 0) break;
        const ov2 = @addWithOverflow(ov1[0], p0);
        if (ov2[1] != 0) break;
        const ov3 = @mulWithOverflow(a, q1);
        if (ov3[1] != 0) break;
        const ov4 = @addWithOverflow(ov3[0], q0);
        if (ov4[1] != 0) break;
        const p2 = ov2[0];
        const q2 = ov4[0];

        try stdout.print("e ~= {d:>19} / {d:>19} = ", .{ p2, q2 });
        try decPrint(stdout, p2, q2, 36);
        try stdout.writeByte('\n');
        p0 = p1;
        p1 = p2;
        q0 = q1;
        q1 = q2;
    }
}

fn decPrint(ostream: anytype, num: u64, den: u64, prec: usize) !void {
    // print out integer part.
    try ostream.print("{}.", .{num / den});

    // arithmetic with the remainders is done with u128, as the
    // multiply by 10 could potentially overflow a u64.
    //
    const m: u128 = @intCast(den);
    var r = @as(u128, num) % m;
    var dec: usize = 0; // decimal place we're in.
    while (dec < prec and r > 0) {
        const n = 10 * r;
        r = n % m;
        dec += 1;
        const ch = @as(u8, @intCast(n / m)) + '0';
        try ostream.writeByte(ch);
    }
}
