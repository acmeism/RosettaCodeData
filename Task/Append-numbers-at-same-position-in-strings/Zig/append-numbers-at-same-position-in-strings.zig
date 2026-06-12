const std = @import("std");
var stdout = std.fs.File.stdout().writer(&.{});

pub fn main() !void {
    const list1 = [_]u32{1, 2, 3, 4, 5, 6, 7, 8, 9};
    const list2 = [_]u32{10, 11, 12, 13, 14, 15, 16, 17, 18};
    const list3 = [_]u32{19, 20, 21, 22, 23, 24, 25, 26, 27};
    var list: [9]u32 = undefined;
    for(&list, 0..)|*item, i|{
        item.* = list1[i] * 10000 + list2[i] * 100 + list3[i];
    }
    try stdout.interface.print("{any}\n", .{list});
}
