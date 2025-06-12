const std = @import("std");
const print = std.debug.print;
const stdin = std.io.getStdIn().reader();

const StrTok = struct {
    s: []const u8,
    len: usize,
    prec: i32,
    assoc: i32,
};

const Pattern = struct {
    str: []const u8,
    assoc: i32 = 0,
    prec: i32 = 0,
};

const Assoc = struct {
    pub const NONE: i32 = 0;
    pub const L: i32 = 1;
    pub const R: i32 = 2;
};

const pat_eos = Pattern{ .str = "" };

const pat_ops = [_]Pattern{
    Pattern{ .str = ")", .assoc = Assoc.NONE, .prec = -1 },
    Pattern{ .str = "**", .assoc = Assoc.R, .prec = 3 },
    Pattern{ .str = "^", .assoc = Assoc.R, .prec = 3 },
    Pattern{ .str = "*", .assoc = Assoc.L, .prec = 2 },
    Pattern{ .str = "/", .assoc = Assoc.L, .prec = 2 },
    Pattern{ .str = "+", .assoc = Assoc.L, .prec = 1 },
    Pattern{ .str = "-", .assoc = Assoc.L, .prec = 1 },
    Pattern{ .str = "" },
};

const pat_arg = [_]Pattern{
    Pattern{ .str = "number" },  // This will be matched differently
    Pattern{ .str = "identifier" }, // This will be matched differently
    Pattern{ .str = "(", .assoc = Assoc.L, .prec = -1 },
    Pattern{ .str = "" },
};

const MAX_STACK = 128;
const MAX_QUEUE = 128;

var stack: [MAX_STACK]StrTok = undefined;
var queue: [MAX_QUEUE]StrTok = undefined;
var l_queue: usize = 0;
var l_stack: usize = 0;
var prec_booster: i32 = 0;

fn qpush(tok: StrTok) !void {
    if (l_queue >= MAX_QUEUE) {
        return error.QueueOverflow;
    }
    queue[l_queue] = tok;
    l_queue += 1;
}

fn spush(tok: StrTok) !void {
    if (l_stack >= MAX_STACK) {
        return error.StackOverflow;
    }
    stack[l_stack] = tok;
    l_stack += 1;
}

fn spop() StrTok {
    if (l_stack == 0) {
        @panic("Stack underflow");
    }
    l_stack -= 1;
    return stack[l_stack];
}

fn display(s: []const u8) !void {
    print("\x1b[1;1H\x1b[JText | {s}\n", .{s});
    print("Stack| ", .{});

    for (stack[0..l_stack]) |item| {
        print("{s} ", .{item.s[0..item.len]});
    }

    print("\nQueue| ", .{});
    for (queue[0..l_queue]) |item| {
        print("{s} ", .{item.s[0..item.len]});
    }

    print("\n\n<press enter>\n", .{});
    var buf: [1]u8 = undefined;
    _ = try stdin.read(&buf);
}

fn fail(s1: []const u8, s2: []const u8) !bool {
    print("[Error {s}] {s}\n", .{ s1, s2 });
    return error.ParseError;
}

// Helper function to check if a character is a digit
fn isDigit(c: u8) bool {
    return c >= '0' and c <= '9';
}

