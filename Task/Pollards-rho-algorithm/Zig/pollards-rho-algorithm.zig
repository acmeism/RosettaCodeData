const std = @import("std");

fn gcd(a: i128, b: i128) i128 {
    var x = @abs(a);
    var y = @abs(b);

    while (y != 0) {
        const temp = y;
        y = x % y;
        x = temp;
    }

    return @as(i128, @intCast(x));
}

fn pollards_rho(number: i128) i128 {
    if (number & 1 == 0) {
        return 2;
    }

    var prng = std.Random.DefaultPrng.init(@as(u64, @truncate(@as(u128, @bitCast(std.time.nanoTimestamp())))));
    const rand = prng.random();

    const bit_length: u6 = @intCast(std.math.log2_int(u128, @intCast(number)));
    var x: i128 = @intCast(rand.intRangeAtMost(i64, 0, std.math.pow(i64, 2, bit_length)));
    const constant: i128 = @intCast(rand.intRangeAtMost(i64, 0, std.math.pow(i64, 2, bit_length)));

    var y: i128 = x;
    var divisor: i128 = 1;

    while (divisor == 1) {
        x = @rem( (x * x + constant) , number);
        y = @rem( (y * y + constant) , number);
        y = @rem( (y * y + constant) , number);
        divisor = gcd(x - y, number);
    }

    return divisor;
}

pub fn main() !void {
    const tests = [_]i128{ 4294967213, 9759463979, 34225158206557151, 13 };

    for (tests) |my_test| {
        const divisor_one = pollards_rho(my_test);
        const divisor_two = @divTrunc(my_test, divisor_one);
        std.debug.print("{} = {} * {}\n", .{ my_test, divisor_one, divisor_two });
    }
}
