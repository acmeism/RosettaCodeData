const std = @import("std");
const math = std.math;
const print = std.debug.print;

const EllipticPoint = struct {
    x: f64,
    y: f64,

    const ZERO_THRESHOLD: f64 = 1e20;
    const B: f64 = 7.0; // the 'b' in y^2 = x^3 + a * x + b, where 'a' is 0

    /// Create a point that is initialized to Zero (point at infinity)
    pub fn new() EllipticPoint {
        return EllipticPoint{
            .x = 0.0,
            .y = ZERO_THRESHOLD * 1.01,
        };
    }

    /// Create a point based on the y-coordinate. For a curve with a = 0 and b = 7
    /// there is only one x for each y
    pub fn fromY(y_coordinate: f64) EllipticPoint {
        const y = y_coordinate;
        const x = math.cbrt(y * y - B);
        return EllipticPoint{ .x = x, .y = y };
    }

    /// Check if the point is zero (point at infinity)
    pub fn isZero(self: EllipticPoint) bool {
        // when the elliptic point is at zero, y = +/- infinity
        return @abs(self.y) >= ZERO_THRESHOLD;
    }

    /// Double the point (multiply by 2)
    pub fn double(self: *EllipticPoint) void {
        if (self.isZero()) {
            // doubling zero is still zero
            return;
        }

        // based on the property of the curve, the line going through the
        // current point and the negative doubled point is tangent to the
        // curve at the current point. wikipedia has a nice diagram.
        if (self.y == 0.0) {
            // at this point the tangent to the curve is vertical.
            // this point doubled is 0
            self.* = EllipticPoint.new();
        } else {
            const l = (3.0 * self.x * self.x) / (2.0 * self.y);
            const new_x = l * l - 2.0 * self.x;
            self.y = l * (self.x - new_x) - self.y;
            self.x = new_x;
        }
    }

    /// Negate the point
    pub fn neg(self: EllipticPoint) EllipticPoint {
        return EllipticPoint{
            .x = self.x,
            .y = -self.y,
        };
    }

    /// Add two points
    pub fn add(self: EllipticPoint, rhs: EllipticPoint) EllipticPoint {
        var result = self;
        result.addAssign(rhs);
        return result;
    }

    /// Add a point to this point (mutating)
    pub fn addAssign(self: *EllipticPoint, rhs: EllipticPoint) void {
        if (self.isZero()) {
            self.* = rhs;
        } else if (rhs.isZero()) {
            // since rhs is zero this point does not need to be modified
        } else {
            const l = (rhs.y - self.y) / (rhs.x - self.x);
            if (math.isFinite(l)) {
                const new_x = l * l - self.x - rhs.x;
                self.y = l * (self.x - new_x) - self.y;
                self.x = new_x;
            } else {
                if (math.signbit(self.y) != math.signbit(rhs.y)) {
                    // in this case rhs == -lhs, the result should be 0
                    self.* = EllipticPoint.new();
                } else {
                    // in this case rhs == lhs.
                    self.double();
                }
            }
        }
    }

    /// Subtract two points
    pub fn sub(self: EllipticPoint, rhs: EllipticPoint) EllipticPoint {
        return self.add(rhs.neg());
    }

    /// Subtract a point from this point (mutating)
    pub fn subAssign(self: *EllipticPoint, rhs: EllipticPoint) void {
        self.addAssign(rhs.neg());
    }

    /// Multiply point by an integer scalar
    pub fn mul(self: EllipticPoint, scalar: i32) EllipticPoint {
        var result = self;
        result.mulAssign(scalar);
        return result;
    }

    /// Multiply this point by an integer scalar (mutating)
    pub fn mulAssign(self: *EllipticPoint, scalar: i32) void {
        var r = EllipticPoint.new();
        var p = self.*;
        var rhs = scalar;

        if (rhs < 0) {
            // change p * -rhs to -p * rhs
            rhs = -rhs;
            p = p.neg();
        }

        var i: i32 = 1;
        while (i <= rhs) {
            if ((i & rhs) != 0) {
                r.addAssign(p);
            }
            p.double();
            i <<= 1;
        }

        self.* = r;
    }

    /// Format the point for printing
    pub fn format(
        self: EllipticPoint,
        comptime fmt: []const u8,
        options: std.fmt.FormatOptions,
        writer: anytype,
    ) !void {
        _ = fmt;
        _ = options;
        if (self.isZero()) {
            try writer.print("(Zero)", .{});
        } else {
            try writer.print("({d}, {d})", .{ self.x, self.y });
        }
    }
};

pub fn main() !void {
    const a = EllipticPoint.fromY(1.0);
    const b = EllipticPoint.fromY(2.0);

    print("a = {}\n", .{a});
    print("b = {}\n", .{b});

    const c = a.add(b);
    print("c = a + b = {}\n", .{c});
    print("a + b - c = {}\n", .{a.add(b).sub(c)});
    print("a + b - (b + a) = {}\n\n", .{a.add(b).sub(b.add(a))});

    print("a + a + a + a + a - 5 * a = {}\n", .{a.add(a).add(a).add(a).add(a).sub(a.mul(5))});
    print("a * 12345 = {}\n", .{a.mul(12345)});
    print("a * -12345 = {}\n", .{a.mul(-12345)});
    print("a * 12345 + a * -12345 = {}\n", .{a.mul(12345).add(a.mul(-12345))});
    print("a * 12345 - (a * 12000 + a * 345) = {}\n", .{a.mul(12345).sub(a.mul(12000).add(a.mul(345)))});
    print("a * 12345 - (a * 12001 + a * 345) = {}\n\n", .{a.mul(12345).sub(a.mul(12000).add(a.mul(344)))});

    const zero = EllipticPoint.new();
    var g = EllipticPoint.new();
    print("g = zero = {}\n", .{g});
    g.addAssign(a);
    print("g += a = {}\n", .{g});
    g.addAssign(zero);
    print("g += zero = {}\n", .{g});
    g.addAssign(b);
    print("g += b = {}\n", .{g});
    print("b + b - b * 2 = {}\n\n", .{b.add(b).sub(b.mul(2))});

    var special = EllipticPoint.fromY(0.0); // the point where the curve crosses the x-axis
    print("special = {}\n", .{special}); // this has the minimum possible value for x
    special.mulAssign(2);
    print("special *= 2 = {}\n", .{special}); // doubling it gives zero
}
