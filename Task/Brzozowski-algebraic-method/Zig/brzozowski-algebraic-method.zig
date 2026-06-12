const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    //
    var pool = RegularExpressionPool.init(std.heap.page_allocator);
    defer _ = pool.deinit();
    //
    // Define the NFA transition matrix a
    const array = try allocator.alloc(*RegularExpression, 9);
    defer allocator.free(array);
    var a = try allocator.alloc([]*RegularExpression, 3);
    defer allocator.free(a);
    for (0..3) |i| a[i] = array[i * 3 .. i * 3 + 3]; // define row slices
    a[0][0] = try EmptyExpr.init(&pool);
    a[0][1] = try CarExpr.init(&pool, 'a');
    a[0][2] = try CarExpr.init(&pool, 'b');
    a[1][0] = try CarExpr.init(&pool, 'b');
    a[1][1] = try EmptyExpr.init(&pool);
    a[1][2] = try CarExpr.init(&pool, 'a');
    a[2][0] = try CarExpr.init(&pool, 'a');
    a[2][1] = try CarExpr.init(&pool, 'b');
    a[2][2] = try EmptyExpr.init(&pool);

    // Define the initial state vector b
    const b = try allocator.alloc(*RegularExpression, 3);
    defer allocator.free(b);
    b[0] = try EpsilonExpr.init(&pool);
    b[1] = try EmptyExpr.init(&pool);
    b[2] = try EmptyExpr.init(&pool);
    //
    const writer = std.io.getStdOut().writer();

    // Apply Brzozowski's algorithm
    const dfa_expr = try brzozowski(&pool, a, b);

    // Print the regular expression
    try writer.print("{}\n\n", .{dfa_expr});

    // Apply recursive simplification
    const simplified_expr = try recursiveSimplify(&pool, dfa_expr, 0);
    try writer.print("{}\n", .{simplified_expr});
}

fn brzozowski(pool: *RegularExpressionPool, a_: [][]*RegularExpression, b_: []*RegularExpression) !*RegularExpression {
    const a = a_;
    var b = b_;
    var n = a_.len;
    while (n != 0) {
        n -= 1;
        b[n] = try ConcatExpr.init(pool, try StarExpr.init(pool, a[n][n]), b[n]);
        for (0..n) |j|
            a[n][j] = try ConcatExpr.init(pool, try StarExpr.init(pool, a[n][n]), a[n][j]);
        for (0..n) |i| {
            b[i] = try UnionExpr.init(pool, b[i], try ConcatExpr.init(pool, a[i][n], b[n]));
            for (0..n) |j|
                a[i][j] = try UnionExpr.init(pool, a[i][j], try ConcatExpr.init(pool, a[i][n], a[n][j]));
        }
        for (0..n) |i|
            a[i][n] = try EmptyExpr.init(pool);
    }
    return b[0];
}

fn recursiveSimplify(pool: *RegularExpressionPool, expr: *RegularExpression, depth: usize) !*RegularExpression {
    if (depth > 200)
        return expr
    else {
        const simplified = try expr.simplify(pool);
        if (simplified.eql(expr))
            return simplified
        else
            return recursiveSimplify(pool, simplified, depth + 1);
    }
}

const RegularExpressionType = enum {
    empty,
    car,
    epsilon,
    @"union",
    concat,
    star,
};

const RegularExpressionPool = std.heap.MemoryPoolExtra(RegularExpression, .{});

