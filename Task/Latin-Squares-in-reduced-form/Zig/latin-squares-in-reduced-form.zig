const std = @import("std");

const Matrix = std.ArrayList(std.ArrayList(usize));

fn dlist(n: usize, start: usize, allocator: std.mem.Allocator) !Matrix {
    var a = std.ArrayList(usize).init(allocator);
    defer a.deinit();

    try a.resize(n);
    for (0..n) |index| {
        a.items[index] = index;
    }

    // 1-based to 0-based index, swap start-1 with first element
    std.mem.swap(usize, &a.items[0], &a.items[start - 1]);

    const first = a.items[1];

    var result = Matrix.init(allocator);

    const Context = struct {
        a: *std.ArrayList(usize),
        first: usize,
        result: *Matrix,
        allocator: std.mem.Allocator,
    };

    var context = Context{
        .a = &a,
        .first = first,
        .result = &result,
        .allocator = allocator,
    };

    var a_clone = try a.clone();
    defer a_clone.deinit();

    try recurse(&a_clone, n - 1, &context);

    return result;
}

fn recurse(a: *std.ArrayList(usize), last: usize, context: anytype) !void {
    if (last == 1) {
        // Test if it's a derangement
        for (1..a.items.len) |j| {
            if (a.items[j] == j) {
                return; // Not deranged
            }
        }

        // Convert back to 1-based indexing
        var row = std.ArrayList(usize).init(context.allocator);
        for (a.items) |v| {
            try row.append(v + 1);
        }
        try context.result.append(row);
        return;
    }

    var i: usize = last;
    while (i >= 1) : (i -= 1) {
        std.mem.swap(usize, &a.items[i], &a.items[last]);
        try recurse(a, last - 1, context);
        std.mem.swap(usize, &a.items[i], &a.items[last]);
    }
}

fn printSquare(latin: Matrix) void {
    for (latin.items) |row| {
        std.debug.print("[", .{});
        for (row.items, 0..) |val, i| {
            if (i != row.items.len - 1) {
                std.debug.print("{}, ", .{val});
            } else {
                std.debug.print("{}", .{val});
            }
        }
        std.debug.print("]\n", .{});
    }
    std.debug.print("\n", .{});
}

fn reducedLatinSquares(n: usize, echo: bool, allocator: std.mem.Allocator) !u64 {
    if (n == 0) {
        if (echo) {
            std.debug.print("[]\n", .{});
        }
        return 0;
    } else if (n == 1) {
        if (echo) {
            std.debug.print("[1]\n", .{});
        }
        return 1;
    }

    // Initialize the Latin square with indices
    var rlatin = Matrix.init(allocator);
    defer {
        for (rlatin.items) |row| {
            row.deinit();
        }
        rlatin.deinit();
    }

    for (0..n) |_| {
        var row = std.ArrayList(usize).init(allocator);
        for (0..n) |j| {
            try row.append(j + 1);
        }
        try rlatin.append(row);
    }

    // First row is 1 to n (already initialized above)

    var count: u64 = 0;

    const Context = struct {
        rlatin: *Matrix,
        n: usize,
        echo: bool,
        count: *u64,
        allocator: std.mem.Allocator,
    };

    var context = Context{
        .rlatin = &rlatin,
        .n = n,
        .echo = echo,
        .count = &count,
        .allocator = allocator,
    };

    try recurseLatinSquare(2, &context);

    return count;
}

fn recurseLatinSquare(i: usize, context: anytype) !void {
    var rows = try dlist(context.n, i, context.allocator);
    defer {
        for (rows.items) |row| {
            row.deinit();
        }
        rows.deinit();
    }

    for (rows.items) |row| {
        // Copy row to rlatin[i-1]
        for (row.items, 0..) |val, j| {
            context.rlatin.items[i - 1].items[j] = val;
        }

        var conflict = false;

        outer: for (0..i - 1) |k| {
            for (1..context.n) |j| {
                if (context.rlatin.items[k].items[j] == context.rlatin.items[i - 1].items[j]) {
                    conflict = true;
                    break :outer;
                }
            }
        }

        if (!conflict) {
            if (i < context.n) {
                try recurseLatinSquare(i + 1, context);
            } else {
                context.count.* += 1;
                if (context.echo) {
                    printSquare(context.rlatin.*);
                }
            }
        }
    }
}

fn factorial(n: u64) u64 {
    var result: u64 = 1;
    var i: u64 = 1;
    while (i <= n) : (i += 1) {
        result *= i;
    }
    return result;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    std.debug.print("The four reduced Latin squares of order 4 are:\n\n", .{});
    _ = try reducedLatinSquares(4, true, allocator);

    std.debug.print("The size of the set of reduced Latin squares for the following orders\n", .{});
    std.debug.print("and hence the total number of Latin squares of these orders are:\n\n", .{});

    for (1..6) |n| {
        const size = try reducedLatinSquares(n, false, allocator);
        const fact_n_1 = factorial(@as(u64, n - 1));
        const total = fact_n_1 * fact_n_1 * @as(u64, n) * size;

        std.debug.print("Order {}: Size {} x {}! x {}! => Total {}\n", .{
            n, size, n, n - 1, total
        });
    }
}
