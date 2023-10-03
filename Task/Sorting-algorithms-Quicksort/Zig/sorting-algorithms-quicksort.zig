const std = @import("std");

pub fn quicksort(comptime t: type, arr: []t) void {
    if (arr.len < 2) return;
    var pivot = arr[@as(usize, @intFromFloat(@floor(@as(f64, @floatFromInt(arr.len)) / 2)))];
    var left: usize = 0;
    var right: usize = arr.len - 1;

    while (left <= right) {
        while (arr[left] < pivot) {
            left += 1;
        }
        while (arr[right] > pivot) {
            right -= 1;
        }
        if (left <= right) {
            const tmp = arr[left];
            arr[left] = arr[right];
            arr[right] = tmp;
            left += 1;
            right -= 1;
        }
    }

    quicksort(t, arr[0 .. right + 1]);
    quicksort(t, arr[left..]);
}

pub fn main() !void {
    const LIST_TYPE = i16;
    var arr: [10]LIST_TYPE = [_]LIST_TYPE{ 4, 65, 2, -31, 0, 99, 2, 83, 782, 1 };
    var i: usize = 0;

    while (i < arr.len) : (i += 1) {
        std.debug.print("{d} ", .{arr[i]});
    }
    std.debug.print("\n", .{});

    i = 0;
    quicksort(LIST_TYPE, &arr);
    while (i < arr.len) : (i += 1) {
        std.debug.print("{d} ", .{arr[i]});
    }
    std.debug.print("\n", .{});
}
