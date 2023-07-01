const std = @import("std");

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

    // More efficient implementation can be done with `std.enums.directEnumArray`.
    pub fn toString(self: @This()) []const u8 {
        return switch (self) {
            .unknown => "UNKNOWN",
            .multiply => "Op_multiply",
            .divide => "Op_divide",
            .mod => "Op_mod",
            .add => "Op_add",
            .subtract => "Op_subtract",
            .negate => "Op_negate",
            .less => "Op_less",
            .less_equal => "Op_lessequal",
            .greater => "Op_greater",
            .greater_equal => "Op_greaterequal",
            .equal => "Op_equal",
            .not_equal => "Op_notequal",
            .not => "Op_not",
            .assign => "Op_assign",
            .bool_and => "Op_and",
            .bool_or => "Op_or",
            .left_paren => "LeftParen",
            .right_paren => "RightParen",
            .left_brace => "LeftBrace",
            .right_brace => "RightBrace",
            .semicolon => "Semicolon",
            .comma => "Comma",
            .kw_if => "Keyword_if",
            .kw_else => "Keyword_else",
            .kw_while => "Keyword_while",
            .kw_print => "Keyword_print",
            .kw_putc => "Keyword_putc",
            .identifier => "Identifier",
            .integer => "Integer",
            .string => "String",
            .eof => "End_of_input",
        };
    }
};

pub const TokenValue = union(enum) {
    intlit: i32,
    string: []const u8,
};

pub const Token = struct {
    line: usize,
    col: usize,
    typ: TokenType = .unknown,
    value: ?TokenValue = null,
};

// Error conditions described in the task.
pub const LexerError = error{
    EmptyCharacterConstant,
    UnknownEscapeSequence,
    MulticharacterConstant,
    EndOfFileInComment,
    EndOfFileInString,
    EndOfLineInString,
    UnrecognizedCharacter,
    InvalidNumber,
};

