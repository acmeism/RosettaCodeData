fn Vector(comptime T: type) type {
    return struct {
        const Self = @This();
        x: T,
        y: T,
        z: T,

        pub fn init(x: T, y: T, z: T) Self {
            return Self{ .x = x, .y = y, .z = z };
        }
        pub fn zero() Self {
            return Self{ .x = 0.0, .y = 0.0, .z = 0.0 };
        }
        fn dot(a: *const Self, b: *const Self) T {
            return a.x * b.x + a.y * b.y + a.z * b.z;
        }
        fn length(self: *const Self) T {
            return std.math.sqrt(self.dot(self));
        }
        pub fn normalize(self: *Self) void {
            const inv_length = 1 / self.length();
            self.*.x *= inv_length;
            self.*.y *= inv_length;
            self.*.z *= inv_length;
        }
    };
}
