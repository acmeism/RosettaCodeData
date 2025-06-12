const std = @import("std");
const testing = std.testing;
const mem = std.mem;
const Allocator = std.mem.Allocator;

// Add a main function for Zig playground to compile
pub fn main() !void {
    // Empty main function to satisfy the compiler
    std.debug.print("Markov Algorithm library\n", .{});
}

pub const Rule = struct {
    pat: []const u8,
    rep: []const u8,
    terminal: bool,

    pub fn init(allocator: Allocator, pat: []const u8, rep: []const u8, terminal: bool) !Rule {
        const pat_owned = try allocator.dupe(u8, pat);
        const rep_owned = try allocator.dupe(u8, rep);
        return Rule{
            .pat = pat_owned,
            .rep = rep_owned,
            .terminal = terminal,
        };
    }

    pub fn deinit(self: *Rule, allocator: Allocator) void {
        allocator.free(self.pat);
        allocator.free(self.rep);
    }

    pub fn clone(self: Rule, allocator: Allocator) !Rule {
        return try Rule.init(allocator, self.pat, self.rep, self.terminal);
    }

    pub fn applicableRange(self: *const Rule, input: []const u8) ?struct { start: usize, end: usize } {
        if (mem.indexOf(u8, input, self.pat)) |start| {
            return .{ .start = start, .end = start + self.pat.len };
        }
        return null;
    }

    pub fn apply(self: *const Rule, s: *std.ArrayList(u8)) !bool {
        if (self.applicableRange(s.items)) |range| {
            try s.replaceRange(range.start, range.end - range.start, self.rep);
            return true;
        }
        return false;
    }

    pub fn fromString(allocator: Allocator, s: []const u8) !Rule {
        var parts = mem.splitSequence(u8, s, " -> ");
        const pat = parts.first();
        const rep_opt = parts.next();
        if (rep_opt == null) {
            return error.InvalidFormat;
        }
        const rep = rep_opt.?;

        if (rep.len > 0 and rep[0] == '.') {
            return Rule.init(allocator, pat, rep[1..], true);
        } else {
            return Rule.init(allocator, pat, rep, false);
        }
    }
};

pub const Rules = struct {
    rules: std.ArrayList(Rule),
    allocator: Allocator,

    pub fn init(allocator: Allocator) Rules {
        return Rules{
            .rules = std.ArrayList(Rule).init(allocator),
            .allocator = allocator,
        };
    }

    pub fn deinit(self: *Rules) void {
        for (self.rules.items) |*rule| {
            rule.deinit(self.allocator);
        }
        self.rules.deinit();
    }

    pub fn clone(self: Rules) !Rules {
        var new_rules = Rules.init(self.allocator);
        for (self.rules.items) |rule| {
            try new_rules.rules.append(try rule.clone(self.allocator));
        }
        return new_rules;
    }

    pub fn apply(self: *const Rules, s: *std.ArrayList(u8)) !?*const Rule {
        for (self.rules.items) |*rule| {
            if (try rule.apply(s)) {
                return rule;
            }
        }
        return null;
    }

    pub fn execute(self: *const Rules, buffer: []const u8) ![]u8 {
        var result = try std.ArrayList(u8).initCapacity(self.allocator, buffer.len);
        try result.appendSlice(buffer);

        while (try self.apply(&result)) |rule| {
            if (rule.terminal) {
                break;
            }
        }

        return result.toOwnedSlice();
    }

    pub fn fromString(allocator: Allocator, s: []const u8) !Rules {
        var result = Rules.init(allocator);
        var lines = mem.splitScalar(u8, s, '\n');

        while (lines.next()) |line| {
            const trimmed = mem.trim(u8, line, &std.ascii.whitespace);
            if (trimmed.len == 0 or trimmed[0] == '#') {
                continue;
            }
            const rule = try Rule.fromString(allocator, trimmed);
            try result.rules.append(rule);
        }

        return result;
    }
};

