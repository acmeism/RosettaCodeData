fn DeathStar(comptime T: type) type {
    return struct {
        const Self = @This();
        allocator: Allocator,
        w: usize,
        h: usize,
        img: ImageData(),

        const Hit = enum { background, neg, pos };

        pub fn init(allocator: Allocator) !Self {
            var dir = Vector(T).init(20, -40, 10);
            dir.normalize();
            // positive sphere and negative sphere
            const pos = Sphere(T).init(180, 240, 220, 120);
            const neg = Sphere(T).init(60, 150, 100, 100);

            const k: T = 1.5;
            const amb: T = 0.2;

            const w: usize = @intFromFloat(pos.r * 4);
            const h: usize = @intFromFloat(pos.r * 3);
            var img = try ImageData().init(allocator, "deathStar", w, h);

            var vec = Vector(T).zero();

            const start_y: usize = @intFromFloat(pos.cy - pos.r);
            const end_y: usize = @intFromFloat(pos.cy + pos.r);
            const start_x: usize = @intFromFloat(pos.cx - pos.r);
            const end_x: usize = @intFromFloat(pos.cx + pos.r);

            for (start_y..end_y + 1) |j| {
                for (start_x..end_x + 1) |i| {
                    const x: T = @floatFromInt(i);
                    const y: T = @floatFromInt(j);

                    const result_pos = pos.hit(x, y);
                    // ray lands in blank space, show bg
                    if (result_pos == null)
                        continue;

                    const zb1 = result_pos.?.z1;
                    const zb2 = result_pos.?.z2;

                    const result_neg = neg.hit(x, y);

                    switch (calcHit(result_neg, zb1, zb2)) {
                        .background => continue,
                        .neg => {
                            vec.x = neg.cx - x;
                            vec.y = neg.cy - y;
                            vec.z = neg.cz - result_neg.?.z2; // zs2
                        },
                        .pos => {
                            vec.x = x - pos.cx;
                            vec.y = y - pos.cy;
                            vec.z = zb1 - pos.cz;
                        },
                    }
                    vec.normalize();
                    var s = dir.dot(&vec);
                    if (s < 0) s = 0;
                    const lum = 255 * (std.math.pow(T, s, k) + amb) / (1 + amb);
                    const lumi: u8 = @intFromFloat(std.math.clamp(lum, 0, 255));
                    img.pset(i, j, Gray{ .w = lumi });
                }
            }
            return Self{ .allocator = allocator, .w = w, .h = h, .img = img };
        }
        pub fn deinit(self: *Self) void {
            self.img.deinit();
        }
        pub fn print(self: *Self, writer: anytype, optional_comments: ?[]const []const u8) !void {
            try self.img.print(writer, optional_comments);
        }
        /// Ray has hit the positive sphere.
        /// How does it intersect the negative sphere ?
        fn calcHit(neg_hit: ?SphereHit(T), zb1: T, zb2: T) Hit {
            if (neg_hit) |result| {
                const zs1 = result.z1;
                const zs2 = result.z2;
                if (zs1 > zb1) {
                    // ray hits both, but pos front surface is closer
                    return Hit.pos;
                } else if (zs2 > zb2) {
                    // pos sphere surface is inside neg sphere, show bg
                    return Hit.background;
                } else if (zs2 > zb1) {
                    // back surface on neg sphere is inside pos sphere,
                    // the only place where neg sphere surface will be shown
                    return Hit.neg;
                } else {
                    return Hit.pos;
                }
            } else {
                // ray hits pos sphere but not neg, draw pos sphere surface
                return Hit.pos;
            }
        }
    };
}
