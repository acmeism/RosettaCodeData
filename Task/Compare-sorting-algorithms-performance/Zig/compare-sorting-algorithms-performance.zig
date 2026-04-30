const std = @import("std");
const print = std.debug.print;
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

const SortFunction = *const fn (allocator: Allocator, vec: []i32) anyerror!void;

fn measureExecutionTime(allocator: Allocator, sort_fn: SortFunction, sequence: []const i32) !i64 {
    // Create a copy of the sequence to sort
    const vec = try allocator.dupe(i32, sequence);
    defer allocator.free(vec);

    const start_time = std.time.nanoTimestamp();
    try sort_fn(allocator, vec);
    const stop_time = std.time.nanoTimestamp();

    return @divTrunc( @as(i64, @intCast(stop_time - start_time)) , @as(i64, 1000) ); // Convert to microseconds
}

fn createOnes(allocator: Allocator, n: u32) ![]i32 {
    const result = try allocator.alloc(i32, n);
    for (result) |*item| {
        item.* = 1;
    }
    return result;
}

fn createAscending(allocator: Allocator, n: u32) ![]i32 {
    const result = try allocator.alloc(i32, n);
    for (result, 0..) |*item, i| {
        item.* = @intCast(i + 1);
    }
    return result;
}

fn createRandom(allocator: Allocator, n: u32) ![]i32 {
    var prng = std.Random.DefaultPrng.init(@as(u64, @intCast(std.time.milliTimestamp())));
    const random = prng.random();

    const result = try allocator.alloc(i32, n);
    for (result) |*item| {
        item.* = random.intRangeAtMost(i32, 1, @intCast(10 * n));
    }
    return result;
}

fn bubbleSort(allocator: Allocator, vec: []i32) anyerror!void {
    _ = allocator; // unused
    var n = vec.len;
    while (n != 0) {
        var n2: usize = 0;
        var i: usize = 1;
        while (i < n) {
            if (vec[i - 1] > vec[i]) {
                const temp = vec[i];
                vec[i] = vec[i - 1];
                vec[i - 1] = temp;
                n2 = i;
            }
            i += 1;
        }
        n = n2;
    }
}

fn insertionSort(allocator: Allocator, vec: []i32) anyerror!void {
    _ = allocator; // unused
    var index: usize = 1;
    while (index < vec.len) {
        const value = vec[index];
        var sub_index: i32 = @intCast(index - 1);
        while (sub_index >= 0 and vec[@intCast(sub_index)] > value) {
            vec[@intCast(sub_index + 1)] = vec[@intCast(sub_index)];
            sub_index -= 1;
        }
        vec[@intCast(sub_index + 1)] = value;
        index += 1;
    }
}

fn quickSortRecursive(vec: []i32, first: i32, last: i32) void {
    if (last - first < 1) {
        return;
    }

    const pivot = vec[@intCast(first + @divTrunc(last - first, 2))];
    var left = first;
    var right = last;

    while (left <= right) {
        while (vec[@intCast(left)] < pivot) {
            left += 1;
        }
        while (vec[@intCast(right)] > pivot) {
            right -= 1;
        }
        if (left <= right) {
            const temp = vec[@intCast(left)];
            vec[@intCast(left)] = vec[@intCast(right)];
            vec[@intCast(right)] = temp;
            left += 1;
            right -= 1;
        }
    }

    if (first < right) {
        quickSortRecursive(vec, first, right);
    }
    if (left < last) {
        quickSortRecursive(vec, left, last);
    }
}

fn quickSort(allocator: Allocator, vec: []i32) anyerror!void {
    _ = allocator; // unused
    if (vec.len > 0) {
        quickSortRecursive(vec, 0, @intCast(vec.len - 1));
    }
}

