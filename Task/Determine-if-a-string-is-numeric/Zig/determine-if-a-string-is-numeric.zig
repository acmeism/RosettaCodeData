const std = @import("std");
const stdout = std.io.getStdOut().writer();

fn isNumeric(str: []const u8) bool {
    const num = std.mem.trim(u8, str, "\x20");
    _ = std.fmt.parseFloat(f64, num) catch return false;
    return true;
}

pub fn main() !void {
    const s1 = "  123";
    const s2 = " +123";
    const s3 = " 12.3";
    const s4 = "-12.3";
    const s5 = "12e-3";
    const s6 = "=12-3";
    const s7 = "abcde";
    const s8 = "12cde";
    const s9 = "NaN";
    const s10 = "0xFF";

    try stdout.print("Is {s} numeric? {}\n", .{ s1, isNumeric(s1) });
    try stdout.print("Is {s} numeric? {}\n", .{ s2, isNumeric(s2) });
    try stdout.print("Is {s} numeric? {}\n", .{ s3, isNumeric(s3) });
    try stdout.print("Is {s} numeric? {}\n", .{ s4, isNumeric(s4) });
    try stdout.print("Is {s} numeric? {}\n", .{ s5, isNumeric(s5) });
    try stdout.print("Is {s} numeric? {}\n", .{ s6, isNumeric(s6) });
    try stdout.print("Is {s} numeric? {}\n", .{ s7, isNumeric(s7) });
    try stdout.print("Is {s} numeric? {}\n", .{ s8, isNumeric(s8) });
    try stdout.print("Is {s} numeric? {}\n", .{ s9, isNumeric(s9) });
    try stdout.print("Is {s} numeric? {}\n", .{ s10, isNumeric(s10) });
}
