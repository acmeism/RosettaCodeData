const std = @import("std");
const print = std.debug.print;
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

// Return the Sturmian word for the strictly positive rational number m / n
fn sturmianWordRational(allocator: Allocator, m: u32, n: u32) !ArrayList(u8) {
    if (m > n) {
        var inverse = try sturmianWordRational(allocator, n, m);
        defer inverse.deinit();

        var result = ArrayList(u8).init(allocator);
        for (inverse.items) |ch| {
            try result.append(if (ch == '0') '1' else '0');
        }
        return result;
    }

    var sturmian = ArrayList(u8).init(allocator);
    var k: u32 = 1;

    while ((k * m) % n != 0) {
        const previous_floor = ((k - 1) * m) / n;
        const current_floor = (k * m) / n;

        if (previous_floor == current_floor) {
            try sturmian.append('0');
        } else {
            try sturmian.append('1');
            try sturmian.append('0');
        }
        k += 1;
    }

    return sturmian;
}

// Return the first 'letter_count' letters of Sturmian word for the strictly positive real number
// ( b * √(a) + m ) / n, where a is not a perfect square
fn sturmianWordQuadratic(allocator: Allocator, b: i32, a: u32, m: i32, n: i32, letter_count: u32) !ArrayList(u8) {
    var p = ArrayList(u32).init(allocator);
    defer p.deinit();
    var q = ArrayList(u32).init(allocator);
    defer q.deinit();

    try p.append(0);
    try p.append(1);
    try q.append(1);
    try q.append(0);

    var remainder = (@as(f64, @floatFromInt(b)) * @sqrt(@as(f64, @floatFromInt(a))) + @as(f64, @floatFromInt(m))) / @as(f64, @floatFromInt(n));

    var i: u32 = 1;
    while (i <= letter_count) : (i += 1) {
        const integer_part = @as(i32, @intFromFloat(@floor(remainder)));
        const fraction_part = remainder - @as(f64, @floatFromInt(integer_part));

        const pn = @as(u32, @intCast(integer_part * @as(i32, @intCast(p.items[p.items.len - 1])) + @as(i32, @intCast(p.items[p.items.len - 2]))));
        const qn = @as(u32, @intCast(integer_part * @as(i32, @intCast(q.items[q.items.len - 1])) + @as(i32, @intCast(q.items[q.items.len - 2]))));

        try p.append(pn);
        try q.append(qn);
        remainder = 1.0 / fraction_part;
    }

    return sturmianWordRational(allocator, p.items[p.items.len - 1], q.items[q.items.len - 1]);
}

// Return the Fibonacci word for the given integer
// For more information visit https://en.wikipedia.org/wiki/Fibonacci_word
fn fibonacciWord(allocator: Allocator, number: u32) !ArrayList(u8) {
    if (number == 0) {
        return ArrayList(u8).init(allocator);
    }
    if (number == 1) {
        var result = ArrayList(u8).init(allocator);
        try result.append('0');
        return result;
    }

    var previous = ArrayList(u8).init(allocator);
    defer previous.deinit();
    try previous.append('0');

    var result = ArrayList(u8).init(allocator);
    try result.append('0');
    try result.append('1');

    var i: u32 = 2;
    while (i < number) : (i += 1) {
        var temp = try result.clone();
        defer temp.deinit();

        try result.appendSlice(previous.items);

        previous.clearAndFree();
        previous = try temp.clone();
    }

    return result;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Test sturmian word rational
    var sturmian = try sturmianWordRational(allocator, 13, 21);
    defer sturmian.deinit();
    print("{s} from rational number 13 / 21\n", .{sturmian.items});

    // Test quadratic sturmian word
    var quadratic_result = try sturmianWordQuadratic(allocator, 1, 5, -1, 2, 8);
    defer quadratic_result.deinit();
    print("{s} from real number ( √5 - 1 ) / 2, the first 8 letters\n", .{quadratic_result.items});

    // Test fibonacci word
    var fibonacci = try fibonacciWord(allocator, 10);
    defer fibonacci.deinit();

    // Compare sturmian and fibonacci words
    const min_len = @min(sturmian.items.len, fibonacci.items.len);
    const sturmian_equals_fibonacci = std.mem.eql(u8, sturmian.items[0..min_len], fibonacci.items[0..min_len]);
    print("Sturmian word equals Fibonacci word? : {}\n", .{sturmian_equals_fibonacci});
}
