fn ImageData() type {
    return struct {
        const Self = @This();
        allocator: Allocator,
        name: []const u8,
        w: usize,
        h: usize,
        image: []Gray,

        pub fn init(allocator: Allocator, name: []const u8, w: usize, h: usize) !Self {
            const image = try allocator.alloc(Gray, h * w);
            // black background fill
            for (image) |*pixel| pixel.* = Gray.black;
            return Self{ .allocator = allocator, .image = image, .name = name, .w = w, .h = h };
        }
        pub fn deinit(self: *Self) void {
            self.allocator.free(self.image);
        }
        pub fn pset(self: *Self, x: usize, y: usize, gray: Gray) void {
            self.image[x * self.w + y] = gray;
        }
        /// Write PGM P2 ASCII to 'writer'
        pub fn print(self: *const Self, writer: anytype, optional_comments: ?[]const []const u8) !void {
            try writer.print("P2\n", .{});

            if (optional_comments) |lines| {
                for (lines) |line|
                    try writer.print("# {s}\n", .{line});
            }

            try writer.print("{d} {d}\n{d}\n", .{ self.w, self.h, 255 });

            for (self.image, 0..) |pixel, i| {
                const sep = if (i % self.w == self.w - 1) "\n" else " ";
                try writer.print("{d}{s}", .{ pixel.w, sep });
            }
        }
    };
}
