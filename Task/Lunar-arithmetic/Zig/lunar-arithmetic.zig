const std = @import("std");
const print = std.debug.print;
const ArrayList = std.ArrayList;
const HashMap = std.HashMap;
const Allocator = std.mem.Allocator;

const LunarError = error{
    InvalidArgument,
    OutOfMemory,
    InvalidCharacter,
    Overflow,
};

const Lunar = struct {
    text: []u8,
    allocator: Allocator,

    const Self = @This();

    pub fn init(allocator: Allocator, n: i64) LunarError!Self {
        if (n < 0) {
            return LunarError.InvalidArgument;
        }

        var buf: [32]u8 = undefined;
        const text = std.fmt.bufPrint(&buf, "{}", .{n}) catch return LunarError.Overflow;

        const owned_text = allocator.dupe(u8, text) catch return LunarError.OutOfMemory;

        return Self{
            .text = owned_text,
            .allocator = allocator,
        };
    }

    pub fn deinit(self: *Self) void {
        self.allocator.free(self.text);
    }

    pub fn clone(self: *const Self) LunarError!Self {
        const owned_text = self.allocator.dupe(u8, self.text) catch return LunarError.OutOfMemory;
        return Self{
            .text = owned_text,
            .allocator = self.allocator,
        };
    }

    pub fn add(self: *const Self, other: *const Self) LunarError!Self {
        const max_length = @max(self.text.len, other.text.len);

        var result = ArrayList(u8).init(self.allocator);
        defer result.deinit();

        var i: usize = 0;
        while (i < max_length) : (i += 1) {
            const a_idx = if (i < self.text.len) self.text.len - 1 - i else 0;
            const b_idx = if (i < other.text.len) other.text.len - 1 - i else 0;

            const a_char = if (i < self.text.len) self.text[a_idx] else '0';
            const b_char = if (i < other.text.len) other.text[b_idx] else '0';

            const max_char = @max(a_char, b_char);
            try result.append(max_char);
        }

        // Reverse the result
        const len = result.items.len;
        for (0..len / 2) |j| {
            const temp = result.items[j];
            result.items[j] = result.items[len - 1 - j];
            result.items[len - 1 - j] = temp;
        }

        const text_value = std.fmt.parseInt(i64, result.items, 10) catch return LunarError.InvalidCharacter;
        return Self.init(self.allocator, text_value);
    }

    pub fn multiply(self: *const Self, other: *const Self) LunarError!Self {
        var result = Self.init(self.allocator, 0) catch return LunarError.OutOfMemory;
        defer result.deinit();

        var i: usize = 0;
        while (i < other.text.len) : (i += 1) {
            const digit_idx = other.text.len - 1 - i;
            const digit = other.text[digit_idx];

            var row = ArrayList(u8).init(self.allocator);
            defer row.deinit();

            for (self.text) |c| {
                const min_char = @min(c, digit);
                try row.append(min_char);
            }

            // Add zeros for position
            for (0..i) |_| {
                try row.append('0');
            }

            const row_value = std.fmt.parseInt(i64, row.items, 10) catch return LunarError.InvalidCharacter;
            var row_lunar = Self.init(self.allocator, row_value) catch return LunarError.OutOfMemory;
            defer row_lunar.deinit();

            const new_result = result.add(&row_lunar) catch return LunarError.OutOfMemory;
            result.deinit();
            result = new_result;
        }

        return result.clone();
    }

    pub fn increment(self: *const Self) LunarError!Self {
        const value = std.fmt.parseInt(i64, self.text, 10) catch return LunarError.InvalidCharacter;
        return Self.init(self.allocator, value + 1);
    }

    pub fn getValue(self: *const Self) i64 {
        return std.fmt.parseInt(i64, self.text, 10) catch 0;
    }

    pub fn lessThan(self: *const Self, other: *const Self) bool {
        const self_val = self.getValue();
        const other_val = other.getValue();
        return self_val < other_val;
    }

    pub fn format(self: *const Self, comptime fmt: []const u8, options: std.fmt.FormatOptions, writer: anytype) !void {
        _ = fmt;
        _ = options;
        try writer.writeAll(self.text);
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const tests = [_][]const i64{
        &[_]i64{ 976, 348 },
        &[_]i64{ 23, 321 },
        &[_]i64{ 232, 35 },
        &[_]i64{ 123, 32192, 415, 8 },
    };

    for (tests) |my_test| {
        var add_result = Lunar.init(allocator, 0) catch return;
        defer add_result.deinit();

        var multiply_result = Lunar.init(allocator, 9) catch return;
        defer multiply_result.deinit();

        for (my_test, 0..) |value, i| {
            if (i > 0) {
                print(" 🌙 + ", .{});
            }
            print("{}", .{value});

            var lunar_value = Lunar.init(allocator, value) catch return;
            defer lunar_value.deinit();

            const new_add = add_result.add(&lunar_value) catch return;
            add_result.deinit();
            add_result = new_add;
        }
        print(" = {s}\n", .{add_result.text});

        for (my_test, 0..) |value, i| {
            if (i > 0) {
                print(" 🌙 x " , .{});
            }
            print("{}", .{value});

            var lunar_value = Lunar.init(allocator, value) catch return;
            defer lunar_value.deinit();

            const new_multiply = multiply_result.multiply(&lunar_value) catch return;
            multiply_result.deinit();
            multiply_result = new_multiply;
        }
        print(" = {s}\n", .{multiply_result.text});
        print("\n" , .{});
    }

    print("First 20 distinct lunar even numbers:\n" , .{});
    var evens = std.ArrayList(i64).init(allocator);
    defer evens.deinit();

    var n = Lunar.init(allocator, 0) catch return;
    defer n.deinit();

    var two = Lunar.init(allocator, 2) catch return;
    defer two.deinit();

    while (evens.items.len < 20) {
        var even = n.multiply(&two) catch return;
        defer even.deinit();

        const even_val = even.getValue();

        // Check if we already have this value
        var found = false;
        for (evens.items) |existing| {
            if (existing == even_val) {
                found = true;
                break;
            }
        }

        if (!found) {
            try evens.append(even_val);
        }

        const new_n = n.increment() catch return;
        n.deinit();
        n = new_n;
    }

    // Sort the evens
    std.sort.insertion(i64, evens.items, {}, std.sort.asc(i64));

    for (evens.items) |value| {
        print("{} ", .{value});
    }
    print("\n\n" , .{});

    print("First 20 lunar square numbers:\n" , .{});
    for (0..20) |i| {
        var lunar_i = Lunar.init(allocator, @intCast(i)) catch return;
        defer lunar_i.deinit();

        var square = lunar_i.multiply(&lunar_i) catch return;
        defer square.deinit();

        print("{s} ", .{square.text});
    }
    print("\n\n" , .{});

    print("First 20 lunar factorials:\n" , .{});
    var factorial = Lunar.init(allocator, 1) catch return;
    defer factorial.deinit();

    for (1..21) |i| {
        var lunar_i = Lunar.init(allocator, @intCast(i)) catch return;
        defer lunar_i.deinit();

        const new_factorial = factorial.multiply(&lunar_i) catch return;
        factorial.deinit();
        factorial = new_factorial;

        print("{s} ", .{factorial.text});
    }
    print("\n\n" , .{});

    var current = Lunar.init(allocator, 0) catch return;
    defer current.deinit();

    var next = Lunar.init(allocator, 1) catch return;
    defer next.deinit();

    while (true) {
        var current_square = current.multiply(&current) catch return;
        defer current_square.deinit();

        var next_square = next.multiply(&next) catch return;
        defer next_square.deinit();

        if (!current_square.lessThan(&next_square)) {
            break;
        }

        const new_current = next.clone() catch return;
        current.deinit();
        current = new_current;

        const new_next = next.increment() catch return;
        next.deinit();
        next = new_next;
    }

    print("First number whose lunar square is smaller than the previous: {s}\n", .{next.text});
}
