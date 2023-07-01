const std = @import("std");

const debug = std.debug;
const math = std.math;

test "infinity" {
    const infinite_f16 = math.inf(f16);
    const infinite_f32 = math.inf(f32);
    const infinite_f64 = math.inf(f64);
    const infinite_f128 = math.inf(f128);

    // Any other types besides these four floating types are not implemented.

    debug.assert(math.isInf(infinite_f16));
    debug.assert(math.isInf(infinite_f32));
    debug.assert(math.isInf(infinite_f64));
    debug.assert(math.isInf(infinite_f128));

    debug.assert(math.isPositiveInf(infinite_f16));
    debug.assert(math.isPositiveInf(infinite_f32));
    debug.assert(math.isPositiveInf(infinite_f64));
    debug.assert(math.isPositiveInf(infinite_f128));

    debug.assert(math.isNegativeInf(-infinite_f16));
    debug.assert(math.isNegativeInf(-infinite_f32));
    debug.assert(math.isNegativeInf(-infinite_f64));
    debug.assert(math.isNegativeInf(-infinite_f128));

    debug.assert(!math.isFinite(infinite_f16));
    debug.assert(!math.isFinite(infinite_f32));
    debug.assert(!math.isFinite(infinite_f64));
    // isFinite(f128) is not implemented.
    //debug.assert(!math.isFinite(infinite_f128));
}
