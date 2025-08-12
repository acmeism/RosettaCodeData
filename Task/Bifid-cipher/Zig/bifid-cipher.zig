const std = @import("std");

const Point = struct {
    row: i32,
    col: i32,
};

const Bifid = struct {
    grid: [][]u8,
    coordinates: std.AutoHashMap(u8, Point),
    n: i32,
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator, n: i32, text: []const u8) !*Bifid {
        if (text.len != @as(usize, @intCast(n * n))) {
            return error.IncorrectLength;
        }

        var self = try allocator.create(Bifid);
        self.* = .{
            .grid = try allocator.alloc([]u8, @intCast(n)),
            .coordinates = std.AutoHashMap(u8, Point).init(allocator),
            .n = n,
            .allocator = allocator,
        };

        for (0..@intCast(n)) |i| {
            self.grid[i] = try allocator.alloc(u8, @intCast(n));
        }

        var row: i32 = 0;
        var col: i32 = 0;

        for (text) |ch| {
            self.grid[@intCast(row)][@intCast(col)] = ch;
            try self.coordinates.put(ch, .{ .row = row, .col = col });

            col += 1;
            if (col == n) {
                col = 0;
                row += 1;
            }
        }

        if (n == 5) {
            // Handle I/J as the same letter in traditional 5x5 grid
            if (self.coordinates.get('I')) |i_coords| {
                try self.coordinates.put('J', i_coords);
            }
        }

        return self;
    }

    pub fn deinit(self: *Bifid) void {
        for (self.grid) |row| {
            self.allocator.free(row);
        }
        self.allocator.free(self.grid);
        self.coordinates.deinit();
        self.allocator.destroy(self);
    }

    pub fn encrypt(self: *const Bifid, text: []const u8, allocator: std.mem.Allocator) ![]u8 {
        var row_one = std.ArrayList(i32).init(allocator);
        defer row_one.deinit();
        var row_two = std.ArrayList(i32).init(allocator);
        defer row_two.deinit();

        for (text) |ch| {
            if (self.coordinates.get(ch)) |coordinate| {
                try row_one.append(coordinate.row);
                try row_two.append(coordinate.col);
            }
        }

        // Extend row_one with all elements from row_two
        for (row_two.items) |col| {
            try row_one.append(col);
        }

        var result = std.ArrayList(u8).init(allocator);
        var i: usize = 0;
        while (i < row_one.items.len - 1) : (i += 2) {
            const r = @as(usize, @intCast(row_one.items[i]));
            const c = @as(usize, @intCast(row_one.items[i + 1]));
            try result.append(self.grid[r][c]);
        }

        return result.toOwnedSlice();
    }

    pub fn decrypt(self: *const Bifid, text: []const u8, allocator: std.mem.Allocator) ![]u8 {
        var row = std.ArrayList(i32).init(allocator);
        defer row.deinit();

        for (text) |ch| {
            if (self.coordinates.get(ch)) |coordinate| {
                try row.append(coordinate.row);
                try row.append(coordinate.col);
            }
        }

        const middle = row.items.len / 2;

        var result = std.ArrayList(u8).init(allocator);

        for (0..middle) |i| {
            const r = @as(usize, @intCast(row.items[i]));
            const c = @as(usize, @intCast(row.items[i + middle]));
            try result.append(self.grid[r][c]);
        }

        return result.toOwnedSlice();
    }

    pub fn display(self: *const Bifid) void {
        for (self.grid) |row| {
            for (row) |ch| {
                std.debug.print("{c} ", .{ch});
            }
            std.debug.print("\n", .{});
        }
    }
};

fn runTest(bifid: *const Bifid, message: []const u8, allocator: std.mem.Allocator) !void {
    std.debug.print("Using Polybius square:\n", .{});
    bifid.display();
    std.debug.print("Message:   {s}\n", .{message});

    const encrypted = try bifid.encrypt(message, allocator);
    defer allocator.free(encrypted);
    std.debug.print("Encrypted: {s}\n", .{encrypted});

    const decrypted = try bifid.decrypt(encrypted, allocator);
    defer allocator.free(decrypted);
    std.debug.print("Decrypted: {s}\n\n", .{decrypted});
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const message1 = "ATTACKATDAWN";
    const message2 = "FLEEATONCE";
    const message3 = "THEINVASIONWILLSTARTONTHEFIRSTOFJANUARY";

    const bifid1 = try Bifid.init(allocator, 5, "ABCDEFGHIKLMNOPQRSTUVWXYZ");
    defer bifid1.deinit();

    const bifid2 = try Bifid.init(allocator, 5, "BGWKZQPNDSIOAXEFCLUMTHYVR");
    defer bifid2.deinit();

    try runTest(bifid1, message1, allocator);
    try runTest(bifid2, message2, allocator);
    try runTest(bifid2, message1, allocator);
    try runTest(bifid1, message2, allocator);

    const bifid3 = try Bifid.init(allocator, 6, "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789");
    defer bifid3.deinit();
    try runTest(bifid3, message3, allocator);
}
