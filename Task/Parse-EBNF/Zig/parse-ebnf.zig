const std = @import("std");
const print = std.debug.print;
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

const ParseError = error{
    OutOfMemory,
    InvalidTokenSequence,
    InvalidTokenInFactor,
};

const Token = union(enum) {
    char: u8,
    sequence: []const []const u8,
    eof,

    pub fn deinit(self: Token, allocator: Allocator) void {
        switch (self) {
            .sequence => |seq| {
                for (seq) |str| {
                    allocator.free(str);
                }
                allocator.free(seq);
            },
            else => {},
        }
    }
};

const Rule = union(enum) {
    terminal: []const u8,
    ident: struct { name: []const u8, idx: usize },
    my_or: []const *Rule,
    repeat: *Rule,
    optional: *Rule,
    sequence: []const *Rule,

    pub fn deinit(self: *Rule, allocator: Allocator) void {
        switch (self.*) {
            .terminal => |term| allocator.free(term),
            .ident => |ident| allocator.free(ident.name),
            .my_or => |rules| {
                for (rules) |rule| {
                    rule.deinit(allocator);
                    allocator.destroy(rule);
                }
                allocator.free(rules);
            },
            .repeat => |rule| {
                rule.deinit(allocator);
                allocator.destroy(rule);
            },
            .optional => |rule| {
                rule.deinit(allocator);
                allocator.destroy(rule);
            },
            .sequence => |rules| {
                for (rules) |rule| {
                    rule.deinit(allocator);
                    allocator.destroy(rule);
                }
                allocator.free(rules);
            },
        }
    }
};

const Production = struct {
    name: []const u8,
    idx: usize,
    rule: *Rule,

    pub fn deinit(self: Production, allocator: Allocator) void {
        allocator.free(self.name);
        self.rule.deinit(allocator);
        allocator.destroy(self.rule);
    }
};

