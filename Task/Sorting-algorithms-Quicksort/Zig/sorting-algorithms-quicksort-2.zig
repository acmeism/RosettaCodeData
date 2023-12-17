const std = @import("std");

pub fn main() void {
    const print = std.debug.print;

    var arr = [_]i16{ 4, 65, 2, -31, 0, 99, 2, 83, 782, 1 };
    print("Before: {any}\n\n", .{arr});

    print("Sort numbers in ascending order.\n", .{});
    quickSort(i16, &arr, struct {
        fn sortFn(left: i16, right: i16) bool {
            return left < right;
        }
    }.sortFn);
    print("After: {any}\n\n", .{arr});

    print("Sort numbers in descending order.\n", .{});
    quickSort(i16, &arr, struct {
        fn sortFn(left: i16, right: i16) bool {
            return left > right;
        }
    }.sortFn);
    print("After: {any}\n\n", .{arr});
}
