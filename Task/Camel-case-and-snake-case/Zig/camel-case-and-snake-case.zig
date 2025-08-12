const std = @import("std");
const print = std.debug.print;
const ArrayList = std.ArrayList;

const HYPHEN: u8 = '-';
const SPACE: u8 = ' ';
const UNDERSCORE: u8 = '_';
const WHITESPACE = " \n\r\t\x0C\x0B";

fn isWhitespace(ch: u8) bool {
    for (WHITESPACE) |ws| {
        if (ch == ws) return true;
    }
    return false;
}

fn leftTrim(text: []const u8) []const u8 {
    var start: usize = 0;
    while (start < text.len and isWhitespace(text[start])) {
        start += 1;
    }
    return text[start..];
}

fn rightTrim(text: []const u8) []const u8 {
    var end: usize = text.len;
    while (end > 0 and isWhitespace(text[end - 1])) {
        end -= 1;
    }
    return text[0..end];
}

fn trim(text: []const u8) []const u8 {
    return rightTrim(leftTrim(text));
}

fn prepareForConversion(allocator: std.mem.Allocator, text: []const u8) ![]u8 {
    const trimmed = trim(text);
    var result = try ArrayList(u8).initCapacity(allocator, trimmed.len);
    defer result.deinit();

    for (trimmed) |ch| {
        if (ch == SPACE or ch == HYPHEN) {
            try result.append(UNDERSCORE);
        } else {
            try result.append(ch);
        }
    }

    return result.toOwnedSlice();
}

fn toSnakeCase(allocator: std.mem.Allocator, camel: []const u8) ![]u8 {
    const text = try prepareForConversion(allocator, camel);
    defer allocator.free(text);

    var snake = ArrayList(u8).init(allocator);
    defer snake.deinit();

    var first = true;

    for (text) |ch| {
        if (first) {
            try snake.append(ch);
            first = false;
        } else if (std.ascii.isUpper(ch)) {
            if (snake.items.len > 0 and snake.items[snake.items.len - 1] == UNDERSCORE) {
                try snake.append(std.ascii.toLower(ch));
            } else {
                try snake.append(UNDERSCORE);
                try snake.append(std.ascii.toLower(ch));
            }
        } else {
            try snake.append(ch);
        }
    }

    return snake.toOwnedSlice();
}

fn toCamelCase(allocator: std.mem.Allocator, snake: []const u8) ![]u8 {
    const text = try prepareForConversion(allocator, snake);
    defer allocator.free(text);

    var camel = ArrayList(u8).init(allocator);
    defer camel.deinit();

    var underscore = false;

    for (text) |ch| {
        if (ch == UNDERSCORE) {
            underscore = true;
        } else if (underscore) {
            try camel.append(std.ascii.toUpper(ch));
            underscore = false;
        } else {
            try camel.append(ch);
        }
    }

    return camel.toOwnedSlice();
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const variable_names = [_][]const u8{
        "snakeCase",
        "snake_case",
        "variable_10_case",
        "variable10Case",
        "ergo rE tHis",
        "hurry-up-joe!",
        "c://my-docs/happy_Flag-Day/12.doc",
        "  spaces  "
    };

    print("{s:>48}\n", .{"=== To snake_case ==="});
    for (variable_names) |text| {
        const snake = try toSnakeCase(allocator, text);
        defer allocator.free(snake);
        print("{s:>34} --> {s}\n", .{ text, snake });
    }

    print("\n", .{});
    print("{s:>48}\n", .{"=== To camelCase ==="});
    for (variable_names) |text| {
        const camel = try toCamelCase(allocator, text);
        defer allocator.free(camel);
        print("{s:>34} --> {s}\n", .{ text, camel });
    }
}