pub const Lexer = struct {
    content: []const u8,
    line: usize,
    col: usize,
    offset: usize,
    start: bool,

    const Self = @This();

    pub fn init(content: []const u8) Lexer {
        return Lexer{
            .content = content,
            .line = 1,
            .col = 1,
            .offset = 0,
            .start = true,
        };
    }

    pub fn buildToken(self: Self) Token {
        return Token{ .line = self.line, .col = self.col };
    }

    pub fn buildTokenT(self: Self, typ: TokenType) Token {
        return Token{ .line = self.line, .col = self.col, .typ = typ };
    }

    pub fn curr(self: Self) u8 {
        return self.content[self.offset];
    }

    // Alternative implementation is to return `Token` value from `next()` which is
    // arguably more idiomatic version.
    pub fn next(self: *Self) ?u8 {
        // We use `start` in order to make the very first invocation of `next()` to return
        // the very first character. It should be possible to avoid this variable.
        if (self.start) {
            self.start = false;
        } else {
            const newline = self.curr() == '\n';
            self.offset += 1;
            if (newline) {
                self.col = 1;
                self.line += 1;
            } else {
                self.col += 1;
            }
        }
        if (self.offset >= self.content.len) {
            return null;
        } else {
            return self.curr();
        }
    }

    pub fn peek(self: Self) ?u8 {
        if (self.offset + 1 >= self.content.len) {
            return null;
        } else {
            return self.content[self.offset + 1];
        }
    }

    fn divOrComment(self: *Self) LexerError!?Token {
        var result = self.buildToken();
        if (self.peek()) |peek_ch| {
            if (peek_ch == '*') {
                _ = self.next(); // peeked character
                while (self.next()) |ch| {
                    if (ch == '*') {
                        if (self.peek()) |next_ch| {
                            if (next_ch == '/') {
                                _ = self.next(); // peeked character
                                return null;
                            }
                        }
                    }
                }
                return LexerError.EndOfFileInComment;
            }
        }
        result.typ = .divide;
        return result;
    }

    fn identifierOrKeyword(self: *Self) !Token {
        var result = self.buildToken();
        const init_offset = self.offset;
        while (self.peek()) |ch| : (_ = self.next()) {
            switch (ch) {
                '_', 'a'...'z', 'A'...'Z', '0'...'9' => {},
                else => break,
            }
        }
        const final_offset = self.offset + 1;

        if (std.mem.eql(u8, self.content[init_offset..final_offset], "if")) {
            result.typ = .kw_if;
        } else if (std.mem.eql(u8, self.content[init_offset..final_offset], "else")) {
            result.typ = .kw_else;
        } else if (std.mem.eql(u8, self.content[init_offset..final_offset], "while")) {
            result.typ = .kw_while;
        } else if (std.mem.eql(u8, self.content[init_offset..final_offset], "print")) {
            result.typ = .kw_print;
        } else if (std.mem.eql(u8, self.content[init_offset..final_offset], "putc")) {
            result.typ = .kw_putc;
        } else {
            result.typ = .identifier;
            result.value = TokenValue{ .string = self.content[init_offset..final_offset] };
        }

        return result;
    }

    fn string(self: *Self) !Token {
        var result = self.buildToken();
        result.typ = .string;
        const init_offset = self.offset;
        while (self.next()) |ch| {
            switch (ch) {
                '"' => break,
                '\n' => return LexerError.EndOfLineInString,
                '\\' => {
                    switch (self.peek() orelse return LexerError.EndOfFileInString) {
                        'n', '\\' => _ = self.next(), // peeked character
                        else => return LexerError.UnknownEscapeSequence,
                    }
                },
                else => {},
            }
        } else {
            return LexerError.EndOfFileInString;
        }
        const final_offset = self.offset + 1;
        result.value = TokenValue{ .string = self.content[init_offset..final_offset] };
        return result;
    }

    /// Choose either `ifyes` or `ifno` token type depending on whether the peeked
    /// character is `by`.
    fn followed(self: *Self, by: u8, ifyes: TokenType, ifno: TokenType) Token {
        var result = self.buildToken();
        if (self.peek()) |ch| {
            if (ch == by) {
                _ = self.next(); // peeked character
                result.typ = ifyes;
            } else {
                result.typ = ifno;
            }
        } else {
            result.typ = ifno;
        }
        return result;
    }

    /// Raise an error if there's no next `by` character but return token with `typ` otherwise.
    fn consecutive(self: *Self, by: u8, typ: TokenType) LexerError!Token {
        const result = self.buildTokenT(typ);
        if (self.peek()) |ch| {
            if (ch == by) {
                _ = self.next(); // peeked character
                return result;
            } else {
                return LexerError.UnrecognizedCharacter;
            }
        } else {
            return LexerError.UnrecognizedCharacter;
        }
    }

    fn integerLiteral(self: *Self) LexerError!Token {
        var result = self.buildTokenT(.integer);
        const init_offset = self.offset;
        while (self.peek()) |ch| {
            switch (ch) {
                '0'...'9' => _ = self.next(), // peeked character
                '_', 'a'...'z', 'A'...'Z' => return LexerError.InvalidNumber,
                else => break,
            }
        }
        const final_offset = self.offset + 1;
        result.value = TokenValue{
            .intlit = std.fmt.parseInt(i32, self.content[init_offset..final_offset], 10) catch {
                return LexerError.InvalidNumber;
            },
        };
        return result;
    }

    // This is a beautiful way of how Zig allows to remove bilerplate and at the same time
    // to not lose any error completeness guarantees.
    fn nextOrEmpty(self: *Self) LexerError!u8 {
        return self.next() orelse LexerError.EmptyCharacterConstant;
    }

    fn integerChar(self: *Self) LexerError!Token {
        var result = self.buildTokenT(.integer);
        switch (try self.nextOrEmpty()) {
            '\'', '\n' => return LexerError.EmptyCharacterConstant,
            '\\' => {
                switch (try self.nextOrEmpty()) {
                    'n' => result.value = TokenValue{ .intlit = '\n' },
                    '\\' => result.value = TokenValue{ .intlit = '\\' },
                    else => return LexerError.EmptyCharacterConstant,
                }
                switch (try self.nextOrEmpty()) {
                    '\'' => {},
                    else => return LexerError.MulticharacterConstant,
                }
            },
            else => {
                result.value = TokenValue{ .intlit = self.curr() };
                switch (try self.nextOrEmpty()) {
                    '\'' => {},
                    else => return LexerError.MulticharacterConstant,
                }
            },
        }
        return result;
    }
};