pub const EBNFParser = struct {
    allocator: Allocator,
    src: []const u8,
    ch: u8,
    sdx: usize,
    token: Token,
    err: bool,
    idents: ArrayList([]const u8),
    ididx: ArrayList(?usize),
    productions: ArrayList(Production),
    extras: ArrayList([]const []const u8),

    pub fn init(allocator: Allocator) EBNFParser {
        return EBNFParser{
            .allocator = allocator,
            .src = "",
            .ch = 0,
            .sdx = 0,
            .token = .eof,
            .err = false,
            .idents = ArrayList([]const u8).init(allocator),
            .ididx = ArrayList(?usize).init(allocator),
            .productions = ArrayList(Production).init(allocator),
            .extras = ArrayList([]const []const u8).init(allocator),
        };
    }

    pub fn deinit(self: *EBNFParser) void {
        for (self.idents.items) |ident| {
            self.allocator.free(ident);
        }
        self.idents.deinit();
        self.ididx.deinit();

        for (self.productions.items) |prod| {
            prod.deinit(self.allocator);
        }
        self.productions.deinit();

        for (self.extras.items) |extra| {
            for (extra) |str| {
                self.allocator.free(str);
            }
            self.allocator.free(extra);
        }
        self.extras.deinit();

        self.token.deinit(self.allocator);
    }

    fn btoi(b: bool) usize {
        return if (b) 1 else 0;
    }

    fn invalid(self: *EBNFParser, msg: []const u8) i32 {
        self.err = true;
        print("{s}\n", .{msg});
        self.sdx = self.src.len; // set to eof
        return -1;
    }

    fn skipSpaces(self: *EBNFParser) void {
        while (self.sdx < self.src.len) {
            self.ch = self.src[self.sdx];
            if (self.ch != ' ' and self.ch != '\t' and self.ch != '\r' and self.ch != '\n') {
                break;
            }
            self.sdx += 1;
        }
    }

    fn getToken(self: *EBNFParser) ParseError!void {
        // Clean up previous token
        self.token.deinit(self.allocator);

        self.skipSpaces();
        if (self.sdx >= self.src.len) {
            self.token = .eof;
            return;
        }

        const tokstart = self.sdx;

        if (std.mem.indexOfScalar(u8, "{}()[]|=.;", self.ch) != null) {
            self.sdx += 1;
            self.token = Token{ .char = self.ch };
        } else if (self.ch == '"' or self.ch == '\'') {
            const closech = self.ch;
            var tokend = tokstart + 1;
            while (tokend < self.src.len and self.src[tokend] != closech) {
                tokend += 1;
            }
            if (tokend >= self.src.len) {
                _ = self.invalid("no closing quote");
                self.token = .eof;
            } else {
                self.sdx = tokend + 1;
                const content = try self.allocator.dupe(u8, self.src[tokstart + 1..tokend]);
                const terminal_str = try self.allocator.dupe(u8, "terminal");
                const seq = try self.allocator.alloc([]const u8, 2);
                seq[0] = terminal_str;
                seq[1] = content;
                self.token = Token{ .sequence = seq };
            }
        } else if (std.ascii.isLower(self.ch)) {
            // To simplify things for the purposes of this task,
            // identifiers are strictly a-z only, not A-Z or 1-9.
            while (self.sdx < self.src.len) {
                self.ch = self.src[self.sdx];
                if (!std.ascii.isLower(self.ch)) {
                    break;
                }
                self.sdx += 1;
            }
            const ident = try self.allocator.dupe(u8, self.src[tokstart..self.sdx]);
            const ident_str = try self.allocator.dupe(u8, "ident");
            const seq = try self.allocator.alloc([]const u8, 2);
            seq[0] = ident_str;
            seq[1] = ident;
            self.token = Token{ .sequence = seq };
        } else {
            _ = self.invalid("invalid ebnf");
            self.token = .eof;
        }
    }

    fn matchToken(self: *EBNFParser, expected_ch: u8) ParseError!void {
        switch (self.token) {
            .char => |ch| {
                if (ch != expected_ch) {
                    _ = self.invalid("invalid ebnf (token mismatch)");
                } else {
                    try self.getToken();
                }
            },
            else => {
                _ = self.invalid("invalid ebnf (expected char token)");
            },
        }
    }

    fn addIdent(self: *EBNFParser, ident: []const u8) ParseError!usize {
        for (self.idents.items, 0..) |existing_ident, k| {
            if (std.mem.eql(u8, existing_ident, ident)) {
                return k;
            }
        }

        const ident_copy = try self.allocator.dupe(u8, ident);
        try self.idents.append(ident_copy);
        const k = self.idents.items.len - 1;
        try self.ididx.append(null);
        return k;
    }

    fn factor(self: *EBNFParser) ParseError!*Rule {
        const rule = try self.allocator.create(Rule);

        switch (self.token) {
            .sequence => |seq| {
                if (std.mem.eql(u8, seq[0], "ident")) {
                    const idx = try self.addIdent(seq[1]);
                    const name_copy = try self.allocator.dupe(u8, seq[1]);
                    rule.* = Rule{ .ident = .{ .name = name_copy, .idx = idx } };
                    try self.getToken();
                } else if (std.mem.eql(u8, seq[0], "terminal")) {
                    const term_copy = try self.allocator.dupe(u8, seq[1]);
                    rule.* = Rule{ .terminal = term_copy };
                    try self.getToken();
                } else {
                    self.allocator.destroy(rule);
                    return error.InvalidTokenSequence;
                }
            },
            .char => |ch| {
                switch (ch) {
                    '[' => {
                        try self.getToken();
                        const expr = try self.expression();
                        try self.matchToken(']');
                        rule.* = Rule{ .optional = expr };
                    },
                    '(' => {
                        try self.getToken();
                        const expr = try self.expression();
                        try self.matchToken(')');
                        self.allocator.destroy(rule);
                        return expr;
                    },
                    '{' => {
                        try self.getToken();
                        const expr = try self.expression();
                        try self.matchToken('}');
                        rule.* = Rule{ .repeat = expr };
                    },
                    else => {
                        self.allocator.destroy(rule);
                        return error.InvalidTokenInFactor;
                    },
                }
            },
            else => {
                self.allocator.destroy(rule);
                return error.InvalidTokenInFactor;
            },
        }

        return rule;
    }

    fn term(self: *EBNFParser) ParseError!*Rule {
        var factors = ArrayList(*Rule).init(self.allocator);
        defer factors.deinit();

        try factors.append(try self.factor());

        while (true) {
            switch (self.token) {
                .eof => break,
                .char => |ch| {
                    switch (ch) {
                        '|', '.', ';', ')', ']', '}' => break,
                        else => {},
                    }
                },
                else => {},
            }

            // Check if we should stop
            const should_stop = switch (self.token) {
                .eof => true,
                .char => |ch| switch (ch) {
                    '|', '.', ';', ')', ']', '}' => true,
                    else => false,
                },
                else => false,
            };

            if (should_stop) break;

            try factors.append(try self.factor());
        }

        if (factors.items.len == 1) {
            return factors.items[0];
        } else {
            const rule = try self.allocator.create(Rule);
            const rules_copy = try self.allocator.dupe(*Rule, factors.items);
            rule.* = Rule{ .sequence = rules_copy };
            return rule;
        }
    }

    fn expression(self: *EBNFParser) ParseError!*Rule {
        const first_term = try self.term();

        switch (self.token) {
            .char => |ch| {
                if (ch == '|') {
                    var terms = ArrayList(*Rule).init(self.allocator);
                    defer terms.deinit();

                    try terms.append(first_term);

                    while (true) {
                        switch (self.token) {
                            .char => |token_ch| {
                                if (token_ch == '|') {
                                    try self.getToken();
                                    try terms.append(try self.term());
                                } else {
                                    break;
                                }
                            },
                            else => break,
                        }
                    }

                    const rule = try self.allocator.create(Rule);
                    const rules_copy = try self.allocator.dupe(*Rule, terms.items);
                    rule.* = Rule{ .my_or = rules_copy };
                    return rule;
                }
            },
            else => {},
        }

        return first_term;
    }

    fn production(self: *EBNFParser) ParseError!Token {
        try self.getToken();

        switch (self.token) {
            .char => |ch| {
                if (ch == '}') {
                    return self.token;
                }
            },
            .eof => {
                _ = self.invalid("invalid ebnf (missing closing })");
                return .eof;
            },
            else => {},
        }

        switch (self.token) {
            .sequence => |seq| {
                if (std.mem.eql(u8, seq[0], "ident")) {
                    const ident = seq[1];
                    const idx = try self.addIdent(ident);
                    try self.getToken();
                    try self.matchToken('=');

                    switch (self.token) {
                        .eof => return .eof,
                        else => {},
                    }

                    const expr = try self.expression();
                    const ident_copy = try self.allocator.dupe(u8, ident);
                    const prod = Production{
                        .name = ident_copy,
                        .idx = idx,
                        .rule = expr,
                    };
                    try self.productions.append(prod);
                    self.ididx.items[idx] = self.productions.items.len - 1;
                    return self.token;
                }
            },
            else => {},
        }

        return .eof;
    }

    pub fn parse(self: *EBNFParser, ebnf: []const u8) ParseError!i32 {
        print("parse:\n{s} ===>\n\n", .{ebnf});
        self.err = false;
        self.src = ebnf;
        self.sdx = 0;

        // Clear previous data
        for (self.idents.items) |ident| {
            self.allocator.free(ident);
        }
        self.idents.clearRetainingCapacity();
        self.ididx.clearRetainingCapacity();

        for (self.productions.items) |prod| {
            prod.deinit(self.allocator);
        }
        self.productions.clearRetainingCapacity();

        for (self.extras.items) |extra| {
            for (extra) |str| {
                self.allocator.free(str);
            }
            self.allocator.free(extra);
        }
        self.extras.clearRetainingCapacity();

        try self.getToken();

        switch (self.token) {
            .sequence => |seq| {
                const title_str = try self.allocator.dupe(u8, "title");
                const content = try self.allocator.dupe(u8, seq[1]);
                const extra = try self.allocator.alloc([]const u8, 2);
                extra[0] = title_str;
                extra[1] = content;
                try self.extras.append(extra);
                try self.getToken();
            },
            else => {},
        }

        switch (self.token) {
            .char => |ch| {
                if (ch != '{') {
                    return self.invalid("invalid ebnf (missing opening {)");
                }
            },
            else => {
                return self.invalid("invalid ebnf (missing opening {)");
            },
        }

        while (true) {
            const prod_result = self.production() catch return -1;
            switch (prod_result) {
                .char => |ch| {
                    if (ch == '}') break;
                },
                .eof => break,
                else => continue,
            }
        }

        try self.getToken();
        switch (self.token) {
            .sequence => |seq| {
                const comment_str = try self.allocator.dupe(u8, "comment");
                const content = try self.allocator.dupe(u8, seq[1]);
                const extra = try self.allocator.alloc([]const u8, 2);
                extra[0] = comment_str;
                extra[1] = content;
                try self.extras.append(extra);
                try self.getToken();
            },
            else => {},
        }

        switch (self.token) {
            .eof => {},
            else => {
                return self.invalid("invalid ebnf (missing eof?)");
            },
        }

        if (self.err) {
            return -1;
        }

        // Check for undefined identifiers
        for (self.ididx.items, 0..) |ididx_val, i| {
            if (ididx_val == null) {
                print("invalid ebnf (undefined:{s})\n", .{self.idents.items[i]});
                return -1;
            }
        }

        self.pprintProductions();
        self.pprintIdents();
        self.pprintIdidx();
        self.pprintExtras();
        return 1;
    }

    fn pprintProductions(self: *EBNFParser) void {
        print("\nproductions:\n", .{});
        for (self.productions.items) |prod| {
            print("({s}, {d}, rule)\n", .{ prod.name, prod.idx });
        }
    }

    fn pprintIdents(self: *EBNFParser) void {
        print("\nidents:\n", .{});
        for (self.idents.items) |ident| {
            print("{s}, ", .{ident});
        }
        print("\n", .{});
    }

    fn pprintIdidx(self: *EBNFParser) void {
        print("\nididx:\n", .{});
        for (self.ididx.items) |idx| {
            if (idx) |i| {
                print("{d}, ", .{i});
            } else {
                print("null, ", .{});
            }
        }
        print("\n", .{});
    }

    fn pprintExtras(self: *EBNFParser) void {
        print("\nextras:\n", .{});
        for (self.extras.items) |extra| {
            for (extra) |str| {
                print("{s} ", .{str});
            }
            print("\n", .{});
        }
    }

    fn applies(self: *EBNFParser, rule: *Rule, src: []const u8, sdx: *usize) bool {
        const was_sdx = sdx.*;

        switch (rule.*) {
            .sequence => |rules| {
                for (rules) |subrule| {
                    if (!self.applies(subrule, src, sdx)) {
                        sdx.* = was_sdx;
                        return false;
                    }
                }
                return true;
            },
            .terminal => |terminal| {
                self.skipSpacesAt(src, sdx);
                for (terminal) |ch| {
                    if (sdx.* >= src.len or src[sdx.*] != ch) {
                        sdx.* = was_sdx;
                        return false;
                    }
                    sdx.* += 1;
                }
                return true;
            },
            .my_or => |rules| {
                for (rules) |subrule| {
                    if (self.applies(subrule, src, sdx)) {
                        return true;
                    }
                }
                sdx.* = was_sdx;
                return false;
            },
            .repeat => |subrule| {
                while (self.applies(subrule, src, sdx)) {
                    // continue repeating
                }
                return true;
            },
            .optional => |subrule| {
                _ = self.applies(subrule, src, sdx);
                return true;
            },
            .ident => |ident_info| {
                if (self.ididx.items[ident_info.idx]) |prod_idx| {
                    if (!self.applies(self.productions.items[prod_idx].rule, src, sdx)) {
                        sdx.* = was_sdx;
                        return false;
                    }
                    return true;
                } else {
                    return false;
                }
            },
        }
    }

    fn skipSpacesAt(self: *EBNFParser, src: []const u8, sdx: *usize) void {
        _ = self;
        while (sdx.* < src.len) {
            const ch = src[sdx.*];
            if (ch != ' ' and ch != '\t' and ch != '\r' and ch != '\n') {
                break;
            }
            sdx.* += 1;
        }
    }

    fn checkValid(self: *EBNFParser, my_test: []const u8) void {
        var sdx: usize = 0;
        const res = self.applies(self.productions.items[0].rule, my_test, &sdx);
        self.skipSpacesAt(my_test, &sdx);
        const final_res = res and sdx >= my_test.len;
        const result = if (final_res) "pass" else "fail";
        print("\"{s}\", {s}\n", .{ my_test, result });
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var parser = EBNFParser.init(allocator);
    defer parser.deinit();

    const ebnfs = [_][]const u8{
        "\"a\" {\n    a = \"a1\" ( \"a2\" | \"a3\" ) { \"a4\" } [ \"a5\" ] \"a6\" ;\n} \"z\" ",
        "{\n    expr = term { plus term } .\n    term = factor { times factor } .\n    factor = number | '(' expr ')' .\n \n    plus = \"+\" | \"-\" .\n    times = \"*\" | \"/\" .\n \n    number = digit { digit } .\n    digit = \"0\" | \"1\" | \"2\" | \"3\" | \"4\" | \"5\" | \"6\" | \"7\" | \"8\" | \"9\" .\n}",
        "a = \"1\"",
        "{ a = \"1\" ;",
        "{ hello world = \"1\"; }",
        "{ foo = bar . }",
    };

    const tests = [_][]const []const u8{
        &[_][]const u8{
            "a1a3a4a4a5a6",
            "a1 a2a6",
            "a1 a3 a4 a6",
            "a1 a4 a5 a6",
            "a1 a2 a4 a5 a5 a6",
            "a1 a2 a4 a5 a6 a7",
            "your ad here",
        },
        &[_][]const u8{
            "2",
            "2*3 + 4/23 - 7",
            "(3 + 4) * 6-2+(4*(4))",
            "-2",
            "3 +",
            "(4 + 3",
        },
    };

    for (ebnfs, 0..) |ebnf, i| {
        const result = parser.parse(ebnf) catch -1;
        if (result == 1) {
            print("\ntests:\n", .{});
            if (i < tests.len) {
                for (tests[i]) |my_test| {
                    parser.checkValid(my_test);
                }
            }
        }
        print("\n", .{});
    }
}
