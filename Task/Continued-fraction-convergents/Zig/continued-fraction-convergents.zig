const std = @import("std");
const print = std.debug.print;
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

const Fraction = struct {
    numer: u32,
    denom: u32,
};

fn printVector(vec: []const []const u8) !void {
    print("[" , .{});
    for (vec, 0..) |item, i| {
        if (i > 0) {
            print(", " , .{});
        }
        print("{s}", .{item});
    }
    print("]" , .{});
}

fn convergents(allocator: Allocator, x: f64, size: usize) ![][]const u8 {
    var components = ArrayList(u32).init(allocator);
    defer components.deinit();

    var x_val = x;
    var fraction_part: f64 = 1.0;

    for (0..size) |_| {
        if (fraction_part < 0.000_000_001) {
            break;
        }

        const int_part: u32 = @intFromFloat(x_val);
        fraction_part = x_val - @as(f64, @floatFromInt(int_part));
        try components.append(int_part);

        if (fraction_part > 0.0) {
            x_val = 1.0 / fraction_part;
        }
    }

    var result = ArrayList([]const u8).init(allocator);
    var a = Fraction{ .numer = 0, .denom = 1 };
    var b = Fraction{ .numer = 1, .denom = 0 };

    for (components.items) |component| {
        const a_copy = a;
        a = b;
        b = Fraction{
            .numer = a_copy.numer + component * b.numer,
            .denom = a_copy.denom + component * b.denom,
        };

        const fraction_str = try std.fmt.allocPrint(allocator, "{d}/{d}", .{ b.numer, b.denom });
        try result.append(fraction_str);
    }

    return result.toOwnedSlice();
}

const Test = struct {
    description: []const u8,
    value: f64,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const tests = [_]Test{
        Test{
            .description = "415/93",
            .value = 415.0 / 93.0,
        },
        Test{
            .description = "649/200",
            .value = 649.0 / 200.0,
        },
        Test{
            .description = "Square root of 2",
            .value = @sqrt(2.0),
        },
        Test{
            .description = "Square root of 5",
            .value = @sqrt(5.0),
        },
        Test{
            .description = "Golden ratio",
            .value = (@sqrt(5.0) + 1.0) / 2.0,
        },
    };

    print("The continued fraction convergents for the following (maximum 8 terms) are:\n" , .{});
    for (tests) |my_test| {
        print("{s:>20} => ", .{my_test.description});
        const convergents_result = try convergents(allocator, my_test.value, 8);
        defer {
            for (convergents_result) |str| {
                allocator.free(str);
            }
            allocator.free(convergents_result);
        }

        try printVector( convergents_result);
        print("\n" , .{});
    }
}