fn countingSort(vec: []i32, exponent: i32, allocator: Allocator) !void {
    const vec_size = vec.len;
    var output = try allocator.alloc(i32, vec_size);
    defer allocator.free(output);

    var count = [_]i32{0} ** 10;

    for (vec) |item| {
        const t: usize = @intCast(@mod(@divTrunc(item, exponent), 10));
        count[t] += 1;
    }

    var i: usize = 1;
    while (i <= 9) : (i += 1) {
        count[i] += count[i - 1];
    }

    var j = vec_size;
    while (j > 0) {
        j -= 1;
        const t: usize = @intCast(@mod(@divTrunc(vec[j], exponent), 10));
        output[@intCast(count[t] - 1)] = vec[j];
        count[t] -= 1;
    }

    // Copy output back to vec
    @memcpy(vec, output);
}

fn radixSort(allocator: Allocator, vec: []i32) anyerror!void {
    if (vec.len == 0) return;

    const min_val = std.mem.min(i32, vec);

    // If there are negative numbers, make all numbers positive
    if (min_val < 0) {
        for (vec) |*item| {
            item.* -= min_val;
        }
    }

    const max_val = std.mem.max(i32, vec);
    var exponent: i32 = 1;

    while (@divTrunc(max_val, exponent) > 0) {
        try countingSort(vec, exponent, allocator);
        exponent *= 10;
    }

    // If there were negative numbers, return array to original values
    if (min_val < 0) {
        for (vec) |*item| {
            item.* += min_val;
        }
    }
}

fn shellSort(allocator: Allocator, vec: []i32) anyerror!void {
    _ = allocator; // unused
    const gaps = [_]i32{ 701, 301, 132, 57, 23, 10, 4, 1 }; // Marcin Ciura's gap sequence

    for (gaps) |gap| {
        var i: usize = @intCast(gap);
        while (i < vec.len) {
            const temp = vec[i];
            var j: i32 = @intCast(i);
            while (j >= gap and vec[@intCast(j - gap)] > temp) {
                vec[@intCast(j)] = vec[@intCast(j - gap)];
                j -= gap;
            }
            vec[@intCast(j)] = temp;
            i += 1;
        }
    }
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const repetitions: u32 = 10;
    // const lengths = [_]u32{ 1, 10, 100, 1000, 10000, 100000 };
    const lengths = [_]u32{ 1, 10, 100, 1000, 10000 };
    const sorts = [_]SortFunction{ bubbleSort, insertionSort, quickSort, radixSort, shellSort };
    const sort_titles = [_][]const u8{ "Bubble", "Insert", "Quick ", "Radix ", "Shell " };
    const sequence_titles = [_][]const u8{ "All Ones", "Ascending", "Random" };

    // Initialize totals array: [sequences][sorts][lengths]
    var totals: [3][5][6]i64 = std.mem.zeroes([3][5][6]i64);

    for (lengths, 0..) |n, k| {
        // Create sequences
        const ones_seq = try createOnes(allocator, n);
        defer allocator.free(ones_seq);
        const ascending_seq = try createAscending(allocator, n);
        defer allocator.free(ascending_seq);
        const random_seq = try createRandom(allocator, n);
        defer allocator.free(random_seq);

        const sequences = [_][]const i32{ ones_seq, ascending_seq, random_seq };

        var repetition: u32 = 0;
        while (repetition < repetitions) : (repetition += 1) {
            for (sequences, 0..) |sequence, i| {
                for (sorts, 0..) |sort_fn, j| {
                    const execution_time = try measureExecutionTime(allocator, sort_fn, sequence);
                    totals[i][j][k] += execution_time;
                }
            }
        }
    }

    print("All timings in microseconds.\n\n", .{} );
    print("Sequence length" , .{} );
    for (lengths) |length| {
        print("{d:>10}", .{length});
    }
    print("\n\n" , .{} );

    for (sequence_titles, 0..) |seq_title, i| {
        print("  {s}:\n", .{seq_title});
        for (sort_titles, 0..) |sort_title, j| {
            print("    {s}     ", .{sort_title});
            for (lengths, 0..) |_, k| {
                const execution_time = @divTrunc(totals[i][j][k], repetitions);
                print("{d:>10}", .{execution_time});
            }
            print("\n" , .{} );
        }
        print("\n\n" , .{} );
    }
}
