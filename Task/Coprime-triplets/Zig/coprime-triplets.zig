const std = @import("std");
const gcd = std.math.gcd;
const indexOfScalar = std.mem.indexOfScalar;
const print = std.debug.print;

pub fn main() !void {
    const T: type = u8;
    const limit: T = 50;
    var list = try std.BoundedArray(T, limit).fromSlice(&[2]T{ 1, 2 });

    while (true) {
        var n: T = 3;
        const prev2 = list.get(list.len - 2);
        const prev1 = list.get(list.len - 1);
        while (indexOfScalar(T, list.constSlice(), n) != null or gcd(n, prev2) != 1 or gcd(n, prev1) != 1)
            n += 1;
        if (n > limit)
            break;
        try list.append(n);
    }
    // Pretty print
    print("Coprime triplets under {}:\n", .{limit});
    for (list.constSlice(), 1..) |n, i|
        print("{d:2}{c}", .{ n, @as(u8, if (i % 10 == 0) '\n' else ' ') });
    if (list.len % 10 != 0)
        print("\n", .{});
    print("\nFound {} terms.", .{list.len});
}
