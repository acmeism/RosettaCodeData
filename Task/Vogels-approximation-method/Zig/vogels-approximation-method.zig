const std = @import("std");
const print = std.debug.print;
const ArrayList = std.ArrayList;

const Vogel = struct {
    supply: ArrayList(i32),
    demand: ArrayList(i32),
    costs: ArrayList(ArrayList(i32)),
    n_rows: i32,
    n_cols: i32,
    row_done: ArrayList(bool),
    col_done: ArrayList(bool),
    allocator: std.mem.Allocator,

    const Self = @This();

    pub fn init(allocator: std.mem.Allocator) Self {
        return Self{
            .supply = ArrayList(i32).init(allocator),
            .demand = ArrayList(i32).init(allocator),
            .costs = ArrayList(ArrayList(i32)).init(allocator),
            .n_rows = 0,
            .n_cols = 0,
            .row_done = ArrayList(bool).init(allocator),
            .col_done = ArrayList(bool).init(allocator),
            .allocator = allocator,
        };
    }

    pub fn deinit(self: *Self) void {
        self.supply.deinit();
        self.demand.deinit();
        for (self.costs.items) |*row| {
            row.deinit();
        }
        self.costs.deinit();
        self.row_done.deinit();
        self.col_done.deinit();
    }

    pub fn approximate(self: *Self) !void {
        var results = ArrayList(ArrayList(i32)).init(self.allocator);
        defer {
            for (results.items) |*row| {
                row.deinit();
            }
            results.deinit();
        }

        // Initialize results matrix
        for (0..@intCast(self.n_rows)) |_| {
            var row = ArrayList(i32).init(self.allocator);
            for (0..@intCast(self.n_cols)) |_| {
                try row.append(0);
            }
            try results.append(row);
        }

        var supply_remaining: i32 = 0;
        for (self.supply.items) |s| {
            supply_remaining += s;
        }

        var total_cost: i32 = 0;

        while (supply_remaining > 0) {
            const cell = try self.next_cell();
            const r = cell[0];
            const c = cell[1];
            const q = if (self.demand.items[c] < self.supply.items[r])
                self.demand.items[c]
            else
                self.supply.items[r];

            self.demand.items[c] -= q;
            if (self.demand.items[c] == 0) {
                self.col_done.items[c] = true;
            }

            self.supply.items[r] -= q;
            if (self.supply.items[r] == 0) {
                self.row_done.items[r] = true;
            }

            results.items[r].items[c] = q;
            supply_remaining -= q;
            total_cost += q * self.costs.items[r].items[c];
        }

        print("    A   B   C   D   E\n", .{});
        for (results.items, 0..) |result, i| {
            print("{c}", .{@as(u8, @intCast('W' + i))});
            for (result.items) |item| {
                print("  {:>2}", .{item});
            }
            print("\n", .{});
        }
        print("\nTotal Cost = {}\n", .{total_cost});
    }

    fn next_cell(self: *Self) ![]usize {
        const res1 = try self.max_penalty(self.n_rows, self.n_cols, true);
        const res2 = try self.max_penalty(self.n_cols, self.n_rows, false);

        if (res1[3] == res2[3]) {
            return if (res1[2] < res2[2]) res1 else res2;
        }
        return if (res1[3] > res2[3]) res2 else res1;
    }

    fn max_penalty(self: *Self, len1: i32, len2: i32, is_row: bool) ![]usize {
        var md: i32 = std.math.minInt(i32);
        var pc: i32 = -1;
        var pm: i32 = -1;
        var mc: i32 = -1;

        for (0..@intCast(len1)) |i| {
            const should_process = if (is_row)
                !self.row_done.items[i]
            else
                !self.col_done.items[i];

            if (should_process) {
                var min1: i32 = std.math.maxInt(i32);
                var min2: i32 = min1;
                var min_p: i32 = -1;

                for (0..@intCast(len2)) |j| {
                    const should_process_inner = if (is_row)
                        !self.col_done.items[j]
                    else
                        !self.row_done.items[j];

                    if (should_process_inner) {
                        const c = if (is_row)
                            self.costs.items[i].items[j]
                        else
                            self.costs.items[j].items[i];

                        if (c < min1) {
                            min2 = min1;
                            min1 = c;
                            min_p = @intCast(j);
                        } else if (c < min2) {
                            min2 = c;
                        }
                    }
                }

                const diff = min2 - min1;
                if (diff > md) {
                    md = diff;
                    pm = @intCast(i);
                    mc = min1;
                    pc = min_p;
                }
            }
        }

        var result = try self.allocator.alloc(usize, 4);
        if (is_row) {
            result[0] = @intCast(pm);
            result[1] = @intCast(pc);
            result[2] = @intCast(mc);
            result[3] = @intCast(md);
        } else {
            result[0] = @intCast(pc);
            result[1] = @intCast(pm);
            result[2] = @intCast(mc);
            result[3] = @intCast(md);
        }
        return result;
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var my_test = Vogel.init(allocator);
    defer my_test.deinit();

    // Initialize supply
    try my_test.supply.appendSlice(&[_]i32{ 50, 60, 50, 50 });

    // Initialize demand
    try my_test.demand.appendSlice(&[_]i32{ 30, 20, 70, 30, 60 });

    // Initialize costs matrix
    const cost_data = [_][]const i32{
        &[_]i32{ 16, 16, 13, 22, 17 },
        &[_]i32{ 14, 14, 13, 19, 15 },
        &[_]i32{ 19, 19, 20, 23, 50 },
        &[_]i32{ 50, 12, 50, 15, 11 },
    };

    for (cost_data) |row_data| {
        var row = ArrayList(i32).init(allocator);
        try row.appendSlice(row_data);
        try my_test.costs.append(row);
    }

    my_test.n_rows = 4;
    my_test.n_cols = 5;

    // Initialize row_done and col_done
    try my_test.row_done.appendNTimes(false, 4);
    try my_test.col_done.appendNTimes(false, 5);

    try my_test.approximate();
}
