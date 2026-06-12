const std = @import("std");
const print = std.debug.print;
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

// Interface for continued fraction representations
const ContinuedFraction = struct {
    ptr: *anyopaque,
    vtable: *const VTable,

    const VTable = struct {
        has_more_terms: *const fn (ptr: *anyopaque) bool,
        next_term: *const fn (ptr: *anyopaque) i64,
        deinit: *const fn (ptr: *anyopaque, allocator: Allocator) void,
    };

    pub fn has_more_terms(self: *ContinuedFraction) bool {
        return self.vtable.has_more_terms(self.ptr);
    }

    pub fn next_term(self: *ContinuedFraction) i64 {
        return self.vtable.next_term(self.ptr);
    }

    pub fn deinit(self: *ContinuedFraction, allocator: Allocator) void {
        return self.vtable.deinit(self.ptr, allocator);
    }
};

// Rational to continued fraction converter
const R2cf = struct {
    n1: i64,
    n2: i64,

    pub fn init(n1: i64, n2: i64) R2cf {
        return R2cf{ .n1 = n1, .n2 = n2 };
    }

    pub fn has_more_terms(self: *R2cf) bool {
        return @abs(self.n2) > 0;
    }

    pub fn next_term(self: *R2cf) i64 {
        const term = @divTrunc(self.n1, self.n2);
        const temp = self.n2;
        self.n2 = self.n1 - term * self.n2;
        self.n1 = temp;
        return term;
    }

    pub fn as_continued_fraction(self: *R2cf, allocator: Allocator) !ContinuedFraction {
        _ = allocator;
        return ContinuedFraction{
            .ptr = self,
            .vtable = &.{
                .has_more_terms = r2cf_has_more_terms,
                .next_term = r2cf_next_term,
                .deinit = r2cf_deinit,
            },
        };
    }

    fn r2cf_has_more_terms(ptr: *anyopaque) bool {
        const self: *R2cf = @ptrCast(@alignCast(ptr));
        return self.has_more_terms();
    }

    fn r2cf_next_term(ptr: *anyopaque) i64 {
        const self: *R2cf = @ptrCast(@alignCast(ptr));
        return self.next_term();
    }

    fn r2cf_deinit(ptr: *anyopaque, allocator: Allocator) void {
        _ = ptr;
        _ = allocator;
        // R2cf doesn't need deallocation
    }
};

// Base interface for matrix operations
const MatrixNG = struct {
    ptr: *anyopaque,
    vtable: *const VTable,

    const VTable = struct {
        consume_term: *const fn (ptr: *anyopaque) void,
        consume_term_with_n: *const fn (ptr: *anyopaque, n: i64) void,
        needs_term: *const fn (ptr: *anyopaque) bool,
        get_configuration: *const fn (ptr: *anyopaque) usize,
        get_current_term: *const fn (ptr: *anyopaque) i64,
        has_term: *const fn (ptr: *anyopaque) bool,
        set_has_term: *const fn (ptr: *anyopaque, value: bool) void,
    };

    pub fn consume_term(self: *MatrixNG) void {
        return self.vtable.consume_term(self.ptr);
    }

    pub fn consume_term_with_n(self: *MatrixNG, n: i64) void {
        return self.vtable.consume_term_with_n(self.ptr, n);
    }

    pub fn needs_term(self: *MatrixNG) bool {
        return self.vtable.needs_term(self.ptr);
    }

    pub fn get_configuration(self: *MatrixNG) usize {
        return self.vtable.get_configuration(self.ptr);
    }

    pub fn get_current_term(self: *MatrixNG) i64 {
        return self.vtable.get_current_term(self.ptr);
    }

    pub fn has_term(self: *MatrixNG) bool {
        return self.vtable.has_term(self.ptr);
    }

    pub fn set_has_term(self: *MatrixNG, value: bool) void {
        return self.vtable.set_has_term(self.ptr, value);
    }
};

