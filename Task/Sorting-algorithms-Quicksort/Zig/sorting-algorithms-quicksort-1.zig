const std = @import("std");

pub fn quickSort(comptime T: type, arr: []T, comptime compareFn: fn (T, T) bool) void {
    if (arr.len < 2) return;

    const pivot_index = partition(T, arr, compareFn);
    quickSort(T, arr[0..pivot_index], compareFn);
    quickSort(T, arr[pivot_index + 1 .. arr.len], compareFn);
}

fn partition(comptime T: type, arr: []T, comptime compareFn: fn (T, T) bool) usize {
    const pivot_index = arr.len / 2;
    const last_index = arr.len - 1;

    std.mem.swap(T, &arr[pivot_index], &arr[last_index]);

    var store_index: usize = 0;
    for (arr[0 .. arr.len - 1]) |*elem_ptr| {
        if (compareFn(elem_ptr.*, arr[last_index])) {
            std.mem.swap(T, elem_ptr, &arr[store_index]);
            store_index += 1;
        }
    }

    std.mem.swap(T, &arr[store_index], &arr[last_index]);
    return store_index;
}
