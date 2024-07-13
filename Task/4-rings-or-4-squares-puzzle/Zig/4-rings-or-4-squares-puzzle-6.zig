const print = @import("std").debug.print;

var cnt: u32 = 0;
var t: [7]u8 = .{0} ** 7;

fn sum() bool {
    const s1 = t[0] + t[1];
    const s2 = t[1] + t[2] + t[3];
    const s3 = t[3] + t[4] + t[5];
    const s4 = t[5] + t[6];
    return s1 == s2 and s2 == s3 and s3 == s4;
}

fn valid(comptime min: u16) bool {
    if (sum()) {
        var s: u16 = 0;
        inline for (t) |v| {
            s |= @as(u16, 1) << @intCast(v - min);
        }
        return s == 0x7F;
    }
    return false;
}

fn valid_non_unique(comptime min: u16) bool {
    _ = min;
    return sum();
}

fn solver(lvl: u32, comptime min: u16, comptime max: u16, comptime f_valid: fn (comptime u16) bool) bool {
    if (lvl == 7) return f_valid(min);
    for (min..max) |i| {
        t[lvl] = @intCast(i);
        if (solver(lvl + 1, min, max, f_valid)) cnt += 1;
    }
    return false;
}

fn solve(comptime min: u8, comptime max: u8, comptime f: fn (comptime u16) bool) void {
    cnt = 0;
    _ = solver(0, min, max + 1, f);
    const str = if (f == valid) "" else "non-";
    print("{d} {s}unique solutions in {} to {}\n", .{ cnt, str, min, max });
}

pub fn main() void {
    solve(1, 7, valid);
    solve(3, 9, valid);
    solve(0, 9, valid_non_unique);
}
