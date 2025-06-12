const std = @import("std");
const rand = std.Random;
// (hint: errors cannot be handled at comptime)
var stdout: std.fs.File.Writer = undefined;
var stdin: std.fs.File.Reader = undefined;

fn opType(x: u8) i32 {
    return switch (x) {
        '-', '+' => 1,
        '/', '*' => 2,
        '(', ')' => -1,
        else => 0,
    };
}

fn toRpn(allocator: std.mem.Allocator, input: []const u8) ![]u8 {
    var rpnString = std.ArrayList(u8).init(allocator);
    defer rpnString.deinit();

    var rpnStack = std.ArrayList(u8).init(allocator);
    defer rpnStack.deinit();

    var lastToken: u8 = '#';

    for (input) |token| {
        if (token >= '1' and token <= '9') {
            try rpnString.append(token);
        } else if (opType(token) == 0) {
            continue;
        } else if (opType(token) > opType(lastToken) or token == '(') {
            try rpnStack.append(token);
            lastToken = token;
        } else {
            while (rpnStack.items.len > 0) {
                const top = rpnStack.pop().?;
                if (top == '(') {
                    break;
                }
                try rpnString.append(top);
            }
            if (token != ')') {
                try rpnStack.append(token);
            }
        }
    }

    while (rpnStack.items.len > 0) {
        try rpnString.append(rpnStack.pop().?);
    }

    if (rpnString.items.len > 0) {
        try stdout.print("your formula results in {s}\n", .{rpnString.items});
    } else {
        stdout.print("no input available.\n", .{}) catch {};
    }

    return rpnString.toOwnedSlice();
}

fn calculate(input: []const u8, list: *[4]u32) f32 {
    var stack = std.ArrayList(f32).init(std.heap.page_allocator);
    defer stack.deinit();

    var accumulator: f32 = 0.0;

    for (input) |token| {
        if (token >= '1' and token <= '9') {
            const digit = @as(u32, token - '0');

            // Find and mark the used digit
            var found = false;
            for (list, 0..) |val, idx| {
                if (val == digit) {
                    list[idx] = 10;
                    found = true;
                    break;
                }
            }

            if (!found) {
                stdout.print(" invalid digit: {d} \n", .{digit}) catch {};
            }

            stack.append(accumulator) catch {};
            accumulator = @floatFromInt(digit);
        } else {
            const a = stack.pop().?;

            accumulator = switch (token) {
                '-' => a - accumulator,
                '+' => a + accumulator,
                '/' => a / accumulator,
                '*' => a * accumulator,
                else => accumulator, // NOP
            };
        }
    }

    stdout.print("your formula results in {d}\n", .{accumulator}) catch {};
    return accumulator;
}

pub fn main() !void {
    stdout = std.io.getStdOut().writer();
    stdin = std.io.getStdIn().reader();
    var prng = rand.DefaultPrng.init(@as(u64, @intCast(std.time.timestamp())));
    const random = prng.random();
    // only values from 1 --> 9 (inclusive)
    var list = [_]u32{
        @mod(random.int(u32), 9) + 1,
        @mod(random.int(u32), 9) + 1,
        @mod(random.int(u32), 9) + 1,
        @mod(random.int(u32), 9) + 1,
    };

    try stdout.print("form 24 with using + - / * {d} {d} {d} {d}\n", .{ list[0], list[1], list[2], list[3] });

    // Get user input
    var buffer: [1024]u8 = undefined;
    const input = try stdin.readUntilDelimiterOrEof(buffer[0..], '\n') orelse "";

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    // Convert to RPN
    const rpnInput = try toRpn(allocator, input);
    if (rpnInput.len == 0) {
        stdout.print("exit.\n", .{}) catch {};
        return;
    }

    const result = calculate(rpnInput, &list);

    var allUsed = true;
    for (list) |val| {
        if (val != 10) {
            allUsed = false;
            break;
        }
    }

    if (allUsed) {
        try stdout.print("and you used all numbers\n", .{});
        if (result == 24.0) {
            try stdout.print("you won\n", .{});
        } else {
            try stdout.print("but your formula doesn't result in 24\n", .{});
        }
    } else {
        try stdout.print("you didn't use all the numbers\n", .{});
    }
}
