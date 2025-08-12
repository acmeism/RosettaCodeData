const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    // array literal
    const array1 = [9]i32{ 0, 1, 1, 2, 3, 5, 7, 12, 21 };

    // infer the size of the array
    const array2 = [_]i32{ 0, 1, 1, 2, 3, 5, 7, 12, 21 };

    // alternative initialization using result location
    const array3: [9]i32 = .{ 0, 1, 1, 2, 3, 5, 7, 12, 21 };

    // initialize an array with zeros using array multiplication
    var array4 = [_]i32{0} ** 5; // array length: 5

    // assign elements to an array (must be declared as a variable)
    array4[0] = -12;
    array4[2] = 345;
    array4[4] = -6;

    // retieve elements from an array
    try stdout.print("{d}, ", .{array4[0]});
    try stdout.print("{d}, ", .{array4[1]});
    try stdout.print("{d}, ", .{array4[2]});
    try stdout.print("{d}, ", .{array4[3]});
    try stdout.print("{d}\n", .{array4[4]});

    // unused constants must be discarded
    _ = array1; _ = array2; _ = array3;
}
