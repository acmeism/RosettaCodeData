const std = @import("std");
const print = std.debug.print;
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

const BinomialError = error{
    TooLarge,
    OutOfMemory,
};

fn printVector(comptime T: type, vec: []const T) void {
    for (vec) |element| {
        print("{} ",  .{element} );
    }
}

fn factorial(number: u32) BinomialError!u64 {
    if (number > 20) {
        print("Too large for 64 bit number: {}\n", .{number});
        return BinomialError.TooLarge;
    }
    if (number < 2) {
        return 1;
    }

    var fact: u64 = 1;
    var i: u32 = 2;
    while (i <= number) : (i += 1) {
        fact *= @as(u64, i);
    }
    return fact;
}

fn binomial(n: u32, k: u32) BinomialError!u64 {
    const n_fact = try factorial(n);
    const n_minus_k_fact = try factorial(n - k);
    const k_fact = try factorial(k);

    return n_fact / n_minus_k_fact / k_fact;
}

fn forward(allocator: Allocator, vec: []const i64) BinomialError![]i64 {
    const size = vec.len;
    var transform = try allocator.alloc(i64, size);

    // Initialize to zero
    for (transform) |*elem| {
        elem.* = 0;
    }

    for (0..size) |n| {
        for (0..n + 1) |k| {
            const binomial_coeff = try binomial(@intCast(n), @intCast(k));
            transform[n] += @as(i64, @intCast(binomial_coeff)) * vec[k];
        }
    }

    return transform;
}

fn inverse(allocator: Allocator, vec: []const i64) BinomialError![]i64 {
    const size = vec.len;
    var transform = try allocator.alloc(i64, size);

    // Initialize to zero
    for (transform) |*elem| {
        elem.* = 0;
    }

    for (0..size) |n| {
        for (0..n + 1) |k| {
            const binomial_coeff = try binomial(@intCast(n), @intCast(k));
            const sign: i32 = if ((n - k) % 2 == 1) -1 else 1;
            transform[n] += @as(i64, @intCast(binomial_coeff)) * vec[k] * @as(i64, sign);
        }
    }

    return transform;
}

fn selfInverting(allocator: Allocator, vec: []const i64) BinomialError![]i64 {
    const size = vec.len;
    var transform = try allocator.alloc(i64, size);

    // Initialize to zero
    for (transform) |*elem| {
        elem.* = 0;
    }

    for (0..size) |n| {
        for (0..n + 1) |k| {
            const binomial_coeff = try binomial(@intCast(n), @intCast(k));
            const sign: i32 = if (k % 2 == 1) -1 else 1;
            transform[n] += @as(i64, @intCast(binomial_coeff)) * vec[k] * @as(i64, sign);
        }
    }

    return transform;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const sequences = [_][]const i64{
        &[_]i64{ 1, 1, 2, 5, 14, 42, 132, 429, 1430, 4862, 16796, 58786, 208012, 742900, 2674440, 9694845 },
        &[_]i64{ 0, 1, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0 },
        &[_]i64{ 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181 },
        &[_]i64{ 1, 0, 0, 1, 0, 1, 1, 1, 2, 2, 3, 4, 5, 7, 9, 12, 16, 21, 28, 37 },
    };

    const names = [_][]const u8{
        "Catalan number sequence:",
        "Prime flip-flop sequence:",
        "Fibonacci number sequence:",
        "Padovan number sequence:",
    };

    for (sequences, 0..) |sequence, i| {
        print("{s}\n", .{names[i]});
        printVector(i64, sequence);

        print("\nForward binomial transform:\n" , .{});
        const forward_result = try forward(allocator, sequence);
        defer allocator.free(forward_result);
        printVector(i64, forward_result);

        print("\nInverse binomial transform:\n", .{});
        const inverse_result = try inverse(allocator, sequence);
        defer allocator.free(inverse_result);
        printVector(i64, inverse_result);

        print("\nRound trip:\n", .{});
        const round_trip = try inverse(allocator, forward_result);
        defer allocator.free(round_trip);
        printVector(i64, round_trip);

        print("\nSelf-inverting:\n", .{});
        const self_inv_result = try selfInverting(allocator, sequence);
        defer allocator.free(self_inv_result);
        printVector(i64, self_inv_result);

        print("\nRound trip self-inverting:\n", .{});
        const self_inv_round_trip = try selfInverting(allocator, self_inv_result);
        defer allocator.free(self_inv_round_trip);
        printVector(i64, self_inv_round_trip);

        print("\n\n", .{});
    }
}
