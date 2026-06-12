const std = @import("std");
const PI = std.math.pi;

// Constants for angles and kvalues
const ANGLES = [_]f64{
    0.78539816339745, 0.46364760900081, 0.24497866312686, 0.12435499454676,
    0.06241880999596, 0.03123983343027, 0.01562372862048, 0.00781234106010,
    0.00390623013197, 0.00195312251648, 0.00097656218956, 0.00048828121119,
    0.00024414062015, 0.00012207031189, 0.00006103515617, 0.00003051757812,
    0.00001525878906, 0.00000762939453, 0.00000381469727, 0.00000190734863,
    0.00000095367432, 0.00000047683716, 0.00000023841858, 0.00000011920929,
    0.00000005960464, 0.00000002980232, 0.00000001490116, 0.00000000745058,
};

const KVALUES = [_]f64{
    0.70710678118655, 0.63245553203368, 0.61357199107790, 0.60883391251775,
    0.60764825625617, 0.60735177014130, 0.60727764409353, 0.60725911229889,
    0.60725447933256, 0.60725332108988, 0.60725303152913, 0.60725295913894,
    0.60725294104140, 0.60725293651701, 0.60725293538591, 0.60725293510314,
    0.60725293503245, 0.60725293501477, 0.60725293501035, 0.60725293500925,
    0.60725293500897, 0.60725293500890, 0.60725293500889, 0.60725293500888,
};

// Function to convert degrees to radians
fn radians(degrees: f64) f64 {
    return degrees * PI / 180.0;
}

// Cordic algorithm implementation
fn cordic(alpha: f64, n: usize, c_cos: *f64, c_sin: *f64) void {
    var theta: f64 = 0.0;
    var pow2: f64 = 1.0;
    var x: f64 = 1.0;
    var y: f64 = 0.0;
    // Fixed the modulo operation with signed integers
    const floor_val = @as(i32, @intFromFloat(@floor(alpha / (2.0 * PI))));
    const newsgn: f64 = if (@mod(floor_val, 2) == 1) 1.0 else -1.0;

    if (alpha < -PI / 2.0 or alpha > PI / 2.0) {
        if (alpha < 0.0) {
            cordic(alpha + PI, n, &x, &y);
        } else {
            cordic(alpha - PI, n, &x, &y);
        }
        c_cos.* = x * newsgn;
        c_sin.* = y * newsgn;
        return;
    }

    const ix = if (n - 1 > 23) 23 else n - 1;
    const kn = KVALUES[ix];

    var i: usize = 0;
    while (i < n) : (i += 1) {
        const atn = ANGLES[i];
        const sigma: f64 = if (theta < alpha) 1.0 else -1.0;
        theta += sigma * atn;
        const t = x;
        x -= sigma * y * pow2;
        y += sigma * t * pow2;
        pow2 /= 2.0;
    }

    c_cos.* = x * kn;
    c_sin.* = y * kn;
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var c_cos: f64 = undefined;
    var c_sin: f64 = undefined;
    const test_angles = [_]f64{ -9.0, 0.0, 1.5, 6.0 };

    try stdout.writeAll("  x       sin(x)     diff. sine     cos(x)    diff. cosine\n");
    var th: i32 = -90;
    while (th <= 90) : (th += 15) {
        const thr = radians(@floatFromInt(th));
        cordic(thr, 24, &c_cos, &c_sin);
        try std.fmt.format(stdout, "{d:3}.0°  {d:10.8} ({d:10.8}) {d:10.8} ({d:10.8})\n",
            .{ th, c_sin, c_sin - @sin(thr), c_cos, c_cos - @cos(thr) });
    }

    try stdout.writeAll("\nx(rads)   sin(x)     diff. sine     cos(x)    diff. cosine\n");
    for (test_angles) |angle| {
        const thr = angle;
        cordic(thr, 24, &c_cos, &c_sin);
        try std.fmt.format(stdout, "{d:4.1}    {d:10.8} ({d:10.8}) {d:10.8} ({d:10.8})\n",
            .{ thr, c_sin, c_sin - @sin(thr), c_cos, c_cos - @cos(thr) });
    }
}
