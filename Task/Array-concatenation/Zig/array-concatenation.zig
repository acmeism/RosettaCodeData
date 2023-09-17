const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    var array1 = [_]u32{ 1, 2, 3, 4, 5 };
    var array2 = [_]u32{ 6, 7, 8, 9, 10, 11, 12 };

    const slice3 = try std.mem.concat(allocator, u32, &[_][]const u32{ &array1, &array2 });
    defer allocator.free(slice3);

    // Same result, alternative syntax
    const slice4 = try std.mem.concat(allocator, u32, &[_][]const u32{ array1[0..], array2[0..] });
    defer allocator.free(slice4);

    std.debug.print(
        "Array 1: {any}\nArray 2: {any}\nSlice 3: {any}\nSlice 4: {any}\n",
        .{ array1, array2, slice3, slice4 },
    );
}