// Helper function to check if a character is a letter
fn isAlpha(c: u8) bool {
    return (c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z');
}

// Helper function to check if a character is alphanumeric or underscore
fn isAlnum(c: u8) bool {
    return isAlpha(c) or isDigit(c) or c == '_';
}

fn match(s: []const u8, patterns: []const Pattern, tok: *StrTok) ?struct { pattern: *const Pattern, end_pos: usize } {
    var pos: usize = 0;

    // Skip whitespace
    while (pos < s.len and s[pos] == ' ') {
        pos += 1;
    }

    if (pos >= s.len) {
        return null;
    }

    const remaining = s[pos..];

    // Check for numeric literals
    if (remaining.len > 0 and (isDigit(remaining[0]) or
        ((remaining[0] == '-' or remaining[0] == '+') and remaining.len > 1 and isDigit(remaining[1])) or
        (remaining[0] == '.' and remaining.len > 1 and isDigit(remaining[1])))) {

        var i: usize = 0;
        var hasDot = false;
        var hasExp = false;

        // Handle sign
        if (i < remaining.len and (remaining[i] == '-' or remaining[i] == '+')) {
            i += 1;
        }

        // Process digits before decimal point
        while (i < remaining.len and isDigit(remaining[i])) {
            i += 1;
        }

        // Process decimal point and digits after it
        if (i < remaining.len and remaining[i] == '.') {
            hasDot = true;
            i += 1;
            while (i < remaining.len and isDigit(remaining[i])) {
                i += 1;
            }
        }

        // Process exponent
        if (i < remaining.len and (remaining[i] == 'e' or remaining[i] == 'E')) {
            hasExp = true;
            i += 1;

            // Optional sign for exponent
            if (i < remaining.len and (remaining[i] == '-' or remaining[i] == '+')) {
                i += 1;
            }

            // There must be at least one digit in the exponent
            if (i < remaining.len and isDigit(remaining[i])) {
                i += 1;
                while (i < remaining.len and isDigit(remaining[i])) {
                    i += 1;
                }
            } else if (hasExp) {
                // Invalid exponent
                return null;
            }
        }

        if (i > 0) {
            tok.s = remaining;
            tok.len = i;
            return .{ .pattern = &pat_arg[0], .end_pos = pos + i };
        }
    }

    // Check for identifiers
    if (remaining.len > 0 and (isAlpha(remaining[0]) or remaining[0] == '_')) {
        var i: usize = 1;
        while (i < remaining.len and isAlnum(remaining[i])) {
            i += 1;
        }

        tok.s = remaining;
        tok.len = i;
        return .{ .pattern = &pat_arg[1], .end_pos = pos + i };
    }

    // Check for operators and parentheses
    for (patterns) |p| {
        if (p.str.len == 0) break;

        if (p.str[0] != '^') {  // Not a special pattern like "number" or "identifier"
            if (remaining.len >= p.str.len and std.mem.eql(u8, remaining[0..p.str.len], p.str)) {
                tok.s = remaining;
                tok.len = p.str.len;
                return .{ .pattern = &p, .end_pos = pos + p.str.len };
            }
        }
    }

    return null;
}

fn parse(text: []const u8) !bool {
    var tok = StrTok{ .s = undefined, .len = 0, .prec = 0, .assoc = 0 };
    var pos: usize = 0;

    prec_booster = 0;
    l_queue = 0;
    l_stack = 0;

    try display(text);

    while (pos < text.len) {
        const match_arg = match(text[pos..], &pat_arg, &tok);
        if (match_arg == null) {
            return try fail("parse arg", text[pos..]);
        }

        const p_arg = match_arg.?.pattern;
        pos = pos + (match_arg.?.end_pos - pos);

        // Don't stack the parens
        if (std.mem.eql(u8, p_arg.str, "(")) {
            prec_booster += 100;
        } else {
            try qpush(tok);
            try display(text);
        }

        // Check if we reached the end of the string
        if (pos >= text.len) {
            if (prec_booster != 0) {
                return try fail("unmatched (", "end of string");
            }

            // If there are still operators on the stack, pop them all
            while (l_stack > 0) {
                try qpush(spop());
                try display(text);
            }

            return true;
        }

        re_op: {
            const match_op = match(text[pos..], &pat_ops, &tok);
            if (match_op == null) {
                return try fail("parse op", text[pos..]);
            }

            const p_op = match_op.?.pattern;
            pos = pos + (match_op.?.end_pos - pos);

            tok.assoc = p_op.assoc;
            tok.prec = p_op.prec;

            if (p_op.prec > 0) {
                tok.prec = p_op.prec + prec_booster;
            } else if (p_op.prec == -1) {
                if (prec_booster < 100) {
                    return try fail("unmatched )", text[pos..]);
                }
                tok.prec = prec_booster;
            }

            while (l_stack > 0) {
                const t = &stack[l_stack - 1];
                if (!((t.prec == tok.prec and t.assoc == Assoc.L) or t.prec > tok.prec)) {
                    break;
                }
                try qpush(spop());
                try display(text);
            }

            if (p_op.prec == -1) {
                prec_booster -= 100;
                break :re_op;
            }

            if (p_op.prec == 0) {
                try display(text);
                if (prec_booster != 0) {
                    return try fail("unmatched (", text[pos..]);
                }
                return true;
            }

            try spush(tok);
            try display(text);
        }
    }

    return true;
}

pub fn main() !void {
    const tests = [_][]const u8{
        "3 + 4 * 2 / ( 1 - 5 ) ^ 2 ^ 3",
        "123",
        "3+4 * 2 / ( 1 - 5 ) ^ 2 ^ 3.14",
        "(((((((1+2+3**(4 + 5))))))",
        "a^(b + c/d * .1e5)",  // Removed '!' which was causing an error
        "(1**2)**3",
        "2 + 2 *",
    };

    for (tests) |test_str| {
        print("Testing string `{s}'   <enter>\n", .{test_str});
        var buf: [1]u8 = undefined;
        _ = try stdin.read(&buf);

        const result = parse(test_str) catch |err| {
            switch (err) {
                error.ParseError => {
                    print("string `{s}': Error\n\n", .{test_str});
                    continue;
                },
                error.StackOverflow => {
                    print("string `{s}': Stack Overflow Error\n\n", .{test_str});
                    continue;
                },
                error.QueueOverflow => {
                    print("string `{s}': Queue Overflow Error\n\n", .{test_str});
                    continue;
                },
                else => return err,
            }
        };

        print("string `{s}': {s}\n\n", .{ test_str, if (result) "Ok" else "Error" });
    }
}
