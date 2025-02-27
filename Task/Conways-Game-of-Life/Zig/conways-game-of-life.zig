const std = @import("std");
const mem = std.mem;

pub fn main() !void {
    // ---------------------------- pseudo random number generator
    var prng = std.Random.DefaultPrng.init(blk: {
        var seed: u64 = undefined;
        std.posix.getrandom(mem.asBytes(&seed)) catch unreachable;
        break :blk seed;
    });
    const random = prng.random();
    // ----------------------------------------------------------
    const stdout = std.io.getStdOut();
    var bw = std.io.bufferedWriter(stdout.writer());
    const writer = bw.writer();
    // ----------------------------------------------------------
    var life = Life(80, 15).init(random);
    for (0..300) |_| {
        life.step();
        try writer.writeByte('\x0c');
        try writer.print("{}", .{life});
        try bw.flush();
        std.time.sleep(comptime (1_000_000_000 / 30)); // 1/30th second
    }
}
fn Life(comptime w: usize, comptime h: usize) type {
    return struct {
        const Self = @This();
        a: Field(w, h),
        b: Field(w, h),

        fn init(random: std.Random) Self {
            var life = Self{
                .a = Field(w, h).init(),
                .b = Field(w, h).init(),
            };
            for (0..w * h / 2) |_| {
                const x = random.uintLessThan(usize, w);
                const y = random.uintLessThan(usize, h);
                life.a.set(x, y, true);
            }
            return life;
        }
        fn step(self: *Self) void {
            for (0..h) |y|
                for (0..w) |x|
                    self.b.set(x, y, self.a.next(x, y));
            mem.swap(Field(w, h), &self.a, &self.b);
        }
        pub fn format(self: *const Self, comptime _: []const u8, _: std.fmt.FormatOptions, writer: anytype) !void {
            for (0..h) |y| {
                for (0..w) |x|
                    try writer.writeByte(if (self.a.state(x, y)) '*' else ' ');
                try writer.writeByte('\n');
            }
        }
    };
}
fn Field(comptime w: usize, comptime h: usize) type {
    return struct {
        const Self = @This();
        s: std.StaticBitSet(w * h),

        fn init() Self {
            return .{ .s = std.StaticBitSet(w * h).initEmpty() };
        }
        fn set(self: *Self, x: usize, y: usize, b: bool) void {
            self.s.setValue(y * w + x, b);
        }
        fn next(self: *const Self, x_: usize, y_: usize) bool {
            var on: usize = 0;
            // Use wraparound arithmetic, i.e. -%
            inline for ([3]usize{ x_ -% 1, x_, x_ + 1 }) |x|
                inline for ([3]usize{ y_ -% 1, y_, y_ + 1 }) |y|
                    if (self.state(x, y)) {
                        on += 1;
                    };
            return on == 3 or on == 2 and self.state(x_, y_);
        }
        fn state(self: *const Self, x: usize, y: usize) bool {
            if (x >= w or y >= h) return false;
            return self.s.isSet(y * w + x);
        }
    };
}
