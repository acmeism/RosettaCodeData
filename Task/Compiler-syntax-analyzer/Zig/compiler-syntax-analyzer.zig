const std = @import("std");

pub const NodeValue = union(enum) {
    integer: i32,
    string: []const u8,

    fn fromToken(token: Token) ?NodeValue {
        if (token.value) |value| {
            switch (value) {
                .integer => |int| return NodeValue{ .integer = int },
                .string => |str| return NodeValue{ .string = str },
            }
        } else {
            return null;
        }
    }
};

pub const Tree = struct {
    left: ?*Tree,
    right: ?*Tree,
    typ: NodeType,
    value: ?NodeValue = null,
};

pub const ParserError = error{
    OutOfMemory,
    ExpectedNotFound,
} || std.fmt.ParseIntError;

pub const Parser = struct {
    token_it: LexerOutputTokenizer,
    curr: Token,
    allocator: std.mem.Allocator,

    const Self = @This();

    pub fn init(allocator: std.mem.Allocator, str: []const u8) Self {
        return Self{
            .token_it = LexerOutputTokenizer.init(str),
            .curr = Token{ .line = 0, .col = 0, .typ = .unknown },
            .allocator = allocator,
        };
    }

    fn makeNode(self: *Self, typ: NodeType, left: ?*Tree, right: ?*Tree) !*Tree {
        const result = try self.allocator.create(Tree);
        result.* = Tree{ .left = left, .right = right, .typ = typ };
        return result;
    }

    fn makeLeaf(self: *Self, typ: NodeType, value: ?NodeValue) !*Tree {
        const result = try self.allocator.create(Tree);
        result.* = Tree{ .left = null, .right = null, .typ = typ, .value = value };
        return result;
    }

    pub fn parse(self: *Self) ParserError!?*Tree {
        try self.next();
        var result: ?*Tree = null;
        while (true) {
            const stmt = try self.parseStmt();
            result = try self.makeNode(.sequence, result, stmt);
            if (self.curr.typ == .eof) break;
        }
        return result;
    }

    /// Classic "Recursive descent" statement parser.
    fn parseStmt(self: *Self) ParserError!?*Tree {
        var result: ?*Tree = null;
        switch (self.curr.typ) {
            .kw_print => {
                try self.next();
                try self.expect(.left_paren);
                // Parse each print's argument as an expression delimited by commas until we reach
                // a closing parens.
                while (true) {
                    var expr: ?*Tree = null;
                    if (self.curr.typ == .string) {
                        expr = try self.makeNode(
                            .prts,
                            try self.makeLeaf(.string, NodeValue.fromToken(self.curr)),
                            null,
                        );
                        try self.next();
                    } else {
                        expr = try self.makeNode(.prti, try self.parseExpr(0), null);
                    }
                    result = try self.makeNode(.sequence, result, expr);
                    if (self.curr.typ != .comma) break;
                    try self.next();
                }
                try self.expect(.right_paren);
                try self.expect(.semicolon);
            },
            .kw_putc => {
                try self.next();
                result = try self.makeNode(.prtc, try self.parseParenExpr(), null);
                try self.expect(.semicolon);
            },
            .kw_while => {
                try self.next();
                const expr = try self.parseParenExpr();
                result = try self.makeNode(.kw_while, expr, try self.parseStmt());
            },
            .kw_if => {
                try self.next();
                const expr = try self.parseParenExpr();
                const if_stmt = try self.parseStmt();
                const else_stmt = blk: {
                    if (self.curr.typ == .kw_else) {
                        try self.next();
                        break :blk try self.parseStmt();
                    } else {
                        break :blk null;
                    }
                };
                const stmt_node = try self.makeNode(.kw_if, if_stmt, else_stmt);
                // If-statement uses `.kw_if` node for both first node with `expr` on the left
                // and statements on the right and also `.kw_if` node which goes to the right
                // and contains both if-branch and else-branch.
                result = try self.makeNode(.kw_if, expr, stmt_node);
            },
            .left_brace => {
                try self.next();
                while (self.curr.typ != .right_brace and self.curr.typ != .eof) {
                    result = try self.makeNode(.sequence, result, try self.parseStmt());
                }
                try self.expect(.right_brace);
            },
            .identifier => {
                const identifer = try self.makeLeaf(.identifier, NodeValue.fromToken(self.curr));
                try self.next();
                try self.expect(.assign);
                const expr = try self.parseExpr(0);
                result = try self.makeNode(.assign, identifer, expr);
                try self.expect(.semicolon);
            },
            .semicolon => try self.next(),
            else => {
                std.debug.print("\nSTMT: UNKNOWN {}\n", .{self.curr});
                std.os.exit(1);
            },
        }
        return result;
    }

    /// "Precedence climbing" expression parser.
    fn parseExpr(self: *Self, precedence: i8) ParserError!?*Tree {
        var result: ?*Tree = null;
        switch (self.curr.typ) {
            .left_paren => {
                result = try self.parseParenExpr();
            },
            .subtract => {
                try self.next();
                const metadata = NodeMetadata.find(.negate);
                const expr = try self.parseExpr(metadata.precedence);
                result = try self.makeNode(.negate, expr, null);
            },
            .not => {
                try self.next();
                const metadata = NodeMetadata.find(.not);
                const expr = try self.parseExpr(metadata.precedence);
                result = try self.makeNode(.not, expr, null);
            },
            .add => {
                try self.next();
                result = try self.parseExpr(precedence);
            },
            .integer, .identifier => {
                const node_type = NodeMetadata.find(self.curr.typ).node_type;
                result = try self.makeLeaf(node_type, NodeValue.fromToken(self.curr));
                try self.next();
            },
            else => {
                std.debug.print("\nEXPR: UNKNOWN {}\n", .{self.curr});
                std.os.exit(1);
            },
        }

        var curr_metadata = NodeMetadata.find(self.curr.typ);
        while (curr_metadata.binary and curr_metadata.precedence >= precedence) {
            const new_precedence =
                if (curr_metadata.right_associative)
                curr_metadata.precedence
            else
                curr_metadata.precedence + 1;
            try self.next();
            const sub_expr = try self.parseExpr(new_precedence);
            result = try self.makeNode(curr_metadata.node_type, result, sub_expr);
            curr_metadata = NodeMetadata.find(self.curr.typ);
        }
        return result;
    }

    fn parseParenExpr(self: *Self) ParserError!?*Tree {
        try self.expect(.left_paren);
        const result = try self.parseExpr(0);
        try self.expect(.right_paren);
        return result;
    }

    fn next(self: *Self) ParserError!void {
        const token = try self.token_it.next();
        if (token) |tok| {
            self.curr = tok;
        } else {
            self.curr = Token{ .line = 0, .col = 0, .typ = .unknown };
        }
    }

    fn expect(self: *Self, token_type: TokenType) ParserError!void {
        if (self.curr.typ != token_type) {
            const expected_str = NodeMetadata.find(token_type).token_str;
            const found_str = NodeMetadata.find(self.curr.typ).token_str;
            std.debug.print(
                "({d}, {d}) error: Expecting '{s}', found '{s}'\n",
                .{ self.curr.line, self.curr.col, expected_str, found_str },
            );
            return ParserError.ExpectedNotFound;
        }
        try self.next();
    }
};