test "case_01" {
    const allocator = std.testing.allocator;
    const input = "I bought a B of As from T S.";
    const rules_str =
        \\# This rules file is extracted from Wikipedia:
        \\# http://en.wikipedia.org/wiki/Markov_Algorithm
        \\A -> apple
        \\B -> bag
        \\S -> shop
        \\T -> the
        \\the shop -> my brother
        \\a never used -> .terminating rule
    ;

    var rules = try Rules.fromString(allocator, rules_str);
    defer rules.deinit();

    const result = try rules.execute(input);
    defer allocator.free(result);

    try testing.expectEqualStrings("I bought a bag of apples from my brother.", result);
}

test "case_02" {
    const allocator = std.testing.allocator;
    const input = "I bought a B of As from T S.";
    const rules_str =
        \\# Slightly modified from the rules on Wikipedia
        \\A -> apple
        \\B -> bag
        \\S -> .shop
        \\T -> the
        \\the shop -> my brother
        \\a never used -> .terminating rule
    ;

    var rules = try Rules.fromString(allocator, rules_str);
    defer rules.deinit();

    const result = try rules.execute(input);
    defer allocator.free(result);

    try testing.expectEqualStrings("I bought a bag of apples from T shop.", result);
}

test "case_03" {
    const allocator = std.testing.allocator;
    const input = "I bought a B of As W my Bgage from T S.";
    const rules_str =
        \\# BNF Syntax testing rules
        \\A -> apple
        \\WWWW -> with
        \\Bgage -> ->.*
        \\B -> bag
        \\->.* -> money
        \\W -> WW
        \\S -> .shop
        \\T -> the
        \\the shop -> my brother
        \\a never used -> .terminating rule
    ;

    var rules = try Rules.fromString(allocator, rules_str);
    defer rules.deinit();

    const result = try rules.execute(input);
    defer allocator.free(result);

    try testing.expectEqualStrings("I bought a bag of apples with my money from T shop.", result);
}

test "case_04" {
    const allocator = std.testing.allocator;
    const input = "_1111*11111_";
    const rules_str =
        \\### Unary Multiplication Engine, for testing Markov Algorithm implementations
        \\### By Donal Fellows.
        \\# Unary addition engine
        \\_+1 -> _1+
        \\1+1 -> 11+
        \\# Pass for converting from the splitting of multiplication into ordinary
        \\# addition
        \\1! -> !1
        \\,! -> !+
        \\_! -> _
        \\# Unary multiplication by duplicating left side, right side times
        \\1*1 -> x,@y
        \\1x -> xX
        \\X, -> 1,1
        \\X1 -> 1X
        \\_x -> _X
        \\,x -> ,X
        \\y1 -> 1y
        \\y_ -> _
        \\# Next phase of applying
        \\1@1 -> x,@y
        \\1@_ -> @_
        \\,@_ -> !_
        \\++ -> +
        \\# Termination cleanup for addition
        \\_1 -> 1
        \\1+_ -> 1
        \\_+_ ->
    ;

    var rules = try Rules.fromString(allocator, rules_str);
    defer rules.deinit();

    const result = try rules.execute(input);
    defer allocator.free(result);

    try testing.expectEqualStrings("11111111111111111111", result);
}

test "case_05" {
    const allocator = std.testing.allocator;
    const input = "000000A000000";
    const rules_str =
        \\# Turing machine: three-state busy beaver
        \\#
        \\# state A, symbol 0 => write 1, move right, new state B
        \\A0 -> 1B
        \\# state A, symbol 1 => write 1, move left, new state C
        \\0A1 -> C01
        \\1A1 -> C11
        \\# state B, symbol 0 => write 1, move left, new state A
        \\0B0 -> A01
        \\1B0 -> A11
        \\# state B, symbol 1 => write 1, move right, new state B
        \\B1 -> 1B
        \\# state C, symbol 0 => write 1, move left, new state B
        \\0C0 -> B01
        \\1C0 -> B11
        \\# state C, symbol 1 => write 1, move left, halt
        \\0C1 -> H01
        \\1C1 -> H11
    ;

    var rules = try Rules.fromString(allocator, rules_str);
    defer rules.deinit();

    const result = try rules.execute(input);
    defer allocator.free(result);

    try testing.expectEqualStrings("00011H1111000", result);
}
