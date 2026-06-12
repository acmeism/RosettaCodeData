const std = @import("std");

pub fn main() !void {
    var prime_measures: [1000]usize = .{0} ** 1000;
    var prime_measure_index: usize = 0;

    prime_measures[prime_measure_index] = 1;
    prime_measure_index += 1;

    for (2..5001) |next_number| {
        var found_prime_measure: bool = true;
        for (0..prime_measure_index) |start_index| {
            var sum: usize = prime_measures[start_index];
            for (start_index + 1..prime_measure_index) |end_index| {
                sum += prime_measures[end_index];
                if (sum > next_number) {
                    break;
                }
                if (sum == next_number) {
                    found_prime_measure = false;
                    break;
                }
            }
            if (!found_prime_measure) {
                break;
            }
        }

        if (found_prime_measure) {
            prime_measures[prime_measure_index] = next_number;
            prime_measure_index += 1;
            if (prime_measure_index >= 1000) {
                break;
            }
        }
    }

    const stdout = std.io.getStdOut().writer();
    try stdout.print("The first 100 prime measures:\n", .{});
    for (prime_measures[0..100], 0..) |prime_measure, index| {
        try stdout.print("{} ", .{prime_measure});
        if (index % 10 == 9) {
            try stdout.print("\n", .{});
        }
    }

    try stdout.print("\nOne thousandth prime measure: {}\n", .{prime_measures[999]});
}
