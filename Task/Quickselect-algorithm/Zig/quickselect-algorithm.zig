const std = @import("std");

fn partition(comptime T: type, a: []T, left: usize, right: usize, pivot: usize) usize {
    std.mem.swap(T, &a[pivot], &a[right]);
    var store_index = left;
    var i = left;
    while (i < right) : (i += 1) {
        if (a[i] < a[right]) {
            std.mem.swap(T, &a[store_index], &a[i]);
            store_index += 1;
        }
    }
    std.mem.swap(T, &a[right], &a[store_index]);
    return store_index;
}

fn pivotIndex(left: usize, right: usize) usize {
    return left + (right - left) / 2;
}

fn select(comptime T: type, a: []T, left_init: usize, right_init: usize, n: usize) void {
    var left = left_init;
    var right = right_init;

    while (true) {
        if (left == right) {
            break;
        }

        var pivot = pivotIndex(left, right);
        pivot = partition(T, a, left, right, pivot);

        if (n == pivot) {
            break;
        } else if (n < pivot) {
            right = pivot - 1;
        } else {
            left = pivot + 1;
        }
    }
}

// Rearranges the elements of 'a' such that the element at index 'n' is
// the same as it would be if the array were sorted, smaller elements are
// to the left of it and larger elements are to its right.
fn nthElement(comptime T: type, a: []T, n: usize) void {
    select(T, a, 0, a.len - 1, n);
}

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const a = [_]i32{ 9, 8, 7, 6, 5, 0, 1, 2, 3, 4 };

    var n: usize = 0;
    while (n < a.len) : (n += 1) {
        var b = try allocator.alloc(i32, a.len);
        defer allocator.free(b);

        // Copy elements one by one instead of using mem.copy
        for (0..a.len) |i| {
            b[i] = a[i];
        }

        nthElement(i32, b, n);

        const stdout = std.io.getStdOut().writer();
        try stdout.print("n = {}, nth element = {}\n", .{ n + 1, b[n] });
    }
}
