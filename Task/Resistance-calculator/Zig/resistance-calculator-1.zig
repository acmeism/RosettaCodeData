// postfix.zig
const std = @import("std");
const Allocator = std.mem.Allocator;
const Node = @import("common.zig").Node;
const PostfixToken = @import("common.zig").PostfixToken;
const calculate = @import("common.zig").calculate;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const stdout = std.io.getStdOut().writer();

    const node = try postfix(allocator, stdout, 18, "10 2 + 6 * 8 + 6 * 4 + 8 * 4 + 8 * 6 +");

    std.debug.assert(10 == node.res());
    std.debug.assert(18 == node.voltage);
    std.debug.assert(1.8 == node.current());
    std.debug.assert(@abs(32.4 - node.effect()) < 0.05);
    std.debug.assert(.serial == node.node_type);

    node.destroyDescendants(allocator);
    allocator.destroy(node);
}

/// Also know as RPN (Reverse Polish Notation)
fn postfix(allocator: Allocator, writer: anytype, voltage: f32, s: []const u8) !*Node {
    const tokens = try parse(allocator, s);
    defer allocator.free(tokens);

    return try calculate(allocator, writer, voltage, tokens);
}

const PostfixParseError = error{
    UnexpectedCharacter,
};

/// Parse postfix expression 's' to give a slice of PostfixToken.
/// Caller owns slice memory on return.
/// There are no Zig language semantics to indicate ownership or transferal thereof.
fn parse(allocator: Allocator, s: []const u8) ![]PostfixToken {
    var tokens = std.ArrayList(PostfixToken).init(allocator);
    // defer tokens.deinit(); // not needed, toOwnedSlice() owns memory.

    var slice_start: ?usize = null;

    // convert the string to a list of Token
    for (s, 0..) |ch, i| {
        const token: PostfixToken = switch (ch) {
            '+' => PostfixToken.serial,
            '*' => PostfixToken.parallel,
            '0'...'9' => {
                // Add digits to 'resistor' value.
                // 'slice_start' determines if any digit(s) have already been parsed.
                if (slice_start) |_| _ = tokens.pop() else slice_start = i;
                const slice_end = i + 1;
                try tokens.append(PostfixToken{ .resistor = s[slice_start.?..slice_end] });
                continue;
            },
            ' ', '\t' => {
                slice_start = null;
                continue;
            },
            else => return PostfixParseError.UnexpectedCharacter,
        };
        try tokens.append(token);
        // Last token was not a resistor. Reset 'start_slice'.
        slice_start = null;
    }
    return tokens.toOwnedSlice();
}
