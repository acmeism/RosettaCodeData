const std = @import("std");
const print = std.debug.print;
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

const Node = struct {
    child: usize = 0,
    sib: usize = 0,
    parent: usize = 0,
};

const ProcessResult = struct {
    pi: []usize,
    beta: []usize,
    alfa: []usize,
    tau: []usize,
    lam: []i32,
};

fn process(allocator: Allocator, n: usize, a: []i32) !ProcessResult {
    var pi = try allocator.alloc(usize, n + 1);
    var beta = try allocator.alloc(usize, n + 1);
    var alfa = try allocator.alloc(usize, n + 1);
    var tau = try allocator.alloc(usize, n + 1);
    var lam = try allocator.alloc(i32, n + 1);

    @memset(pi, 0);
    @memset(beta, 0);
    @memset(alfa, 0);
    @memset(tau, 0);
    @memset(lam, 0);

    lam[0] = -1;

    var nodes = try allocator.alloc(Node, n + 1);
    for (nodes) |*node| {
        node.* = Node{};
    }

    // Make triply linked tree
    var t: usize = 0;
    var v: usize = n;
    while (v >= 1) : (v -= 1) {
        var u: usize = 0;
        while (a[v] > a[t] or (a[v] == a[t] and v > t)) {
            u = t;
            t = nodes[t].parent;
        }

        if (u != 0) {
            nodes[v].sib = nodes[u].sib;
            nodes[u].sib = 0;
            nodes[u].parent = v;
            nodes[v].child = u;
        } else {
            nodes[v].sib = nodes[t].child;
        }

        nodes[t].child = v;
        nodes[v].parent = t;
        t = v;
    }

    // Begin first traversal
    var p = nodes[0].child;
    var n_count: usize = 0;

    // First traversal loop
    while (true) {
        // s3: Compute beta in the easy case
        n_count += 1;
        pi[p] = n_count;
        tau[n_count] = 0;
        lam[n_count] = 1 + lam[n_count >> 1];

        if (nodes[p].child != 0) {
            p = nodes[p].child;
            continue;
        }

        beta[p] = n_count;

        // s4: Compute tau, bottom-up
        while (true) {
            tau[beta[p]] = nodes[p].parent;

            if (nodes[p].sib != 0) {
                p = nodes[p].sib;
                break; // Go back to s3
            }

            p = nodes[p].parent;

            // Compute beta in the hard case
            if (p != 0) {
                const h = lam[(n_count & (~pi[p] + 1))];
                beta[p] = ((n_count >> @intCast(h)) | 1) << @intCast(h);
            } else {
                // Exit traversal
                break;
            }
        }

        if (p == 0) {
            break;
        }
    }

    // Begin second traversal
    p = nodes[0].child;
    lam[0] = lam[n_count];
    pi[0] = 0;
    beta[0] = 0;
    alfa[0] = 0;

    // Perform second traversal
    if (p != 0) {
        computeAlfa(p, nodes, alfa, beta);
    }

    defer allocator.free(nodes);

    return ProcessResult{
        .pi = pi,
        .beta = beta,
        .alfa = alfa,
        .tau = tau,
        .lam = lam,
    };
}

fn computeAlfa(p: usize, nodes: []const Node, alfa: []usize, beta: []const usize) void {
    // s7: Compute alfa, top-down
    alfa[p] = alfa[nodes[p].parent] | (beta[p] & (~beta[p] + 1));

    if (nodes[p].child != 0) {
        computeAlfa(nodes[p].child, nodes, alfa, beta);
    }

    // s8: Continue traversal
    if (nodes[p].sib != 0) {
        computeAlfa(nodes[p].sib, nodes, alfa, beta);
    }
}

