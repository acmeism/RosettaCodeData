const std = @import("std");

fn tendency1(n: f64) []const u8 {
    if (n > 0.0) return "Moving away from stable state";
    if (n < 0.0) return "Moving toward stable state";
    return "Stable equilibrium";
}

fn tendency2(n: f64) []const u8 {
    if (n > 0.0) return "Mass variation supports movement";
    if (n < 0.0) return "Mass variation resists movement";
    return "No mass variation effect";
}

pub fn main() !void {
    const x: f64 = 2.0;
    const v: f64 = 3.0;
    const m: f64 = 4.0;
    const dm_dt: f64 = -0.5;

    const p = m * v;
    const nktg1 = x * p;
    const nktg2 = dm_dt * p;

    const stdout = std.io.getStdOut().writer();

    try stdout.print("p: {d}\n", .{p});
    try stdout.print("NKTg1: {d}\n", .{nktg1});
    try stdout.print("NKTg2: {d}\n", .{nktg2});
    try stdout.print("Tendency1: {s}\n", .{tendency1(nktg1)});
    try stdout.print("Tendency2: {s}\n", .{tendency2(nktg2)});
}
