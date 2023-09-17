const std = @import("std");

pub const ASTInterpreterError = error{OutOfMemory};

pub const ASTInterpreter = struct {
    output: std.ArrayList(u8),
    globals: std.StringHashMap(NodeValue),

    const Self = @This();

    pub fn init(allocator: std.mem.Allocator) Self {
        return ASTInterpreter{
            .output = std.ArrayList(u8).init(allocator),
            .globals = std.StringHashMap(NodeValue).init(allocator),
        };
    }

    // Returning `NodeValue` from this function looks suboptimal and this should
    // probably be a separate type.
    pub fn interp(self: *Self, tree: ?*Tree) ASTInterpreterError!?NodeValue {
        if (tree) |t| {
            switch (t.typ) {
                .sequence => {
                    _ = try self.interp(t.left);
                    _ = try self.interp(t.right);
                },
                .assign => try self.globals.put(
                    t.left.?.value.?.string,
                    (try self.interp(t.right)).?,
                ),
                .identifier => return self.globals.get(t.value.?.string).?,
                .kw_while => {
                    while ((try self.interp(t.left)).?.integer != 0) {
                        _ = try self.interp(t.right);
                    }
                },
                .kw_if => {
                    const condition = (try self.interp(t.left)).?.integer;
                    if (condition == 1) {
                        _ = try self.interp(t.right.?.left);
                    } else {
                        _ = try self.interp(t.right.?.right);
                    }
                },
                .less => return NodeValue{ .integer = try self.binOp(less, t.left, t.right) },
                .less_equal => return NodeValue{ .integer = try self.binOp(less_equal, t.left, t.right) },
                .greater => return NodeValue{ .integer = try self.binOp(greater, t.left, t.right) },
                .greater_equal => return NodeValue{ .integer = try self.binOp(greater_equal, t.left, t.right) },
                .add => return NodeValue{ .integer = try self.binOp(add, t.left, t.right) },
                .subtract => return NodeValue{ .integer = try self.binOp(sub, t.left, t.right) },
                .multiply => return NodeValue{ .integer = try self.binOp(mul, t.left, t.right) },
                .divide => return NodeValue{ .integer = try self.binOp(div, t.left, t.right) },
                .mod => return NodeValue{ .integer = try self.binOp(mod, t.left, t.right) },
                .equal => return NodeValue{ .integer = try self.binOp(equal, t.left, t.right) },
                .not_equal => return NodeValue{ .integer = try self.binOp(not_equal, t.left, t.right) },
                .bool_and => return NodeValue{ .integer = try self.binOp(@"and", t.left, t.right) },
                .bool_or => return NodeValue{ .integer = try self.binOp(@"or", t.left, t.right) },
                .negate => return NodeValue{ .integer = -(try self.interp(t.left)).?.integer },
                .not => {
                    const arg = (try self.interp(t.left)).?.integer;
                    const result: i32 = if (arg == 0) 1 else 0;
                    return NodeValue{ .integer = result };
                },
                .prts => _ = try self.out("{s}", .{(try self.interp(t.left)).?.string}),
                .prti => _ = try self.out("{d}", .{(try self.interp(t.left)).?.integer}),
                .prtc => _ = try self.out("{c}", .{@as(u8, @intCast((try self.interp(t.left)).?.integer))}),
                .string => return t.value,
                .integer => return t.value,
                .unknown => {
                    std.debug.print("\nINTERP: UNKNOWN {}\n", .{t});
                    std.os.exit(1);
                },
            }
        }

        return null;
    }

    pub fn out(self: *Self, comptime format: []const u8, args: anytype) ASTInterpreterError!void {
        try self.output.writer().print(format, args);
    }

    fn binOp(
        self: *Self,
        comptime func: fn (a: i32, b: i32) i32,
        a: ?*Tree,
        b: ?*Tree,
    ) ASTInterpreterError!i32 {
        return func(
            (try self.interp(a)).?.integer,
            (try self.interp(b)).?.integer,
        );
    }

    fn less(a: i32, b: i32) i32 {
        return @intFromBool(a < b);
    }
    fn less_equal(a: i32, b: i32) i32 {
        return @intFromBool(a <= b);
    }
    fn greater(a: i32, b: i32) i32 {
        return @intFromBool(a > b);
    }
    fn greater_equal(a: i32, b: i32) i32 {
        return @intFromBool(a >= b);
    }
    fn equal(a: i32, b: i32) i32 {
        return @intFromBool(a == b);
    }
    fn not_equal(a: i32, b: i32) i32 {
        return @intFromBool(a != b);
    }
    fn add(a: i32, b: i32) i32 {
        return a + b;
    }
    fn sub(a: i32, b: i32) i32 {
        return a - b;
    }
    fn mul(a: i32, b: i32) i32 {
        return a * b;
    }
    fn div(a: i32, b: i32) i32 {
        return @divTrunc(a, b);
    }
    fn mod(a: i32, b: i32) i32 {
        return @mod(a, b);
    }
    fn @"or"(a: i32, b: i32) i32 {
        return @intFromBool((a != 0) or (b != 0));
    }
    fn @"and"(a: i32, b: i32) i32 {
        return @intFromBool((a != 0) and (b != 0));
    }
};

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var arg_it = try std.process.argsWithAllocator(allocator);
    _ = arg_it.next() orelse unreachable; // program name
    const file_name = arg_it.next();
    // We accept both files and standard input.
    var file_handle = blk: {
        if (file_name) |file_name_delimited| {
            const fname: []const u8 = file_name_delimited;
            break :blk try std.fs.cwd().openFile(fname, .{});
        } else {
            break :blk std.io.getStdIn();
        }
    };
    defer file_handle.close();
    const input_content = try file_handle.readToEndAlloc(allocator, std.math.maxInt(usize));

    var string_pool = std.ArrayList([]const u8).init(allocator);
    const ast = try loadAST(allocator, input_content, &string_pool);
    var ast_interpreter = ASTInterpreter.init(allocator);
    _ = try ast_interpreter.interp(ast);
    const result: []const u8 = ast_interpreter.output.items;
    _ = try std.io.getStdOut().write(result);
}

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

    const from_string_map = std.ComptimeStringMap(NodeType, .{
        .{ "UNKNOWN", .unknown },
        .{ "Identifier", .identifier },
        .{ "String", .string },
        .{ "Integer", .integer },
        .{ "Sequence", .sequence },
        .{ "If", .kw_if },
        .{ "Prtc", .prtc },
        .{ "Prts", .prts },
        .{ "Prti", .prti },
        .{ "While", .kw_while },
        .{ "Assign", .assign },
        .{ "Negate", .negate },
        .{ "Not", .not },
        .{ "Multiply", .multiply },
        .{ "Divide", .divide },
        .{ "Mod", .mod },
        .{ "Add", .add },
        .{ "Subtract", .subtract },
        .{ "Less", .less },
        .{ "LessEqual", .less_equal },
        .{ "Greater", .greater },
        .{ "GreaterEqual", .greater_equal },
        .{ "Equal", .equal },
        .{ "NotEqual", .not_equal },
        .{ "And", .bool_and },
        .{ "Or", .bool_or },
    });

    pub fn fromString(str: []const u8) NodeType {
        return from_string_map.get(str).?;
    }
};