// 4-element matrix for single continued fraction operations
const NG4 = struct {
    a1: i64,
    a: i64,
    b1: i64,
    b: i64,
    current_term: i64,
    has_term_flag: bool,

    pub fn init(a1: i64, a: i64, b1: i64, b: i64) NG4 {
        return NG4{
            .a1 = a1,
            .a = a,
            .b1 = b1,
            .b = b,
            .current_term = 0,
            .has_term_flag = false,
        };
    }

    pub fn consume_term(self: *NG4) void {
        self.a = self.a1;
        self.b = self.b1;
    }

    pub fn consume_term_with_n(self: *NG4, n: i64) void {
        const temp = self.a;
        self.a = self.a1;
        self.a1 = temp + self.a1 * n;
        const temp_b = self.b;
        self.b = self.b1;
        self.b1 = temp_b + self.b1 * n;
    }

    pub fn needs_term(self: *NG4) bool {
        if (self.b1 == 0 and self.b == 0) {
            return false;
        }
        if (self.b1 == 0 or self.b == 0) {
            return true;
        }

        self.current_term = @divTrunc(self.a, self.b);
        if (self.current_term == @divTrunc(self.a1, self.b1)) {
            const temp = self.a;
            self.a = self.b;
            self.b = temp - self.b * self.current_term;
            const temp1 = self.a1;
            self.a1 = self.b1;
            self.b1 = temp1 - self.b1 * self.current_term;

            self.has_term_flag = true;
            return false;
        }
        return true;
    }

    pub fn get_configuration(self: *NG4) usize {
        _ = self;
        return 0;
    }

    pub fn get_current_term(self: *NG4) i64 {
        return self.current_term;
    }

    pub fn has_term(self: *NG4) bool {
        return self.has_term_flag;
    }

    pub fn set_has_term(self: *NG4, value: bool) void {
        self.has_term_flag = value;
    }

    pub fn as_matrix_ng(self: *NG4) MatrixNG {
        return MatrixNG{
            .ptr = self,
            .vtable = &.{
                .consume_term = ng4_consume_term,
                .consume_term_with_n = ng4_consume_term_with_n,
                .needs_term = ng4_needs_term,
                .get_configuration = ng4_get_configuration,
                .get_current_term = ng4_get_current_term,
                .has_term = ng4_has_term,
                .set_has_term = ng4_set_has_term,
            },
        };
    }

    fn ng4_consume_term(ptr: *anyopaque) void {
        const self: *NG4 = @ptrCast(@alignCast(ptr));
        self.consume_term();
    }

    fn ng4_consume_term_with_n(ptr: *anyopaque, n: i64) void {
        const self: *NG4 = @ptrCast(@alignCast(ptr));
        self.consume_term_with_n(n);
    }

    fn ng4_needs_term(ptr: *anyopaque) bool {
        const self: *NG4 = @ptrCast(@alignCast(ptr));
        return self.needs_term();
    }

    fn ng4_get_configuration(ptr: *anyopaque) usize {
        const self: *NG4 = @ptrCast(@alignCast(ptr));
        return self.get_configuration();
    }

    fn ng4_get_current_term(ptr: *anyopaque) i64 {
        const self: *NG4 = @ptrCast(@alignCast(ptr));
        return self.get_current_term();
    }

    fn ng4_has_term(ptr: *anyopaque) bool {
        const self: *NG4 = @ptrCast(@alignCast(ptr));
        return self.has_term();
    }

    fn ng4_set_has_term(ptr: *anyopaque, value: bool) void {
        const self: *NG4 = @ptrCast(@alignCast(ptr));
        self.set_has_term(value);
    }
};

