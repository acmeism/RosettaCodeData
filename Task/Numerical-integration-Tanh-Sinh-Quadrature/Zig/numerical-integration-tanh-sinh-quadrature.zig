//! Tanh–Sinh numerical integration in Zig 0.14.1
const std = @import("std");
const math = std.math;

const PI = math.pi;

/// Tanh–Sinh numerical integration.
///
/// * `f`      - integrand
/// * `lower`  - lower integration bound
/// * `upper`  - upper integration bound
/// * `steps`  - maximum refinement levels
/// * `acc`    - absolute accuracy goal
///
/// Returns the estimated integral of `f` from `lower` to `upper`.
fn tanhSinh(
    comptime F: type,
    f: *const fn (F, f64) callconv(.Inline) f64,
    ctx: F,
    lower: f64,
    upper: f64,
    steps: usize,
    acc: f64,
) f64 {
    const h: f64 = 0.1;
    const h0 = (upper - lower) / 2.0;
    const h1 = (lower + upper) / 2.0;

    var rr: f64 = 0.0;
    var k: usize = 1;
    while (k <= steps) : (k += 1) {
        const ro = rr;
        const n = ( @as(u6, @intCast(1)) << @as(u3, @intCast(k)) ) - 1;

        var ss: f64 = 0.0;
        var i: i32 = -@as(i32, @intCast(n));
        while (i <= @as(i32, @intCast(n))) : (i += 1) {
            const t = @as(f64, @floatFromInt(i)) * h;

            const sh = math.sinh(t);
            const ch = math.cosh(t);
            const th = math.tanh(sh * PI / 2.0);
            const dx = (ch * PI / 2.0) / math.pow(f64, math.cosh(sh * PI / 2.0), 2);

            const xi = h1 + h0 * th;
            const wt = h * dx;
            ss += f(ctx, xi) * wt;
        }

        rr = h0 * ss;
        if (@abs(rr - ro) < acc) break;
    }
    return rr;
}

// ---------- demo -----------------------------------------------------------

const IntegrandCtx = struct {
    fn sin(_: @This(), x: f64) callconv(.Inline) f64 {
        return math.sin(x);
    }
    fn exp(_: @This(), x: f64) callconv(.Inline) f64 {
        return math.exp(x);
    }
};

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    const res1 = tanhSinh(IntegrandCtx, &IntegrandCtx.sin, .{}, 0.0, 1.0, 5, 1e-8);
    try stdout.print("{d:.8}\n", .{res1});

    const res2 = tanhSinh(IntegrandCtx, &IntegrandCtx.exp, .{}, -3.0, 3.0, 5, 1e-8);
    try stdout.print("{d:.8}\n", .{res2});
}