const RegularExpression = union(RegularExpressionType) {
    const Self = @This();

    empty: EmptyExpr,
    car: CarExpr,
    epsilon: EpsilonExpr,
    @"union": UnionExpr, // union is a keyword, @"union" is ok
    concat: ConcatExpr,
    star: StarExpr,

    fn eql(self: *const Self, other: *const Self) bool {
        // note: .@"union" is commutative
        switch (self.*) {
            inline else => |re| return re.eql(other),
        }
    }
    fn simplify(self: *Self, pool: *RegularExpressionPool) error{OutOfMemory}!*Self {
        switch (self.*) {
            .empty, .car, .epsilon => return self,
            inline else => |*re| return re.simplify(pool),
        }
    }
    // refer to std.format.format documentation
    pub fn format(self: *const Self, comptime _: []const u8, _: std.fmt.FormatOptions, writer: anytype) !void {
        switch (self.*) {
            inline else => |re| try re.write(writer),
        }
    }
    fn getFieldName(comptime T: type) []const u8 {
        inline for (@typeInfo(Self).@"union".fields) |field|
            if (field.type == T)
                return field.name;
        unreachable;
    }
};
const EmptyExpr = struct {
    fn init(pool: *RegularExpressionPool) !*RegularExpression {
        const self = try pool.create();
        self.* = .{ .empty = .{} };
        return self;
    }
    fn eql(_: *const EmptyExpr, other: *const RegularExpression) bool {
        return switch (other.*) {
            .empty => true,
            else => false,
        };
    }
    fn write(_: *const EmptyExpr, writer: anytype) !void {
        try writer.writeByte('0');
    }
};
const EpsilonExpr = struct {
    fn init(pool: *RegularExpressionPool) !*RegularExpression {
        const self = try pool.create();
        self.* = .{ .epsilon = .{} };
        return self;
    }
    fn eql(_: *const EpsilonExpr, other: *const RegularExpression) bool {
        return switch (other.*) {
            .epsilon => true,
            else => false,
        };
    }
    fn write(_: *const EpsilonExpr, writer: anytype) !void {
        try writer.writeByte('1');
    }
};
const CarExpr = struct {
    c: u8,
    fn init(pool: *RegularExpressionPool, c: u8) !*RegularExpression {
        const self = try pool.create();
        self.* = .{ .car = .{ .c = c } };
        return self;
    }
    fn eql(self: *const CarExpr, other: *const RegularExpression) bool {
        return switch (other.*) {
            .car => |car| self.c == car.c,
            else => false,
        };
    }
    fn write(self: *const CarExpr, writer: anytype) !void {
        try writer.writeByte(self.c);
    }
};
const UnionExpr = struct {
    e: *RegularExpression,
    f: *RegularExpression,
    fn init(pool: *RegularExpressionPool, e: *RegularExpression, f: *RegularExpression) !*RegularExpression {
        const self = try pool.create();
        self.* = .{ .@"union" = .{ .e = e, .f = f } };
        return self;
    }
    fn eql(s: *const UnionExpr, other: *const RegularExpression) bool {
        switch (other.*) {
            .@"union" => |o| {
                // Since Union is commutative, check both orders
                return (s.e.eql(o.e) and s.f.eql(o.f)) or (s.e.eql(o.f) and s.f.eql(o.e));
            },
            else => return false,
        }
    }
    fn simplify(self: *UnionExpr, pool: *RegularExpressionPool) !*RegularExpression {
        const e = try self.e.simplify(pool);
        const f = try self.f.simplify(pool);
        if (e.eql(f))
            return e;
        switch (e.*) {
            .empty => return f,
            else => {},
        }
        switch (f.*) {
            .empty => return e,
            else => {},
        }
        // // new struct, pool allocation,
        // return UnionExpr.init(pool, e, f);

        // reuse struct, no pool allocation
        self.* = .{ .e = e, .f = f };
        const name = comptime RegularExpression.getFieldName(@TypeOf(self.*));
        return @fieldParentPtr(name, self);
    }
    fn write(self: *const UnionExpr, writer: anytype) !void {
        try writer.print("{}+{}", .{ self.e, self.f });
    }
};
const ConcatExpr = struct {
    e: *RegularExpression,
    f: *RegularExpression,
    fn init(pool: *RegularExpressionPool, e: *RegularExpression, f: *RegularExpression) !*RegularExpression {
        const self = try pool.create();
        self.* = .{ .concat = .{ .e = e, .f = f } };
        return self;
    }
    fn eql(s: *const ConcatExpr, other: *const RegularExpression) bool {
        return switch (other.*) {
            .concat => |o| s.e.eql(o.e) and s.f.eql(o.f),
            else => false,
        };
    }
    fn simplify(self: *ConcatExpr, pool: *RegularExpressionPool) !*RegularExpression {
        const e = try self.e.simplify(pool);
        const f = try self.f.simplify(pool);
        switch (e.*) {
            .epsilon => return f,
            else => {},
        }
        switch (f.*) {
            .empty => return EmptyExpr.init(pool),
            .epsilon => return e,
            else => {},
        }
        switch (f.*) {
            .empty => return EmptyExpr.init(pool),
            else => {},
        }
        // // new struct, pool allocation,
        // return ConcatExpr.init(pool, e, f);

        // reuse struct, no pool allocation
        self.* = .{ .e = e, .f = f };
        const name = comptime RegularExpression.getFieldName(@TypeOf(self.*));
        return @fieldParentPtr(name, self);
    }
    fn write(self: *const ConcatExpr, writer: anytype) !void {
        try writer.print("({})({})", .{ self.e, self.f });
    }
};
const StarExpr = struct {
    e: *RegularExpression,
    fn init(pool: *RegularExpressionPool, e: *RegularExpression) !*RegularExpression {
        const self = try pool.create();
        self.* = .{ .star = .{ .e = e } };
        return self;
    }
    fn eql(s: *const StarExpr, other: *const RegularExpression) bool {
        return switch (other.*) {
            .star => |o| s.e.eql(o.e),
            else => false,
        };
    }
    fn simplify(self: *StarExpr, pool: *RegularExpressionPool) !*RegularExpression {
        const e = try self.e.simplify(pool);
        switch (e.*) {
            .empty => return EpsilonExpr.init(pool),
            .epsilon => return e,
            else => {},
        }
        // // new struct, pool allocation,
        // return StarExpr.init(pool, e);

        // reuse struct, no pool allocation
        self.* = .{ .e = e };
        const name = comptime RegularExpression.getFieldName(@TypeOf(self.*));
        return @fieldParentPtr(name, self);
    }
    fn write(self: *const StarExpr, writer: anytype) !void {
        try writer.print("({})*", .{self.e});
    }
};
