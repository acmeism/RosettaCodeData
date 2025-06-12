const std = @import("std");

fn rpn(text: []const u8, allocator: std.mem.Allocator) !f64 {
    var tokens = std.mem.splitScalar(u8, text, ' ');
    var stack = std.ArrayList(f64).init(allocator);
    defer stack.deinit();

    std.debug.print("input operation stack\n", .{});

    while (tokens.next()) |token| {
        if (token.len == 0) continue;

        std.debug.print("{s:^5} ", .{token});

        const num = std.fmt.parseFloat(f64, token) catch {
            if (stack.items.len < 2) {
                return error.NotEnoughOperands;
            }

            const b = stack.pop().?;
            const a = stack.pop().?;

            if (std.mem.eql(u8, token, "+")) {
                try stack.append(a + b);
            } else if (std.mem.eql(u8, token, "-")) {
                try stack.append(a - b);
            } else if (std.mem.eql(u8, token, "*")) {
                try stack.append(a * b);
            } else if (std.mem.eql(u8, token, "/")) {
                try stack.append(a / b);
            } else if (std.mem.eql(u8, token, "^")) {
                try stack.append(std.math.pow(f64, a, b));
            } else {
                std.debug.panic("unknown operator {s}", .{token});
            }

            std.debug.print("calculate {any}\n", .{stack.items});
            continue;
        };

        try stack.append(num);
        std.debug.print("push      {any}\n", .{stack.items});
    }

    return if (stack.items.len > 0) stack.pop().? else 0.0;
}

pub fn main() !void {
    const text = "3 4 2 * 1 5 - 2 3 ^ ^ / +";

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const result = try rpn(text, allocator);
    std.debug.print("\nresult: {d}\n", .{result});
}