pub const NodeValue = union(enum) {
    integer: i32,
    string: []const u8,
};

pub const Tree = struct {
    left: ?*Tree,
    right: ?*Tree,
    typ: NodeType = .unknown,
    value: ?NodeValue = null,

    fn makeNode(allocator: std.mem.Allocator, typ: NodeType, left: ?*Tree, right: ?*Tree) !*Tree {
        const result = try allocator.create(Tree);
        result.* = Tree{ .left = left, .right = right, .typ = typ };
        return result;
    }

    fn makeLeaf(allocator: std.mem.Allocator, typ: NodeType, value: ?NodeValue) !*Tree {
        const result = try allocator.create(Tree);
        result.* = Tree{ .left = null, .right = null, .typ = typ, .value = value };
        return result;
    }
};

const LoadASTError = error{OutOfMemory} || std.fmt.ParseIntError;

fn loadAST(
    allocator: std.mem.Allocator,
    str: []const u8,
    string_pool: *std.ArrayList([]const u8),
) LoadASTError!?*Tree {
    var line_it = std.mem.split(u8, str, "\n");
    return try loadASTHelper(allocator, &line_it, string_pool);
}

fn loadASTHelper(
    allocator: std.mem.Allocator,
    line_it: *std.mem.SplitIterator(u8, std.mem.DelimiterType.sequence),
    string_pool: *std.ArrayList([]const u8),
) LoadASTError!?*Tree {
    if (line_it.next()) |line| {
        var tok_it = std.mem.tokenize(u8, line, " ");
        const tok_str = tok_it.next().?;
        if (tok_str[0] == ';') return null;

        const node_type = NodeType.fromString(tok_str);
        const pre_iteration_index = tok_it.index;

        if (tok_it.next()) |leaf_value| {
            const node_value = blk: {
                switch (node_type) {
                    .integer => break :blk NodeValue{ .integer = try std.fmt.parseInt(i32, leaf_value, 10) },
                    .identifier => break :blk NodeValue{ .string = leaf_value },
                    .string => {
                        tok_it.index = pre_iteration_index;
                        const str = tok_it.rest();
                        var string_literal = try std.ArrayList(u8).initCapacity(allocator, str.len);
                        var escaped = false;
                        // Truncate double quotes
                        for (str[1 .. str.len - 1]) |ch| {
                            if (escaped) {
                                escaped = false;
                                switch (ch) {
                                    'n' => try string_literal.append('\n'),
                                    '\\' => try string_literal.append('\\'),
                                    else => unreachable,
                                }
                            } else {
                                switch (ch) {
                                    '\\' => escaped = true,
                                    else => try string_literal.append(ch),
                                }
                            }
                        }
                        try string_pool.append(string_literal.items);
                        break :blk NodeValue{ .string = string_literal.items };
                    },
                    else => unreachable,
                }
            };
            return try Tree.makeLeaf(allocator, node_type, node_value);
        }

        const left = try loadASTHelper(allocator, line_it, string_pool);
        const right = try loadASTHelper(allocator, line_it, string_pool);
        return try Tree.makeNode(allocator, node_type, left, right);
    } else {
        return null;
    }
}
