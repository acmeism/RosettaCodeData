const std = @import("std");
const math = std.math;
const print = std.debug.print;

const Vector = struct {
    x: f64,
    y: f64,
    z: f64,

    const Self = @This();

    pub fn new(x: f64, y: f64, z: f64) Self {
        return Self{ .x = x, .y = y, .z = z };
    }

    pub fn unitVector(self: Self) Self {
        const magnitude = math.sqrt(self.dotProduct(self));
        return self.scalarMultiply(1.0 / magnitude);
    }

    pub fn add(self: Self, other: Self) Self {
        return Self.new(self.x + other.x, self.y + other.y, self.z + other.z);
    }

    pub fn scalarMultiply(self: Self, value: f64) Self {
        return Self.new(self.x * value, self.y * value, self.z * value);
    }

    pub fn dotProduct(self: Self, other: Self) f64 {
        return self.x * other.x + self.y * other.y + self.z * other.z;
    }

    pub fn crossProduct(self: Self, other: Self) Self {
        return Self.new(
            self.y * other.z - self.z * other.y,
            self.z * other.x - self.x * other.z,
            self.x * other.y - self.y * other.x,
        );
    }

    pub fn rodriguesRotation(self: Self, vector: Self, angle: f64) Self {
        const axis = self.unitVector();
        const cos_angle = math.cos(angle);
        const sin_angle = math.sin(angle);
        const dot_product = axis.dotProduct(vector);

        return vector.scalarMultiply(cos_angle)
            .add(axis.crossProduct(vector).scalarMultiply(sin_angle))
            .add(axis.scalarMultiply(dot_product * (1.0 - cos_angle)));
    }

    pub fn display(self: Self) void {
        print("({d:.4}, {d:.4}, {d:.4})", .{ self.x, self.y, self.z });
    }
};

pub fn main() void {
    const axis = Vector.new(-1.0, 2.0, 1.0);
    const vector = Vector.new(2.5, -1.5, 3.0);

    print(" Angle         Rotated vector\n", .{});
    print("-----------------------------------\n", .{});

    var theta: f64 = 0.0;
    while (theta <= 2.0 * math.pi) {
        const result = axis.rodriguesRotation(vector, theta);
        print("{d:.4}    ", .{theta});
        result.display();
        print("\n", .{});
        theta += math.pi / 5.0;
    }
}
