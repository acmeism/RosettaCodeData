const std = @import("std");

fn generateFactors(n: i32, allocator: std.mem.Allocator) !std.ArrayList(i32) {
    var factors = std.ArrayList(i32).init(allocator);

    try factors.append(1);
    try factors.append(n);

    var i: i32 = 2;
    while (i * i <= n) : (i += 1) {
        if ( @mod(n, i) == 0) {
            try factors.append(i);
            if (i * i != n) {
                try factors.append(   @divFloor(n,i) );
            }
        }
    }

    std.sort.heap(i32, factors.items, {}, comptime std.sort.asc(i32));
    return factors;
}

pub fn main() !void {
    const sample_numbers = [_]i32{ 3135, 45, 60, 81 };

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const stdout = std.io.getStdOut().writer();

    for (sample_numbers) |num| {
        var factors = try generateFactors(num, allocator);
        defer factors.deinit();

        try stdout.print("Factors of {d:4} are: ", .{num});

        for (factors.items) |factor| {
            try stdout.print("{d} ", .{factor});
        }
        try stdout.print("\n", .{});
    }
}