pub fn parse(allocator: std.mem.Allocator, str: []const u8) !?*Tree {
    var parser = Parser.init(allocator, str);
    return try parser.parse();
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var arg_it = std.process.args();
    _ = try arg_it.next(allocator) orelse unreachable; // program name
    const file_name = arg_it.next(allocator);
    // We accept both files and standard input.
    var file_handle = blk: {
        if (file_name) |file_name_delimited| {
            const fname: []const u8 = try file_name_delimited;
            break :blk try std.fs.cwd().openFile(fname, .{});
        } else {
            break :blk std.io.getStdIn();
        }
    };
    defer file_handle.close();
    const input_content = try file_handle.readToEndAlloc(allocator, std.math.maxInt(usize));

    const result: ?*Tree = try parse(allocator, input_content);
    const result_str = try astToFlattenedString(allocator, result);
    _ = try std.io.getStdOut().write(result_str);
}

const NodeMetadata = struct {
    token_type: TokenType,
    right_associative: bool,
    binary: bool,
    unary: bool,
    precedence: i8,
    node_type: NodeType,
    token_str: []const u8,

    const self = [_]NodeMetadata{
        .{ .token_type = .multiply, .right_associative = false, .binary = true, .unary = false, .precedence = 13, .node_type = .multiply, .token_str = "*" },
        .{ .token_type = .divide, .right_associative = false, .binary = true, .unary = false, .precedence = 13, .node_type = .divide, .token_str = "/" },
        .{ .token_type = .mod, .right_associative = false, .binary = true, .unary = false, .precedence = 13, .node_type = .mod, .token_str = "%" },
        .{ .token_type = .add, .right_associative = false, .binary = true, .unary = false, .precedence = 12, .node_type = .add, .token_str = "+" },
        .{ .token_type = .subtract, .right_associative = false, .binary = true, .unary = false, .precedence = 12, .node_type = .subtract, .token_str = "-" },
        .{ .token_type = .negate, .right_associative = false, .binary = false, .unary = true, .precedence = 14, .node_type = .negate, .token_str = "-" },
        .{ .token_type = .less, .right_associative = false, .binary = true, .unary = false, .precedence = 10, .node_type = .less, .token_str = "<" },
        .{ .token_type = .less_equal, .right_associative = false, .binary = true, .unary = false, .precedence = 10, .node_type = .less_equal, .token_str = "<=" },
        .{ .token_type = .greater, .right_associative = false, .binary = true, .unary = false, .precedence = 10, .node_type = .greater, .token_str = ">" },
        .{ .token_type = .greater_equal, .right_associative = false, .binary = true, .unary = false, .precedence = 10, .node_type = .greater_equal, .token_str = ">=" },
        .{ .token_type = .equal, .right_associative = false, .binary = true, .unary = false, .precedence = 9, .node_type = .equal, .token_str = "=" },
        .{ .token_type = .not_equal, .right_associative = false, .binary = true, .unary = false, .precedence = 9, .node_type = .not_equal, .token_str = "!=" },
        .{ .token_type = .not, .right_associative = false, .binary = false, .unary = true, .precedence = 14, .node_type = .not, .token_str = "!" },
        .{ .token_type = .assign, .right_associative = false, .binary = false, .unary = false, .precedence = -1, .node_type = .assign, .token_str = "=" },
        .{ .token_type = .bool_and, .right_associative = false, .binary = true, .unary = false, .precedence = 5, .node_type = .bool_and, .token_str = "&&" },
        .{ .token_type = .bool_or, .right_associative = false, .binary = true, .unary = false, .precedence = 4, .node_type = .bool_or, .token_str = "||" },
        .{ .token_type = .left_paren, .right_associative = false, .binary = false, .unary = false, .precedence = -1, .node_type = .unknown, .token_str = "(" },
        .{ .token_type = .right_paren, .right_associative = false, .binary = false, .unary = false, .precedence = -1, .node_type = .unknown, .token_str = ")" },
        .{ .token_type = .left_brace, .right_associative = false, .binary = false, .unary = false, .precedence = -1, .node_type = .unknown, .token_str = "{" },
        .{ .token_type = .right_brace, .right_associative = false, .binary = false, .unary = false, .precedence = -1, .node_type = .unknown, .token_str = "}" },
        .{ .token_type = .semicolon, .right_associative = false, .binary = false, .unary = false, .precedence = -1, .node_type = .unknown, .token_str = ";" },
        .{ .token_type = .comma, .right_associative = false, .binary = false, .unary = false, .precedence = -1, .node_type = .unknown, .token_str = "," },
        .{ .token_type = .kw_if, .right_associative = false, .binary = false, .unary = false, .precedence = -1, .node_type = .kw_if, .token_str = "if" },
        .{ .token_type = .kw_else, .right_associative = false, .binary = false, .unary = false, .precedence = -1, .node_type = .unknown, .token_str = "else" },
        .{ .token_type = .kw_while, .right_associative = false, .binary = false, .unary = false, .precedence = -1, .node_type = .kw_while, .token_str = "while" },
        .{ .token_type = .kw_print, .right_associative = false, .binary = false, .unary = false, .precedence = -1, .node_type = .unknown, .token_str = "print" },
        .{ .token_type = .kw_putc, .right_associative = false, .binary = false, .unary = false, .precedence = -1, .node_type = .unknown, .token_str = "putc" },
        .{ .token_type = .identifier, .right_associative = false, .binary = false, .unary = false, .precedence = -1, .node_type = .identifier, .token_str = "Identifier" },
        .{ .token_type = .integer, .right_associative = false, .binary = false, .unary = false, .precedence = -1, .node_type = .integer, .token_str = "Integer literal" },
        .{ .token_type = .string, .right_associative = false, .binary = false, .unary = false, .precedence = -1, .node_type = .string, .token_str = "String literal" },
        .{ .token_type = .eof, .right_associative = false, .binary = false, .unary = false, .precedence = -1, .node_type = .unknown, .token_str = "End of line" },
    };

    pub fn find(token_type: TokenType) NodeMetadata {
        for (self) |metadata| {
            if (metadata.token_type == token_type) return metadata;
        } else {
            unreachable;
        }
    }
};

