/// Caller owns combinations slice memory.
fn getCombs(allocator: Allocator, low: u16, high: u16, unique: bool) !struct { num: usize, combinations: [][7]usize } {
    var num: usize = 0;
    var valid_combinations = std.ArrayList([7]usize).init(allocator);
    for (low..high + 1) |a|
        for (low..high + 1) |b|
            for (low..high + 1) |c|
                for (low..high + 1) |d|
                    for (low..high + 1) |e|
                        for (low..high + 1) |f|
                            for (low..high + 1) |g|
                                if (validComb(a, b, c, d, e, f, g))
                                    if (!unique or try isUnique(allocator, a, b, c, d, e, f, g)) {
                                        num += 1;
                                        try valid_combinations.append([7]usize{ a, b, c, d, e, f, g });
                                    };
    return .{ .num = num, .combinations = try valid_combinations.toOwnedSlice() };
}
