const std = @import("std");
const print = std.debug.print;

const MULTIPLICATION_TABLE: [10][10]i32 = [_][10]i32{
    [_]i32{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 },
    [_]i32{ 1, 2, 3, 4, 0, 6, 7, 8, 9, 5 },
    [_]i32{ 2, 3, 4, 0, 1, 7, 8, 9, 5, 6 },
    [_]i32{ 3, 4, 0, 1, 2, 8, 9, 5, 6, 7 },
    [_]i32{ 4, 0, 1, 2, 3, 9, 5, 6, 7, 8 },
    [_]i32{ 5, 9, 8, 7, 6, 0, 4, 3, 2, 1 },
    [_]i32{ 6, 5, 9, 8, 7, 1, 0, 4, 3, 2 },
    [_]i32{ 7, 6, 5, 9, 8, 2, 1, 0, 4, 3 },
    [_]i32{ 8, 7, 6, 5, 9, 3, 2, 1, 0, 4 },
    [_]i32{ 9, 8, 7, 6, 5, 4, 3, 2, 1, 0 },
};

const INVERSE: [10]i32 = [_]i32{ 0, 4, 3, 2, 1, 5, 6, 7, 8, 9 };

const PERMUTATION_TABLE: [8][10]i32 = [_][10]i32{
    [_]i32{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 },
    [_]i32{ 1, 5, 7, 6, 2, 8, 3, 0, 9, 4 },
    [_]i32{ 5, 8, 0, 3, 7, 9, 6, 1, 4, 2 },
    [_]i32{ 8, 9, 1, 6, 0, 4, 3, 5, 2, 7 },
    [_]i32{ 9, 4, 5, 3, 1, 2, 6, 8, 7, 0 },
    [_]i32{ 4, 2, 8, 6, 5, 7, 3, 9, 0, 1 },
    [_]i32{ 2, 7, 9, 3, 8, 0, 6, 4, 1, 5 },
    [_]i32{ 7, 0, 4, 6, 9, 1, 3, 2, 5, 8 },
};

fn verhoeffChecksum(allocator: std.mem.Allocator, number: []const u8, do_validation: bool, do_display: bool) !i32 {
    if (do_display) {
        const calculation_type = if (do_validation) "Validation" else "Check digit";
        print("{s} calculations for {s}\n\n", .{ calculation_type, number });
        print(" i  ni  p[i, ni]  c\n", .{});
        print("-------------------\n", .{});
    }

    var working_number = std.ArrayList(u8).init(allocator);
    defer working_number.deinit();

    try working_number.appendSlice(number);
    if (!do_validation) {
        try working_number.append('0');
    }

    var c: i32 = 0;
    const le = working_number.items.len - 1;

    var i: usize = le + 1;
    while (i > 0) {
        i -= 1;
        const ni = working_number.items[i] - '0';
        const pos = (le - i) % 8;
        const pi = PERMUTATION_TABLE[pos][ni];
        c = MULTIPLICATION_TABLE[@intCast(c)][@as(usize, @intCast(pi))];

        if (do_display) {
            print("{:2}  {:2}       {:2}     {:2}\n\n", .{ le - i, ni, pi, c });
        }
    }

    if (do_display and !do_validation) {
        print("inverse[{}] = {}\n\n", .{ c, INVERSE[@intCast(c)] });
    }

    if (do_validation) {
        return if (c == 0) 1 else 0;
    } else {
        return INVERSE[@intCast(c)];
    }
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const Test = struct {
        test_num: []const u8,
        display: bool,
    };

    const tests = [_]Test{
        .{ .test_num = "123", .display = true },
        .{ .test_num = "12345", .display = true },
        .{ .test_num = "123456789012", .display = false },
    };

    for (tests) |my_test| {
        const digit = try verhoeffChecksum(allocator, my_test.test_num, false, my_test.display);
        print("The check digit for {s} is {}\n\n", .{ my_test.test_num, digit });

        // Create test numbers with check digit and with '9'
        var correct_number = std.ArrayList(u8).init(allocator);
        defer correct_number.deinit();
        try correct_number.appendSlice(my_test.test_num);
        try correct_number.append('0' + @as(u8, @intCast(digit)));

        var incorrect_number = std.ArrayList(u8).init(allocator);
        defer incorrect_number.deinit();
        try incorrect_number.appendSlice(my_test.test_num);
        try incorrect_number.append('9');

        const numbers = [_][]const u8{ correct_number.items, incorrect_number.items };

        for (numbers) |number| {
            const validation_result = try verhoeffChecksum(allocator, number, true, my_test.display);
            const result = if (validation_result == 1) "correct" else "incorrect";
            print("The validation for \"{s}\" is \"{s}\". \n", .{ number, result });
        }
    }
}