pub fn lex(allocator: std.mem.Allocator, content: []u8) !std.ArrayList(Token) {
    var tokens = std.ArrayList(Token).init(allocator);
    var lexer = Lexer.init(content);
    while (lexer.next()) |ch| {
        switch (ch) {
            ' ' => {},
            '*' => try tokens.append(lexer.buildTokenT(.multiply)),
            '%' => try tokens.append(lexer.buildTokenT(.mod)),
            '+' => try tokens.append(lexer.buildTokenT(.add)),
            '-' => try tokens.append(lexer.buildTokenT(.subtract)),
            '<' => try tokens.append(lexer.followed('=', .less_equal, .less)),
            '>' => try tokens.append(lexer.followed('=', .greater_equal, .greater)),
            '=' => try tokens.append(lexer.followed('=', .equal, .assign)),
            '!' => try tokens.append(lexer.followed('=', .not_equal, .not)),
            '(' => try tokens.append(lexer.buildTokenT(.left_paren)),
            ')' => try tokens.append(lexer.buildTokenT(.right_paren)),
            '{' => try tokens.append(lexer.buildTokenT(.left_brace)),
            '}' => try tokens.append(lexer.buildTokenT(.right_brace)),
            ';' => try tokens.append(lexer.buildTokenT(.semicolon)),
            ',' => try tokens.append(lexer.buildTokenT(.comma)),
            '&' => try tokens.append(try lexer.consecutive('&', .bool_and)),
            '|' => try tokens.append(try lexer.consecutive('|', .bool_or)),
            '/' => {
                if (try lexer.divOrComment()) |token| try tokens.append(token);
            },
            '_', 'a'...'z', 'A'...'Z' => try tokens.append(try lexer.identifierOrKeyword()),
            '"' => try tokens.append(try lexer.string()),
            '0'...'9' => try tokens.append(try lexer.integerLiteral()),
            '\'' => try tokens.append(try lexer.integerChar()),
            else => {},
        }
    }
    try tokens.append(lexer.buildTokenT(.eof));

    return tokens;
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

    const tokens = try lex(allocator, input_content);
    const pretty_output = try tokenListToString(allocator, tokens);
    _ = try std.io.getStdOut().write(pretty_output);
}

fn tokenListToString(allocator: std.mem.Allocator, token_list: std.ArrayList(Token)) ![]u8 {
    var result = std.ArrayList(u8).init(allocator);
    var w = result.writer();
    for (token_list.items) |token| {
        const common_args = .{ token.line, token.col, token.typ.toString() };
        if (token.value) |value| {
            const init_fmt = "{d:>5}{d:>7} {s:<15}";
            switch (value) {
                .string => |str| _ = try w.write(try std.fmt.allocPrint(
                    allocator,
                    init_fmt ++ "{s}\n",
                    common_args ++ .{str},
                )),
                .intlit => |i| _ = try w.write(try std.fmt.allocPrint(
                    allocator,
                    init_fmt ++ "{d}\n",
                    common_args ++ .{i},
                )),
            }
        } else {
            _ = try w.write(try std.fmt.allocPrint(allocator, "{d:>5}{d:>7} {s}\n", common_args));
        }
    }
    return result.items;
}
