// Warning: modifies the buffer in-place (returns pointer to in)
fn rot13(in: [] u8) []u8 {
    for (in) |*c| {
        var d : u8 = c.*;
        var x : u8 = d;
        x = if (@subWithOverflow(u8, d | 32, 97, &x) ) x else x;
        if (x < 26) {
            x = (x + 13) % 26 + 65 + (d & 32);
            c.* = x;
        }
    }
    return in;
}

const msg: [:0] const u8 =
    \\Lbh xabj vg vf tbvat gb or n onq qnl
    \\ jura gur yrggref va lbhe nycunorg fbhc
    \\ fcryy Q-V-F-N-F-G-R-E.
;

// need to copy the const string to a buffer
// before we can modify it in-place
//https://zig.news/kristoff/what-s-a-string-literal-in-zig-31e9

var buf: [500]u8 = undefined;
fn assignStr(out: []u8, str: [:0]const u8) void {
    for (str) |c, i| {
        out[i] = c;
    }
    out[str.len] = 0;
}

const print = @import("std").debug.print;

pub fn main() void {
    assignStr(&buf, msg);
    print("rot13={s}\n",.{rot13(&buf)});
}
