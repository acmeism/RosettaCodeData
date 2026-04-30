const std = @import("std");
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const stdout = std.io.getStdOut().writer();

    var a = try BalancedTernary.fromString(allocator, "+-0++0+");
    defer a.deinit();
    const a_val = try a.toI128();
    const a_str = try a.toString(allocator);
    defer allocator.free(a_str);
    try stdout.print("a = {s} = {d}\n", .{ a_str, a_val });

    var b = try BalancedTernary.fromI128(allocator, -436);
    defer b.deinit();
    const b_val = try b.toI128();
    const b_str = try b.toString(allocator);
    defer allocator.free(b_str);
    try stdout.print("b = {s} = {d}\n", .{ b_str, b_val });

    var c = try BalancedTernary.fromString(allocator, "+-++-");
    defer c.deinit();
    const c_val = try c.toI128();
    const c_str = try c.toString(allocator);
    defer allocator.free(c_str);
    try stdout.print("c = {s} = {d}\n", .{ c_str, c_val });

    var c_neg = try c.clone(allocator);
    defer c_neg.deinit();
    c_neg.negate();

    var b_plus_neg_c = try b.add(allocator, c_neg);
    defer b_plus_neg_c.deinit();

    var d = try a.mul(allocator, b_plus_neg_c);
    defer d.deinit();
    const d_val = try d.toI128();
    const d_str = try d.toString(allocator);
    defer allocator.free(d_str);
    try stdout.print("a * (b - c) = {s} = {d}\n", .{ d_str, d_val });

    var e = try BalancedTernary.fromString(allocator, "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    defer e.deinit();
    const e_result = e.toI128();
    try std.testing.expect(e_result == error.Overflow);
}

const Trit = enum {
    Zero,
    Pos,
    Neg,

    fn fromChar(c: u8) !Trit {
        return switch (c) {
            '0' => .Zero,
            '+' => .Pos,
            '-' => .Neg,
            else => error.InvalidCharacter,
        };
    }

    fn toChar(self: Trit) u8 {
        return switch (self) {
            .Zero => '0',
            .Pos => '+',
            .Neg => '-',
        };
    }

    fn add(self: Trit, rhs: Trit) struct { carry: Trit, current: Trit } {
        return switch (self) {
            .Zero => .{ .carry = .Zero, .current = rhs },
            .Pos => switch (rhs) {
                .Zero => .{ .carry = .Zero, .current = .Pos },
                .Neg => .{ .carry = .Zero, .current = .Zero },
                .Pos => .{ .carry = .Pos, .current = .Neg },
            },
            .Neg => switch (rhs) {
                .Zero => .{ .carry = .Zero, .current = .Neg },
                .Pos => .{ .carry = .Zero, .current = .Zero },
                .Neg => .{ .carry = .Neg, .current = .Pos },
            },
        };
    }

    fn mul(self: Trit, rhs: Trit) Trit {
        return switch (self) {
            .Zero => .Zero,
            .Pos => switch (rhs) {
                .Zero => .Zero,
                .Pos => .Pos,
                .Neg => .Neg,
            },
            .Neg => switch (rhs) {
                .Zero => .Zero,
                .Pos => .Neg,
                .Neg => .Pos,
            },
        };
    }

    fn negate(self: Trit) Trit {
        return switch (self) {
            .Zero => .Zero,
            .Pos => .Neg,
            .Neg => .Pos,
        };
    }
};