// 8-element matrix for two continued fraction operations
const NG8 = struct {
    a12: i64,
    a1: i64,
    a2: i64,
    a: i64,
    b12: i64,
    b1: i64,
    b2: i64,
    b: i64,
    ab: f64,
    a1b1: f64,
    a2b2: f64,
    a12b12: f64,
    configuration: usize,
    current_term: i64,
    has_term_flag: bool,

    pub fn init(a12: i64, a1: i64, a2: i64, a: i64, b12: i64, b1: i64, b2: i64, b: i64) NG8 {
        return NG8{
            .a12 = a12,
            .a1 = a1,
            .a2 = a2,
            .a = a,
            .b12 = b12,
            .b1 = b1,
            .b2 = b2,
            .b = b,
            .ab = 0.0,
            .a1b1 = 0.0,
            .a2b2 = 0.0,
            .a12b12 = 0.0,
            .configuration = 0,
            .current_term = 0,
            .has_term_flag = false,
        };
    }

    fn set_configuration(self: *NG8) usize {
        if (@abs(self.a1b1 - self.ab) > @abs(self.a2b2 - self.ab)) {
            return 0;
        } else {
            return 1;
        }
    }

    pub fn consume_term(self: *NG8) void {
        if (self.configuration == 0) {
            self.a = self.a1;
            self.a2 = self.a12;
            self.b = self.b1;
            self.b2 = self.b12;
        } else {
            self.a = self.a2;
            self.a1 = self.a12;
            self.b = self.b2;
            self.b1 = self.b12;
        }
    }

    pub fn consume_term_with_n(self: *NG8, n: i64) void {
        if (self.configuration == 0) {
            const temp = self.a;
            self.a = self.a1;
            self.a1 = temp + self.a1 * n;
            const temp2 = self.a2;
            self.a2 = self.a12;
            self.a12 = temp2 + self.a12 * n;
            const temp_b = self.b;
            self.b = self.b1;
            self.b1 = temp_b + self.b1 * n;
            const temp2_b = self.b2;
            self.b2 = self.b12;
            self.b12 = temp2_b + self.b12 * n;
        } else {
            const temp = self.a;
            self.a = self.a2;
            self.a2 = temp + self.a2 * n;
            const temp1 = self.a1;
            self.a1 = self.a12;
            self.a12 = temp1 + self.a12 * n;
            const temp_b = self.b;
            self.b = self.b2;
            self.b2 = temp_b + self.b2 * n;
            const temp1_b = self.b1;
            self.b1 = self.b12;
            self.b12 = temp1_b + self.b12 * n;
        }
    }

    pub fn needs_term(self: *NG8) bool {
        if (self.b1 == 0 and self.b == 0 and self.b2 == 0 and self.b12 == 0) {
            return false;
        }

        if (self.b == 0) {
            self.configuration = if (self.b2 == 0) 0 else 1;
            return true;
        }
        self.ab = @as(f64, @floatFromInt(self.a)) / @as(f64, @floatFromInt(self.b));

        if (self.b2 == 0) {
            self.configuration = 1;
            return true;
        }
        self.a2b2 = @as(f64, @floatFromInt(self.a2)) / @as(f64, @floatFromInt(self.b2));

        if (self.b1 == 0) {
            self.configuration = 0;
            return true;
        }
        self.a1b1 = @as(f64, @floatFromInt(self.a1)) / @as(f64, @floatFromInt(self.b1));

        if (self.b12 == 0) {
            self.configuration = self.set_configuration();
            return true;
        }
        self.a12b12 = @as(f64, @floatFromInt(self.a12)) / @as(f64, @floatFromInt(self.b12));

        self.current_term = @as(i64, @intFromFloat(@floor(self.ab)));
        if (self.current_term == @as(i64, @intFromFloat(@floor(self.a1b1))) and
            self.current_term == @as(i64, @intFromFloat(@floor(self.a2b2))) and
            self.current_term == @as(i64, @intFromFloat(@floor(self.a12b12))))
        {
            const temp = self.a;
            self.a = self.b;
            self.b = temp - self.b * self.current_term;
            const temp1 = self.a1;
            self.a1 = self.b1;
            self.b1 = temp1 - self.b1 * self.current_term;
            const temp2 = self.a2;
            self.a2 = self.b2;
            self.b2 = temp2 - self.b2 * self.current_term;
            const temp12 = self.a12;
            self.a12 = self.b12;
            self.b12 = temp12 - self.b12 * self.current_term;

            self.has_term_flag = true;
            return false;
        }
        self.configuration = self.set_configuration();
        return true;
    }

    pub fn get_configuration(self: *NG8) usize {
        return self.configuration;
    }

    pub fn get_current_term(self: *NG8) i64 {
        return self.current_term;
    }

    pub fn has_term(self: *NG8) bool {
        return self.has_term_flag;
    }

    pub fn set_has_term(self: *NG8, value: bool) void {
        self.has_term_flag = value;
    }

    pub fn as_matrix_ng(self: *NG8) MatrixNG {
        return MatrixNG{
            .ptr = self,
            .vtable = &.{
                .consume_term = ng8_consume_term,
                .consume_term_with_n = ng8_consume_term_with_n,
                .needs_term = ng8_needs_term,
                .get_configuration = ng8_get_configuration,
                .get_current_term = ng8_get_current_term,
                .has_term = ng8_has_term,
                .set_has_term = ng8_set_has_term,
            },
        };
    }

    fn ng8_consume_term(ptr: *anyopaque) void {
        const self: *NG8 = @ptrCast(@alignCast(ptr));
        self.consume_term();
    }

    fn ng8_consume_term_with_n(ptr: *anyopaque, n: i64) void {
        const self: *NG8 = @ptrCast(@alignCast(ptr));
        self.consume_term_with_n(n);
    }

    fn ng8_needs_term(ptr: *anyopaque) bool {
        const self: *NG8 = @ptrCast(@alignCast(ptr));
        return self.needs_term();
    }

    fn ng8_get_configuration(ptr: *anyopaque) usize {
        const self: *NG8 = @ptrCast(@alignCast(ptr));
        return self.get_configuration();
    }

    fn ng8_get_current_term(ptr: *anyopaque) i64 {
        const self: *NG8 = @ptrCast(@alignCast(ptr));
        return self.get_current_term();
    }

    fn ng8_has_term(ptr: *anyopaque) bool {
        const self: *NG8 = @ptrCast(@alignCast(ptr));
        return self.has_term();
    }

    fn ng8_set_has_term(ptr: *anyopaque, value: bool) void {
        const self: *NG8 = @ptrCast(@alignCast(ptr));
        self.set_has_term(value);
    }
};

