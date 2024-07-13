const std = @import("std");
const print = std.debug.print;

const PA = 0;
const PB = 1;
const PC = 2;
const PD = 3;
const PE = 4;
const PF = 5;
const PG = 6;
const PH = 7;

const Pair = struct { u8, u8 };
const Pairs = [_]Pair{ .{ PA, PC }, .{ PA, PD }, .{ PA, PE }, .{ PB, PD }, .{ PB, PE }, .{ PB, PF }, .{ PC, PG }, .{ PC, PD }, .{ PD, PE }, .{ PD, PG }, .{ PD, PH }, .{ PE, PG }, .{ PE, PH }, .{ PF, PH }, .{ PE, PF } };
var t: [8]u32 = .{0} ** 8;

inline fn abs(p: Pair) u32 {
    if (t[p.@"0"] < t[p.@"1"]) return t[p.@"1"] - t[p.@"0"];
    return t[p.@"0"] - t[p.@"1"];
}

fn check() bool {
    var r: bool = true;
    for (Pairs) |p| {
        r = r and abs(p) > 1;
        if (!r) break;
    }

    return r;
}

fn has(a: u32) bool {
    for (t) |v| {
        if (v == a) return true;
    }
    return false;
}

fn solve(lvl: u32) bool {
    if (lvl == 8) return check();
    for (1..9) |v| {
        if (has(v)) continue;
        t[lvl] = v;
        if (solve(lvl + 1)) {
            print("{{ A, B, C, D, E, F, G, H }} = {any}\n", .{t});
        }
    }
    t[lvl] = 0;
    return false;
}

pub fn main() void {
    _ = solve(0);
}
