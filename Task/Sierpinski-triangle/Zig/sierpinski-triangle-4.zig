fn rule_90(allocator: Allocator, evstr: []u8) !void {
    var cp = try allocator.dupe(u8, evstr);
    defer allocator.free(cp); // free does "free" for last node in arena

    for (evstr, 0..) |*evptr, i| {
        var s = [2]bool{
            if (i == 0) false else truth(cp[i - 1]),
            if (i + 1 == evstr.len) false else truth(cp[i + 1]),
        };
        evptr.* = if ((s[0] and !s[1]) or (!s[0] and s[1])) '*' else ' ';
    }
}
