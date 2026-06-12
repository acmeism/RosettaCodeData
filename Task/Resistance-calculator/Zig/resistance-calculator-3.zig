// common.zig
const std = @import("std");
const Allocator = std.mem.Allocator;

// Zig "enum"
const NodeType = enum {
    serial,
    parallel,
    resistor,

    fn repr(self: NodeType) u8 {
        return switch (self) {
            .serial => '+',
            .parallel => '*',
            .resistor => 'r',
        };
    }
};

// Zig "tagged union"
pub const PostfixToken = union(NodeType) {
    serial, // '+'
    parallel, // '*'

    // Slice of digits from parent string.
    // Do not let the parent string go out of scope while this is in scope.
    resistor: []const u8, // 'r'
};

// Zig "struct"
pub const Node = struct {
    node_type: NodeType,
    resistance: ?f32 = null, // optional float, either value or null
    voltage: ?f32 = null,
    a: ?*Node = null, // optional pointer to Node, either value or null
    b: ?*Node = null,

    pub fn res(self: *Node) f32 {
        return switch (self.node_type) {
            .serial => self.a.?.res() + self.b.?.res(),
            .parallel => 1 / (1 / self.a.?.res() + 1 / self.b.?.res()),
            .resistor => if (self.resistance) |resistance| resistance else unreachable,
        };
    }

    pub fn current(self: *Node) f32 {
        if (self.voltage) |voltage| return voltage / self.res() else unreachable;
    }

    pub fn effect(self: *Node) f32 {
        if (self.voltage) |voltage| return self.current() * voltage else unreachable;
    }

    pub fn setVoltage(self: *Node, voltage: f32) void {
        self.voltage = voltage;
        switch (self.node_type) {
            .serial => {
                const ra: f32 = self.a.?.res();
                const rb: f32 = self.b.?.res();
                self.a.?.setVoltage(ra / (ra + rb) * voltage);
                self.b.?.setVoltage(rb / (ra + rb) * voltage);
            },
            .parallel => {
                self.a.?.setVoltage(voltage);
                self.b.?.setVoltage(voltage);
            },
            .resistor => {},
        }
    }

    pub fn report(self: *Node, allocator: Allocator, writer: anytype, level: []const u8) !void {
        if (self.voltage) |voltage| {
            try writer.print("{d:8.3} {d:8.3} {d:8.3} {d:8.3}  {s}{c}\n", .{
                self.res(),    voltage, self.current(),
                self.effect(), level,   self.node_type.repr(),
            });
        } else unreachable;
        // iterate though 'a' and 'b' optional nodes
        for ([2]?*Node{ self.a, self.b }) |optional_node| {
            if (optional_node) |node| {
                const next_level = try std.fmt.allocPrint(allocator, "{s}| ", .{level});
                defer allocator.free(next_level);
                try node.report(allocator, writer, next_level);
            }
        }
    }

    /// Free memory allocated to Node descendants and Node itself.
    pub fn destroyDescendants(self: *Node, allocator: Allocator) void {
        if (self.a) |a| {
            self.a = null;
            a.destroyDescendants(allocator);
            allocator.destroy(a);
        }
        if (self.b) |b| {
            self.b = null;
            b.destroyDescendants(allocator);
            allocator.destroy(b);
        }
    }
};

fn build(allocator: Allocator, tokens: []PostfixToken) !*Node {
    var stack = Stack(*Node).init(allocator);
    defer stack.deinit();

    for (tokens) |token| {
        const node = try allocator.create(Node);

        // 'token' is a tagged union.
        // note the extraction of the '.resistor' variable via |r|
        node.* = switch (token) {
            .serial => Node{ .node_type = NodeType.serial, .b = stack.pop(), .a = stack.pop() },
            .parallel => Node{ .node_type = NodeType.parallel, .b = stack.pop(), .a = stack.pop() },
            .resistor => |r| Node{ .node_type = NodeType.resistor, .resistance = try std.fmt.parseFloat(f32, r) },
        };
        try stack.push(node);
    }
    std.debug.assert(stack.hasOne()); // stack length should be 1.

    return stack.pop();
}

pub fn calculate(allocator: Allocator, writer: anytype, voltage: f32, tokens: []PostfixToken) !*Node {
    try writer.print("     Ohm     Volt   Ampere     Watt  Network tree\n", .{});

    var node = try build(allocator, tokens);
    node.setVoltage(voltage);
    try node.report(allocator, writer, "");
    return node;
}

// Zig "Generic Data Structure"
// An ad hoc generic stack implementation.
// 'pub' is the Zig way of giving visibility outside module scope.
pub fn Stack(comptime T: type) type {
    return struct {
        const Self = @This();
        stack: std.ArrayList(T),

        pub fn init(allocator: Allocator) Self {
            return Self{
                .stack = std.ArrayList(T).init(allocator),
            };
        }
        pub fn deinit(self: *Self) void {
            self.stack.deinit();
        }
        pub fn push(self: *Self, node: T) !void {
            return try self.stack.append(node);
        }
        pub fn pop(self: *Self) T {
            return self.stack.pop();
        }
        pub fn peek(self: *const Self) T {
            return self.stack.items[self.stack.items.len - 1];
        }
        pub fn isEmpty(self: *const Self) bool {
            return self.stack.items.len == 0;
        }
        // no 'pub' - private to this module
        fn hasOne(self: *Self) bool {
            return self.stack.items.len == 1;
        }
    };
}