// Generic continued fraction generator
const NG = struct {
    matrix_ng: MatrixNG,
    cf: ArrayList(ContinuedFraction),
    allocator: Allocator,

    pub fn init(allocator: Allocator, matrix_ng: MatrixNG, cf1: ContinuedFraction) !NG {
        var cf_list = ArrayList(ContinuedFraction).init(allocator);
        try cf_list.append(cf1);
        return NG{
            .matrix_ng = matrix_ng,
            .cf = cf_list,
            .allocator = allocator,
        };
    }

    pub fn init_with_two_cf(allocator: Allocator, matrix_ng: MatrixNG, cf1: ContinuedFraction, cf2: ContinuedFraction) !NG {
        var cf_list = ArrayList(ContinuedFraction).init(allocator);
        try cf_list.append(cf1);
        try cf_list.append(cf2);
        return NG{
            .matrix_ng = matrix_ng,
            .cf = cf_list,
            .allocator = allocator,
        };
    }

    pub fn deinit(self: *NG) void {
        for (self.cf.items) |*cf| {
            cf.deinit(self.allocator);
        }
        self.cf.deinit();
    }

    pub fn has_more_terms(self: *NG) bool {
        while (self.matrix_ng.needs_term()) {
            const config = self.matrix_ng.get_configuration();
            if (config < self.cf.items.len and self.cf.items[config].has_more_terms()) {
                const term = self.cf.items[config].next_term();
                self.matrix_ng.consume_term_with_n(term);
            } else {
                self.matrix_ng.consume_term();
            }
        }
        return self.matrix_ng.has_term();
    }

    pub fn next_term(self: *NG) i64 {
        self.matrix_ng.set_has_term(false);
        return self.matrix_ng.get_current_term();
    }

    pub fn as_continued_fraction(self: *NG, allocator: Allocator) !ContinuedFraction {
        _ = allocator;
        return ContinuedFraction{
            .ptr = self,
            .vtable = &.{
                .has_more_terms = ng_has_more_terms,
                .next_term = ng_next_term,
                .deinit = ng_deinit,
            },
        };
    }

    fn ng_has_more_terms(ptr: *anyopaque) bool {
        const self: *NG = @ptrCast(@alignCast(ptr));
        return self.has_more_terms();
    }

    fn ng_next_term(ptr: *anyopaque) i64 {
        const self: *NG = @ptrCast(@alignCast(ptr));
        return self.next_term();
    }

    fn ng_deinit(ptr: *anyopaque, allocator: Allocator) void {
        const self: *NG = @ptrCast(@alignCast(ptr));
        _ = allocator;
        self.deinit();
    }
};