pub const NodeType = enum {
    unknown,
    identifier,
    string,
    integer,
    sequence,
    kw_if,
    prtc,
    prts,
    prti,
    kw_while,
    assign,
    negate,
    not,
    multiply,
    divide,
    mod,
    add,
    subtract,
    less,
    less_equal,
    greater,
    greater_equal,
    equal,
    not_equal,
    bool_and,
    bool_or,

    pub fn toString(self: NodeType) []const u8 {
        return switch (self) {
            .unknown => "UNKNOWN",
            .identifier => "Identifier",
            .string => "String",
            .integer => "Integer",
            .sequence => "Sequence",
            .kw_if => "If",
            .prtc => "Prtc",
            .prts => "Prts",
            .prti => "Prti",
            .kw_while => "While",
            .assign => "Assign",
            .negate => "Negate",
            .not => "Not",
            .multiply => "Multiply",
            .divide => "Divide",
            .mod => "Mod",
            .add => "Add",
            .subtract => "Subtract",
            .less => "Less",
            .less_equal => "LessEqual",
            .greater => "Greater",
            .greater_equal => "GreaterEqual",
            .equal => "Equal",
            .not_equal => "NotEqual",
            .bool_and => "And",
            .bool_or => "Or",
        };
    }
};

fn astToFlattenedString(allocator: std.mem.Allocator, tree: ?*Tree) ![]const u8 {
    var result = std.ArrayList(u8).init(allocator);
    var writer = result.writer();
    try treeToString(allocator, writer, tree);
    return result.items;
}