fn nca(
    x_param: usize,
    y_param: usize,
    beta: []const usize,
    alfa: []const usize,
    tau: []const usize,
    lam: []const i32,
    pi: []const usize,
) usize {
    var x = x_param;
    var y = y_param;

    // Find common height
    var h = if (beta[x] <= beta[y])
        lam[(beta[y] & (~beta[x] + 1))]
    else
        lam[(beta[x] & (~beta[y] + 1))];

    // Find true height
    const k = alfa[x] & alfa[y] & (~(@as(usize, 1) << @intCast(h)) + 1);
    h = lam[(k & (~k + 1))];

    // Find beta[z]
    const j = ((beta[x] >> @intCast(h)) | 1) << @intCast(h);

    // Find x' and y'
    if (j != beta[x]) {
        const l = lam[(alfa[x] & ((@as(usize, 1) << @intCast(h)) - 1))];
        x = tau[((beta[x] >> @intCast(l)) | 1) << @intCast(l)];
    }

    if (j != beta[y]) {
        const l = lam[(alfa[y] & ((@as(usize, 1) << @intCast(h)) - 1))];
        y = tau[((beta[y] >> @intCast(l)) | 1) << @intCast(l)];
    }

    // Find z
    return if (pi[x] <= pi[y]) x else y;
}

fn solveTestCase(
    allocator: Allocator,
    n: usize,
    values: []const i32,
    queries: []const [2]usize,
) ![]i32 {
    var results = ArrayList(i32).init(allocator);
    defer results.deinit();

    var a = ArrayList(i32).init(allocator);
    defer a.deinit();
    try a.append(std.math.maxInt(i32)); // A[0]

    var r = try allocator.alloc(usize, n + 2);
    defer allocator.free(r);
    var b = try allocator.alloc(usize, n + 2);
    defer allocator.free(b);

    @memset(r, 0);
    @memset(b, 0);

    var big_n: usize = 1;
    var count: i32 = 0;
    var oldx: ?i32 = null;

    for (1..n + 1) |i| {
        const x = values[i - 1];

        if (i > 1 and (oldx == null or x != oldx.?)) {
            try a.append(count);
            r[big_n] = i;
            big_n += 1;
            count = 0;
        }

        b[i] = big_n;
        count += 1;
        oldx = x;
    }

    try a.append(count);
    r[big_n] = n + 1;

    const process_result = try process(allocator, big_n, a.items);
    defer {
        allocator.free(process_result.pi);
        allocator.free(process_result.beta);
        allocator.free(process_result.alfa);
        allocator.free(process_result.tau);
        allocator.free(process_result.lam);
    }

    for (queries) |query| {
        const i = query[0];
        const j = query[1];
        const x = b[i];
        const y = b[j];

        const z = if (x == y)
            @as(i32, @intCast(j - i + 1))
        else blk: {
            var z_val: i32 = if (x + 1 != y)
                a.items[nca(x + 1, y - 1, process_result.beta, process_result.alfa, process_result.tau, process_result.lam, process_result.pi)]
            else
                0;

            z_val = @max(z_val, @max(
                @as(i32, @intCast(r[x] - i)),
                a.items[y] - @as(i32, @intCast(r[y] - j - 1))
            ));

            break :blk z_val;
        };

        try results.append(z);
    }

    return results.toOwnedSlice();
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Hard-coded test data
    const TestCase = struct {
        n: usize,
        values: []const i32,
        queries: []const [2]usize,
        expected: []const i32,
    };

    const test_cases = [_]TestCase{
        TestCase{
            .n = 10,
            .values = &[_]i32{ -1, -1, 1, 1, 1, 1, 3, 10, 10, 10 },
            .queries = &[_][2]usize{ [_]usize{ 2, 3 }, [_]usize{ 1, 10 }, [_]usize{ 5, 10 } },
            .expected = &[_]i32{ 1, 4, 3 },
        },
    };

    for (test_cases, 0..) |test_case, idx| {
        print("Test Case {}:\n", .{idx + 1});
        print("Size: {}, Queries: {}\n", .{ test_case.n, test_case.queries.len });
        print("Values: ",  .{});
        for (test_case.values) |v| {
            print("{} ", .{v});
        }
        print("\n", .{} );

        const results = try solveTestCase(allocator, test_case.n, test_case.values, test_case.queries);
        defer allocator.free(results);

        print("Queries and Results:\n", .{});
        for (test_case.queries, 0..) |query, q_idx| {
            const i = query[0];
            const j = query[1];
            const result = results[q_idx];
            const exp = test_case.expected[q_idx];

            print("Query: {} {}\n", .{ i, j });
            print("Result: {} (Expected: {})\n", .{ result, exp });
            if (result != exp) {
                print("  WARNING: Result doesn't match expected output\n", .{});
            }
        }

        print("\n", .{} );
    }
}
