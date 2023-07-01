const std = @import("std");

pub fn main() void {
    var x: f64 = -1.2345;
    std.debug.print("e = {d}\n", .{std.math.e});
    std.debug.print("pi = {d}\n", .{std.math.pi});
    std.debug.print("sqrt(4) = {d}\n", .{std.math.sqrt(4)});
    std.debug.print("ln(e) = {d}\n", .{std.math.ln(std.math.e)});
    std.debug.print("exp(x) = {d}\n", .{std.math.exp(x)});
    std.debug.print("abs(x) = {d}\n", .{std.math.absFloat(x)});
    std.debug.print("floor(x) = {d}\n", .{std.math.floor(x)});
    std.debug.print("ceil(x) = {d}\n", .{std.math.ceil(x)});
    std.debug.print("pow(f64, -x, x) = {d}\n", .{std.math.pow(f64, -x, x)});
}