pub const TokenType = enum {
    unknown,
    multiply,
    divide,
    mod,
    add,
    subtract,
    negate,
    less,
    less_equal,
    greater,
    greater_equal,
    equal,
    not_equal,
    not,
    assign,
    bool_and,
    bool_or,
    left_paren,
    right_paren,
    left_brace,
    right_brace,
    semicolon,
    comma,
    kw_if,
    kw_else,
    kw_while,
    kw_print,
    kw_putc,
    identifier,
    integer,
    string,
    eof,

    const from_string_map = std.ComptimeStringMap(TokenType, .{
        .{ "Op_multiply", .multiply },
        .{ "Op_divide", .divide },
        .{ "Op_mod", .mod },
        .{ "Op_add", .add },
        .{ "Op_subtract", .subtract },
        .{ "Op_negate", .negate },
        .{ "Op_less", .less },
        .{ "Op_lessequal", .less_equal },
        .{ "Op_greater", .greater },
        .{ "Op_greaterequal", .greater_equal },
        .{ "Op_equal", .equal },
        .{ "Op_notequal", .not_equal },
        .{ "Op_not", .not },
        .{ "Op_assign", .assign },
        .{ "Op_and", .bool_and },
        .{ "Op_or", .bool_or },
        .{ "LeftParen", .left_paren },
        .{ "RightParen", .right_paren },
        .{ "LeftBrace", .left_brace },
        .{ "RightBrace", .right_brace },
        .{ "Semicolon", .semicolon },
        .{ "Comma", .comma },
        .{ "Keyword_if", .kw_if },
        .{ "Keyword_else", .kw_else },
        .{ "Keyword_while", .kw_while },
        .{ "Keyword_print", .kw_print },
        .{ "Keyword_putc", .kw_putc },
        .{ "Identifier", .identifier },
        .{ "Integer", .integer },
        .{ "String", .string },
        .{ "End_of_input", .eof },
    });

    pub fn fromString(str: []const u8) TokenType {
        return from_string_map.get(str).?;
    }
};

