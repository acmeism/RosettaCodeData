const std = @import("std");

const Node = struct {
    val: isize,
    neighbors: u8,
};

const NSolver = struct {
    dx: [8]isize = .{-1, -1, 1, 1, -2, -2, 2, 2},
    dy: [8]isize = .{-2, 2, -2, 2, -1, 1, -1, 1},
    wid: usize,
    hei: usize,
    max: usize,
    arr: []Node,
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator) NSolver {
        return NSolver{
            .wid = 0,
            .hei = 0,
            .max = 0,
            .arr = &[_]Node{}, // will be overwritten in `solve`
            .allocator = allocator,
        };
    }

    // The key problem was here - tokens was being passed as a pointer to a split iterator
    // but the function expected [][]const u8
    pub fn solve(self: *NSolver, puzz: []const u8, max_wid: usize) ![][]const u8 {
        // Split the input string into tokens
        var tokens = std.ArrayList([]const u8).init(self.allocator);
        defer tokens.deinit();

        var iter = std.mem.splitSequence(u8, puzz, " ");
        while (iter.next()) |tok| {
            if (tok.len == 0) continue; // Skip empty tokens
            try tokens.append(tok);
        }

        if (tokens.items.len == 0) return &[_][]const u8{};

        self.wid = max_wid;
        self.hei = tokens.items.len / max_wid;
        self.max = tokens.items.len;
        const len = self.wid * self.hei;

        // allocate and zero‐initialize the board
        self.arr = try self.allocator.alloc(Node, len);
        for (self.arr) |*n| {
            n.* = Node{ .val = 0, .neighbors = 0 };
        }

        // parse the input tokens into our board
        var c: usize = 0;
        for (tokens.items) |tok| {
            if (std.mem.eql(u8, tok, "*")) {
                self.max -= 1;
                self.arr[c].val = -1;
            } else if (std.mem.eql(u8, tok, ".")) {
                // leave . as 0 for "empty"
                self.arr[c].val = 0;
            } else {
                // parse a pre‐filled number
                const v = try std.fmt.parseInt(isize, tok, 10);
                self.arr[c].val = v;
            }
            c += 1;
        }

        // run the backtracking search
        self.solveIt();

        // Create result array to hold the modified tokens
        var result = try self.allocator.alloc([]const u8, tokens.items.len);

        // write back any "." slots with zero‐padded numbers
        c = 0;
        for (tokens.items, 0..) |tok, i| {
            if (std.mem.eql(u8, tok, ".")) {
                const v = self.arr[c].val;
                // format as two digits, zero-pad
                result[i] = try std.fmt.allocPrint(self.allocator, "{d:0>2}", .{v});
            } else {
                // For non-modified tokens, just copy the reference
                result[i] = tok;
            }
            c += 1;
        }

        return result;
    }

    fn solveIt(self: *NSolver) void {
        const start = self.findStart();
        if (start.z == @as(isize, @intCast(std.math.maxInt(isize)))) {
            std.debug.print("Can't find start point!\n", .{});
            return;
        }
        _ = self.search(start.x, start.y, start.z + 1);
    }

    fn findStart(self: *NSolver) struct { x: usize, y: usize, z: isize } {
        var best_x: usize = 0;
        var best_y: usize = 0;
        var best_z: isize = std.math.maxInt(isize);

        // The original code had a bug here - trying to iterate over the height and width directly
        var b: usize = 0;
        while (b < self.hei) : (b += 1) {
            var a: usize = 0;
            while (a < self.wid) : (a += 1) {
                const idx = a + b * self.wid;
                const v = self.arr[idx].val;
                if (v > 0 and v < best_z) {
                    best_x = a;
                    best_y = b;
                    best_z = v;
                }
            }
        }

        return .{ .x = best_x, .y = best_y, .z = best_z };
    }

    fn search(self: *NSolver, x: usize, y: usize, w: isize) bool {
        if (w > @as(isize, @intCast(self.max))) return true;

        const idx = x + y * self.wid;
        self.arr[idx].neighbors = self.getNeighbors(x, y);

        // The original code had a bug here - trying to iterate over dx directly
        for (0..self.dx.len) |d| {
            if ((self.arr[idx].neighbors & (@as(u8, 1) << @as(u3, @intCast(d)))) != 0) {
                const a_s = @as(isize, @intCast(x)) + self.dx[d];
                const b_s = @as(isize, @intCast(y)) + self.dy[d];
                if (a_s >= 0 and b_s >= 0) {
                    const a = @as(usize, @intCast(a_s));
                    const b = @as(usize, @intCast(b_s));
                    if (a < self.wid and b < self.hei) {
                        const n_idx = a + b * self.wid;
                        if (self.arr[n_idx].val == 0) {
                            self.arr[n_idx].val = w;
                            if (self.search(a, b, w + 1)) return true;
                            self.arr[n_idx].val = 0;
                        }
                    }
                }
            }
        }
        return false;
    }

    fn getNeighbors(self: *NSolver, x: usize, y: usize) u8 {
        var mask: u8 = 0;
        for (0..self.dx.len) |i| {
            const a_s = @as(isize, @intCast(x)) + self.dx[i];
            const b_s = @as(isize, @intCast(y)) + self.dy[i];
            if (a_s >= 0 and b_s >= 0) {
                const a = @as(usize, @intCast(a_s));
                const b = @as(usize, @intCast(b_s));
                if (a < self.wid and b < self.hei) {
                    if (self.arr[a + b * self.wid].val > -1) {
                        mask |= ( @as(u8, 1) << @as(u3, @intCast(i)));
                    }
                }
            }
        }
        return mask;
    }
};

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const allocator = std.heap.page_allocator;

    // Example puzzle (same as your Rust example)
    const p_str = "* * * * * 1 * . * * * * * * * * * * . * . * * * * * * * * * . . . . . * * * * * * * * * . . . * * * * * * * . * * . * . * * . * * . . . . . * * * . . . . . * * . . * * * * * . . * * . . . . . * * * . . . . . * * . * * . * . * * . * * * * * * * . . . * * * * * * * * * . . . . . * * * * * * * * * . * . * * * * * * * * * * . * . * * * * * ";
    const wid: usize = 13;

    // solve
    var solver = NSolver.init(allocator);
    const result = try solver.solve(p_str, wid);
    defer allocator.free(solver.arr);

    // Print the solved board
    var count: usize = 0;
    for (result) |tok| {
        if (std.mem.eql(u8, tok, "*")) {
            try stdout.print("   ", .{});
        } else {
            try stdout.print("{s} ", .{tok});
        }
        count += 1;
        if (count == wid) {
            try stdout.print("\n", .{});
            count = 0;
        }
    }
    try stdout.print("\n", .{});

    // Free allocated memory for any new tokens
    for (result) |tok| {
        if (!std.mem.eql(u8, tok, "*") and !std.mem.eql(u8, tok, ".") and !std.mem.eql(u8, tok, "1")) {
            allocator.free(tok);
        }
    }
    allocator.free(result);
}
