const std = @import("std");

const math = std.math;

test "infinity" {
    const expect = std.testing.expect;

    const float_types = [_]type{ f16, f32, f64, f80, f128, c_longdouble };
    inline for (float_types) |T| {
        const infinite_value: T = comptime std.math.inf(T);

        try expect(math.isInf(infinite_value));
        try expect(math.isPositiveInf(infinite_value));
        try expect(!math.isNegativeInf(infinite_value));
        try expect(!math.isFinite(infinite_value));
    }
}