fn test_fractions(allocator: Allocator, description: []const u8, fractions: []ContinuedFraction) !void {
    print("Testing: {s}\n", .{description});

    for (fractions) |*fraction| {
        var terms = ArrayList([]const u8).init(allocator);
        defer {
            for (terms.items) |term| {
                allocator.free(term);
            }
            terms.deinit();
        }

        while (fraction.has_more_terms()) {
            const term = fraction.next_term();
            const term_str = try std.fmt.allocPrint(allocator, "{d}", .{term});
            try terms.append(term_str);
        }

        for (terms.items, 0..) |term, i| {
            if (i > 0) print(" ", .{});
            print("{s}", .{term});
        }
        print("\n" , .{});
    }

    print("\n" , .{});
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // [3; 7] + [0; 2]
    {
        var r2cf1 = R2cf.init(1, 2);
        var r2cf2 = R2cf.init(22, 7);
        var ng8_1 = NG8.init(0, 1, 1, 0, 0, 0, 0, 1);
        var ng1 = try NG.init_with_two_cf(allocator, ng8_1.as_matrix_ng(), try r2cf1.as_continued_fraction(allocator), try r2cf2.as_continued_fraction(allocator));
        defer ng1.deinit();

        var r2cf3 = R2cf.init(22, 7);
        var ng4_1 = NG4.init(2, 1, 0, 2);
        var ng2 = try NG.init(allocator, ng4_1.as_matrix_ng(), try r2cf3.as_continued_fraction(allocator));
        defer ng2.deinit();

        var fractions = [_]ContinuedFraction{ try ng1.as_continued_fraction(allocator), try ng2.as_continued_fraction(allocator) };
        try test_fractions(allocator, "[3; 7] + [0; 2]", &fractions);
    }

    // [1; 5, 2] * [3; 7]
    {
        var r2cf1 = R2cf.init(13, 11);
        var r2cf2 = R2cf.init(22, 7);
        var ng8_1 = NG8.init(1, 0, 0, 0, 0, 0, 0, 1);
        var ng3 = try NG.init_with_two_cf(allocator, ng8_1.as_matrix_ng(), try r2cf1.as_continued_fraction(allocator), try r2cf2.as_continued_fraction(allocator));
        defer ng3.deinit();

        var r2cf3 = R2cf.init(286, 77);

        var fractions = [_]ContinuedFraction{ try ng3.as_continued_fraction(allocator), try r2cf3.as_continued_fraction(allocator) };
        try test_fractions(allocator, "[1; 5, 2] * [3; 7]", &fractions);
    }

    // [1; 5, 2] - [3; 7]
    {
        var r2cf1 = R2cf.init(13, 11);
        var r2cf2 = R2cf.init(22, 7);
        var ng8_1 = NG8.init(0, 1, -1, 0, 0, 0, 0, 1);
        var ng4 = try NG.init_with_two_cf(allocator, ng8_1.as_matrix_ng(), try r2cf1.as_continued_fraction(allocator), try r2cf2.as_continued_fraction(allocator));
        defer ng4.deinit();

        var r2cf3 = R2cf.init(-151, 77);

        var fractions = [_]ContinuedFraction{ try ng4.as_continued_fraction(allocator), try r2cf3.as_continued_fraction(allocator) };
        try test_fractions(allocator, "[1; 5, 2] - [3; 7]", &fractions);
    }

    // Divide [] by [3; 7]
    {
        var r2cf1 = R2cf.init(22 * 22, 7 * 7);
        var r2cf2 = R2cf.init(22, 7);
        var ng8_1 = NG8.init(0, 1, 0, 0, 0, 0, 1, 0);
        var ng5 = try NG.init_with_two_cf(allocator, ng8_1.as_matrix_ng(), try r2cf1.as_continued_fraction(allocator), try r2cf2.as_continued_fraction(allocator));
        defer ng5.deinit();

        var fractions = [_]ContinuedFraction{try ng5.as_continued_fraction(allocator)};
        try test_fractions(allocator, "Divide [] by [3; 7]", &fractions);
    }

    // ([0; 3, 2] + [1; 5, 2]) * ([0; 3, 2] - [1; 5, 2])
    {
        // Inner NG1: [0; 3, 2] + [1; 5, 2]
        var r2cf_inner1_1 = R2cf.init(2, 7);
        var r2cf_inner1_2 = R2cf.init(13, 11);
        var ng8_inner1 = NG8.init(0, 1, 1, 0, 0, 0, 0, 1);
        var inner_ng1 = try NG.init_with_two_cf(allocator, ng8_inner1.as_matrix_ng(), try r2cf_inner1_1.as_continued_fraction(allocator), try r2cf_inner1_2.as_continued_fraction(allocator));
        defer inner_ng1.deinit();

        // Inner NG2: [0; 3, 2] - [1; 5, 2]
        var r2cf_inner2_1 = R2cf.init(2, 7);
        var r2cf_inner2_2 = R2cf.init(13, 11);
        var ng8_inner2 = NG8.init(0, 1, -1, 0, 0, 0, 0, 1);
        var inner_ng2 = try NG.init_with_two_cf(allocator, ng8_inner2.as_matrix_ng(), try r2cf_inner2_1.as_continued_fraction(allocator), try r2cf_inner2_2.as_continued_fraction(allocator));
        defer inner_ng2.deinit();

        // Outer multiplication
        var ng8_outer = NG8.init(1, 0, 0, 0, 0, 0, 0, 1);
        var ng6 = try NG.init_with_two_cf(allocator, ng8_outer.as_matrix_ng(), try inner_ng1.as_continued_fraction(allocator), try inner_ng2.as_continued_fraction(allocator));
        defer ng6.deinit();

        var r2cf_result = R2cf.init(-7797, 5929);

        var fractions = [_]ContinuedFraction{ try ng6.as_continued_fraction(allocator), try r2cf_result.as_continued_fraction(allocator) };
        try test_fractions(allocator, "([0; 3, 2] + [1; 5, 2]) * ([0; 3, 2] - [1; 5, 2])", &fractions);
    }
}
