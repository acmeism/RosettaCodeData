// infix.zig
const std = @import("std");
const Allocator = std.mem.Allocator;
const Stack = @import("common.zig").Stack;
const Node = @import("common.zig").Node;
const PostfixToken = @import("common.zig").PostfixToken;
const calculate = @import("common.zig").calculate;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const stdout = std.io.getStdOut().writer();

    const node = try infix(allocator, stdout, 18, "((((10+2)*6+8)*6+4)*8+4)*8+6");

    std.debug.assert(10 == node.res());
    std.debug.assert(18 == node.voltage);
    std.debug.assert(1.8 == node.current());
    std.debug.assert(@abs(32.4 - node.effect()) < 0.05);
    std.debug.assert(.serial == node.node_type);

    node.destroyDescendants(allocator);
    allocator.destroy(node);
}

// Zig tagged union.
const InfixToken = union(enum) {
    lparen,
    rparen,
    serial, // +
    parallel, // *

    // Slice of digits from parent string.
    // Do not let the parent string go out of scope while this is in scope.
    resistor: []const u8,
};

/// Convert infix expression 's' to postfix and call the postfix calculate()
fn infix(allocator: Allocator, writer: anytype, voltage: f32, s: []const u8) !*Node {
    // parse infix expression
    const infix_tokens: []InfixToken = try parse(allocator, s);
    defer allocator.free(infix_tokens);

    // convert infix to postfix
    const postfix_tokens: []PostfixToken = try shuntPostfix(allocator, infix_tokens);
    defer allocator.free(postfix_tokens);

    // use postfix calculate()
    return try calculate(allocator, writer, voltage, postfix_tokens);
}

const InfixParseError = error{
    UnexpectedCharacter,
};

/// Parse infix expression 's' to give a slice of InfixToken.
/// Caller owns slice memory on return.
/// There are no Zig language semantics to indicate ownership or transferal thereof.
fn parse(allocator: Allocator, s: []const u8) ![]InfixToken {
    var tokens = std.ArrayList(InfixToken).init(allocator);
    // defer tokens.deinit(); // not needed, toOwnedSlice() owns memory.

    var slice_start: ?usize = null;

    for (s, 0..) |ch, i| {
        const token: InfixToken = switch (ch) {
            '(' => InfixToken.lparen,
            ')' => InfixToken.rparen,
            '+' => InfixToken.serial,
            '*' => InfixToken.parallel,
            '0'...'9' => {
                // Add digits to 'resistor' value.
                // 'slice_start' determines if any digit(s) have already been parsed.
                if (slice_start) |_| _ = tokens.pop() else slice_start = i;
                const slice_end = i + 1;
                try tokens.append(InfixToken{ .resistor = s[slice_start.?..slice_end] });
                continue;
            },
            ' ', '\t' => { // extraneous whitespace
                slice_start = null;
                continue;
            },
            else => return InfixParseError.UnexpectedCharacter, // unknown
        };
        try tokens.append(token);
        // Last token was not a resistor. Reset 'start_slice'.
        slice_start = null;
    }
    return tokens.toOwnedSlice();
}

const ShuntPostfixError = error{
    LParenNotAllowed,
    RParenNotAllowed,
};

/// Input infix (infix tokens) in infix order.
/// Output postfix (postfix tokens) in postfix order.
///
/// Caller owns resultant slice and is responsible for freeing.
fn shuntPostfix(allocator: Allocator, infix_tokens: []InfixToken) ![]PostfixToken {
    var result = PostfixTokenArray.init(allocator); // destination storage
    var stack = InfixTokenStack.init(allocator); // working storage
    defer result.deinit();
    defer stack.deinit();

    for (infix_tokens) |token| {
        switch (token) {
            .lparen => try stack.push(token),
            .rparen => while (!stack.isEmpty()) {
                const op = stack.pop();
                if (op == InfixToken.lparen) break;
                try result.append(op);
            },
            .parallel, .serial => {
                while (!stack.isEmpty()) {
                    const op = stack.peek();
                    if (op != InfixToken.serial and op != InfixToken.parallel) break;
                    _ = stack.pop();
                    try result.append(op);
                }
                try stack.push(token);
            },
            .resistor => try result.append(token),
        }
    }
    while (!stack.isEmpty())
        try result.append(stack.pop());

    // array now contains operands and operators in postfix order (no parentheses)
    return result.toOwnedSlice();
}

const InfixTokenStack = Stack(InfixToken);

/// Façade to an ArrayList that translates from InfixToken tagged unions to
/// PostfixToken tagged unions in its append() function.
const PostfixTokenArray = struct {
    result: std.ArrayList(PostfixToken),

    fn init(allocator: Allocator) PostfixTokenArray {
        return PostfixTokenArray{
            .result = std.ArrayList(PostfixToken).init(allocator),
        };
    }
    fn deinit(self: *PostfixTokenArray) void {
        self.result.deinit();
    }
    /// Convert InfixToken to PostfixToken.
    fn append(self: *PostfixTokenArray, infix_token: InfixToken) !void {
        const postfix_token: PostfixToken = switch (infix_token) {
            .serial => PostfixToken.serial,
            .parallel => PostfixToken.parallel,
            .resistor => |slice| PostfixToken{ .resistor = slice },

            // Postfix does not have parentheses.
            .lparen => return ShuntPostfixError.LParenNotAllowed,
            .rparen => return ShuntPostfixError.RParenNotAllowed,
        };
        try self.result.append(postfix_token);
    }
    fn toOwnedSlice(self: *PostfixTokenArray) !std.ArrayList(PostfixToken).Slice {
        return try self.result.toOwnedSlice();
    }
};
