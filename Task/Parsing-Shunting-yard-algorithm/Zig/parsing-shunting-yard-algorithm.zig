const std = @import("std");
const Allocator = std.mem.Allocator;

const Number = f64;

const Operator = struct {
    token: u8,
    operation: *const fn (Number, Number) Number,
    precedence: u8,
    is_left_associative: bool,

    fn apply(self: Operator, x: Number, y: Number) Number {
        return self.operation(x, y);
    }
};

const Token = union(enum) {
    digit: Number,
    operator: Operator,
    left_paren,
    right_paren,
};

fn opAdd(x: Number, y: Number) Number { return x + y; }
fn opSub(x: Number, y: Number) Number { return x - y; }
fn opMul(x: Number, y: Number) Number { return x * y; }
fn opDiv(x: Number, y: Number) Number { return x / y; }
fn opPow(x: Number, y: Number) Number { return std.math.pow(Number, x, y); }

fn makeOperator(
    token: u8,
    precedence: u8,
    is_left_associative: bool,
    operation: *const fn (Number, Number) Number,
) Token {
    return .{ .operator = .{
        .token = token,
        .operation = operation,
        .precedence = precedence,
        .is_left_associative = is_left_associative,
    } };
}

fn lexToken(c: u8) error{InvalidCharacter}!Token {
    return switch (c) {
        '0'...'9' => .{ .digit = @floatFromInt(c - '0') },
        '+' => makeOperator('+', 1, true,  &opAdd),
        '-' => makeOperator('-', 1, true,  &opSub),
        '*' => makeOperator('*', 2, true,  &opMul),
        '/' => makeOperator('/', 2, true,  &opDiv),
        '^' => makeOperator('^', 3, false, &opPow),
        '(' => .left_paren,
        ')' => .right_paren,
        else => error.InvalidCharacter,
    };
}

fn lex(allocator: Allocator, input: []const u8) !std.ArrayList(Token) {
    var tokens = std.ArrayList(Token).init(allocator);
    errdefer tokens.deinit();
    for (input) |c| {
        if (std.ascii.isWhitespace(c)) continue;
        try tokens.append(try lexToken(c));
    }
    return tokens;
}

fn tiltUntil(
    operators: *std.ArrayList(Token),
    output: *std.ArrayList(Token),
    stop: std.meta.Tag(Token),
) !bool {
    while (operators.items.len > 0) {
        const tok = operators.pop().?;
        if (std.meta.activeTag(tok) == stop) return true;
        try output.append(tok);
    }
    return false;
}

fn shuntingYard(allocator: Allocator, tokens: []const Token) !std.ArrayList(Token) {
    var output = std.ArrayList(Token).init(allocator);
    errdefer output.deinit();
    var operators = std.ArrayList(Token).init(allocator);
    defer operators.deinit();

    for (tokens) |token| {
        switch (token) {
            .digit      => try output.append(token),
            .left_paren => try operators.append(token),
            .operator   => |op| {
                while (operators.items.len > 0) {
                    switch (operators.getLast()) {
                        .left_paren => break,
                        .operator   => |top| {
                            const same_prec_left = (top.precedence == op.precedence and
                                                    op.is_left_associative);
                            if (top.precedence > op.precedence or same_prec_left) {
                                try output.append(operators.pop().?);
                            } else break;
                        },
                        else => unreachable,
                    }
                }
                try operators.append(token);
            },
            .right_paren => {
                if (!try tiltUntil(&operators, &output, .left_paren))
                    return error.MismatchedRightParen;
            },
        }
    }

    if (try tiltUntil(&operators, &output, .left_paren))
        return error.MismatchedLeftParen;

    std.debug.assert(operators.items.len == 0);
    return output;
}

fn calculate(allocator: Allocator, postfix: []const Token) !Number {
    var stack = std.ArrayList(Number).init(allocator);
    defer stack.deinit();

    for (postfix) |token| {
        switch (token) {
            .digit    => |n|  try stack.append(n),
            .operator => |op| {
                if (stack.items.len < 2) return error.MissingOperand;
                const y = stack.pop().?;
                const x = stack.pop().?;
                try stack.append(op.apply(x, y));
            },
            else => unreachable,
        }
    }

    std.debug.assert(stack.items.len == 1);
    return stack.pop().?;
}

// ── display helpers ───────────────────────────────────────────────────────────

fn printTokens(tokens: []const Token, writer: anytype) !void {
    for (tokens, 0..) |tok, i| {
        if (i != 0) try writer.writeByte(' ');
        switch (tok) {
            .digit      => |n| try writer.print("{d}", .{n}),
            .operator   => |op| try writer.writeByte(op.token),
            .left_paren  => try writer.writeByte('('),
            .right_paren => try writer.writeByte(')'),
        }
    }
}

// ── entry point ───────────────────────────────────────────────────────────────

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const ally = gpa.allocator();
    const out = std.io.getStdOut().writer();

    const input = "3 + 4 * 2 / ( 1 - 5 ) ^ 2 ^ 3";

    var infix = try lex(ally, input);
    defer infix.deinit();

    var postfix = try shuntingYard(ally, infix.items);
    defer postfix.deinit();

    try out.writeAll("infix:   ");
    try printTokens(infix.items, out);
    try out.writeByte('\n');

    try out.writeAll("postfix: ");
    try printTokens(postfix.items, out);
    try out.writeByte('\n');
}