pub const TokenValue = union(enum) {
    integer: i32,
    string: []const u8,
};

pub const Token = struct {
    line: usize,
    col: usize,
    typ: TokenType = .unknown,
    value: ?TokenValue = null,
};

const TreeToStringError = error{OutOfMemory};

fn treeToString(
    allocator: std.mem.Allocator,
    writer: std.ArrayList(u8).Writer,
    tree: ?*Tree,
) TreeToStringError!void {
    if (tree) |t| {
        _ = try writer.write(try std.fmt.allocPrint(
            allocator,
            "{s}",
            .{t.typ.toString()},
        ));
        switch (t.typ) {
            .string, .identifier => _ = try writer.write(try std.fmt.allocPrint(
                allocator,
                "   {s}\n",
                .{t.value.?.string},
            )),
            .integer => _ = try writer.write(try std.fmt.allocPrint(
                allocator,
                "   {d}\n",
                .{t.value.?.integer},
            )),
            else => {
                _ = try writer.write(try std.fmt.allocPrint(
                    allocator,
                    "\n",
                    .{},
                ));
                try treeToString(allocator, writer, t.left);
                try treeToString(allocator, writer, t.right);
            },
        }
    } else {
        _ = try writer.write(try std.fmt.allocPrint(
            allocator,
            ";\n",
            .{},
        ));
    }
}

pub const LexerOutputTokenizer = struct {
    it: std.mem.SplitIterator(u8),

    const Self = @This();

    pub fn init(str: []const u8) Self {
        return Self{ .it = std.mem.split(u8, str, "\n") };
    }

    pub fn next(self: *Self) std.fmt.ParseIntError!?Token {
        if (self.it.next()) |line| {
            if (line.len == 0) return null;
            var tokens_it = std.mem.tokenize(u8, line, " ");
            const lineNumber = try std.fmt.parseInt(usize, tokens_it.next().?, 10);
            const colNumber = try std.fmt.parseInt(usize, tokens_it.next().?, 10);
            const typ_text = tokens_it.next().?;
            const typ = TokenType.fromString(typ_text);
            const pre_value_index = tokens_it.index;
            const value = tokens_it.next();
            var token = Token{ .line = lineNumber, .col = colNumber, .typ = typ };
            if (value) |val| {
                const token_value = blk: {
                    switch (typ) {
                        .string, .identifier => {
                            tokens_it.index = pre_value_index;
                            break :blk TokenValue{ .string = tokens_it.rest() };
                        },
                        .integer => break :blk TokenValue{ .integer = try std.fmt.parseInt(i32, val, 10) },
                        else => unreachable,
                    }
                };
                token.value = token_value;
            }
            return token;
        } else {
            return null;
        }
    }
};

fn stringToTokenList(allocator: std.mem.Allocator, str: []const u8) !std.ArrayList(Token) {
    var result = std.ArrayList(Token).init(allocator);
    var lexer_output_it = LexerOutputTokenizer.init(str);
    while (try lexer_output_it.next()) |token| {
        try result.append(token);
    }
    return result;
}