const BalancedTernary = struct {
    digits: ArrayList(Trit),

    fn deinit(self: *BalancedTernary) void {
        self.digits.deinit();
    }

    fn clone(self: BalancedTernary, allocator: Allocator) !BalancedTernary {
        var new_digits = try ArrayList(Trit).initCapacity(allocator, self.digits.items.len);
        try new_digits.appendSlice(self.digits.items);
        return BalancedTernary{ .digits = new_digits };
    }

    fn fromString(allocator: Allocator, s: []const u8) !BalancedTernary {
        var digits = ArrayList(Trit).init(allocator);
        errdefer digits.deinit();

        var i: usize = s.len;
        while (i > 0) {
            i -= 1;
            const trit = try Trit.fromChar(s[i]);
            try digits.append(trit);
        }

        return BalancedTernary{ .digits = digits };
    }

    fn fromI128(allocator: Allocator, x: i128) !BalancedTernary {
        var digits = ArrayList(Trit).init(allocator);
        errdefer digits.deinit();

        var curr = x;

        while (true) {
            const rem = @rem(curr, 3);

            const trit: Trit = switch (rem) {
                0 => .Zero,
                1, -2 => .Pos,
                2, -1 => .Neg,
                else => unreachable,
            };
            try digits.append(trit);

            const offset = @as(i128, @intFromFloat(@round(@as(f64, @floatFromInt(rem)) / 3.0)));
            curr = @divTrunc(curr, 3) + offset;

            if (curr == 0) break;
        }

        return BalancedTernary{ .digits = digits };
    }

    fn toString(self: BalancedTernary, allocator: Allocator) ![]const u8 {
        var result = try ArrayList(u8).initCapacity(allocator, self.digits.items.len);
        defer result.deinit();

        var i: usize = self.digits.items.len;
        while (i > 0) {
            i -= 1;
            try result.append(self.digits.items[i].toChar());
        }

        return result.toOwnedSlice();
    }

    fn toI128(self: BalancedTernary) !i128 {
        var acc: i128 = 0;

        for (self.digits.items, 0..) |trit, i| {
            const index: u32 = std.math.cast(u32, i) orelse return error.Overflow;

            switch (trit) {
                .Zero => {},
                .Pos => {
                    const power = std.math.powi(i128, 3, index) catch return error.Overflow;
                    acc = std.math.add(i128, acc, power) catch return error.Overflow;
                },
                .Neg => {
                    const power = std.math.powi(i128, 3, index) catch return error.Overflow;
                    acc = std.math.sub(i128, acc, power) catch return error.Overflow;
                },
            }
        }

        return acc;
    }

    fn trim(digits: *ArrayList(Trit)) void {
        while (digits.items.len > 0) {
            const last = digits.items[digits.items.len - 1];
            if (last != .Zero) {
                break;
            }
            _ = digits.pop();
        }
    }

    fn add(self: BalancedTernary, allocator: Allocator, rhs: BalancedTernary) !BalancedTernary {
        if (rhs.digits.items.len == 0) {
            if (self.digits.items.len == 0) {
                var digits = ArrayList(Trit).init(allocator);
                try digits.append(.Zero);
                return BalancedTernary{ .digits = digits };
            }
            return try self.clone(allocator);
        }

        const length = @min(self.digits.items.len, rhs.digits.items.len);
        var sum = ArrayList(Trit).init(allocator);
        errdefer sum.deinit();

        var carry = ArrayList(Trit).init(allocator);
        errdefer carry.deinit();
        try carry.append(.Zero);

        for (0..length) |i| {
            const result = self.digits.items[i].add(rhs.digits.items[i]);
            try sum.append(result.current);
            try carry.append(result.carry);
        }

        if (self.digits.items.len > length) {
            try sum.appendSlice(self.digits.items[length..]);
        }
        if (rhs.digits.items.len > length) {
            try sum.appendSlice(rhs.digits.items[length..]);
        }

        trim(&sum);
        trim(&carry);

        var sum_bt = BalancedTernary{ .digits = sum };
        const carry_bt = BalancedTernary{ .digits = carry };
        //defer carry_bt.deinit();

        return try sum_bt.add(allocator, carry_bt);
    }

    fn mul(self: BalancedTernary, allocator: Allocator, rhs: BalancedTernary) !BalancedTernary {
        var results = ArrayList(BalancedTernary).init(allocator);
        defer {
            for (results.items) |*item| {
                item.deinit();
            }
            results.deinit();
        }

        for (rhs.digits.items, 0..) |rhs_trit, i| {
            var digits = ArrayList(Trit).init(allocator);
            errdefer digits.deinit();

            for (0..i) |_| {
                try digits.append(.Zero);
            }

            for (self.digits.items) |self_trit| {
                try digits.append(self_trit.mul(rhs_trit));
            }

            try results.append(BalancedTernary{ .digits = digits });
        }

        var acc_digits = ArrayList(Trit).init(allocator);
        try acc_digits.append(.Zero);
        var acc = BalancedTernary{ .digits = acc_digits };

        for (results.items) |item| {
            const new_acc = try acc.add(allocator, item);
            acc.deinit();
            acc = new_acc;
        }

        return acc;
    }

    fn negate(self: *BalancedTernary) void {
        for (self.digits.items) |*trit| {
            trit.* = trit.negate();
        }
    }
};
