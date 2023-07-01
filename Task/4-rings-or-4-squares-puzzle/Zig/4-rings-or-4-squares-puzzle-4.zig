fn isUnique(allocator: Allocator, a: usize, b: usize, c: usize, d: usize, e: usize, f: usize, g: usize) !bool {
    var data = std.AutoArrayHashMap(usize, void).init(allocator);
    defer data.deinit();
    try data.put(a, {});
    try data.put(b, {});
    try data.put(c, {});
    try data.put(d, {});
    try data.put(e, {});
    try data.put(f, {});
    try data.put(g, {});
    return data.count() == 7;
}
