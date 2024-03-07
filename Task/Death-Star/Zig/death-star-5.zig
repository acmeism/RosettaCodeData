fn Sphere(comptime T: type) type {
    return struct {
        const Self = @This();
        cx: T,
        cy: T,
        cz: T,
        r: T,

        pub fn init(cx: T, cy: T, cz: T, r: T) Self {
            return Self{ .cx = cx, .cy = cy, .cz = cz, .r = r };
        }
        /// Check if a ray (x,y, -inf)->(x, y, inf) hits a sphere.
        /// If so, return the intersecting z values. z1 is closer to the eye.
        pub fn hit(self: *const Self, xx: T, yy: T) ?SphereHit(T) {
            const x = xx - self.cx;
            const y = yy - self.cy;
            const zsq = self.r * self.r - x * x - y * y;
            if (zsq >= 0) {
                const zsqrt = std.math.sqrt(zsq);
                return .{ .z1 = self.cz - zsqrt, .z2 = self.cz + zsqrt };
            }
            return null;
        }
    };
}
