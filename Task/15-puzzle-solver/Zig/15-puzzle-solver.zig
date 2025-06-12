const std       = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const PriorityQueue = std.PriorityQueue;
const AutoHashMap  = std.AutoHashMap;

// Constants for the puzzle
const CORRECT_ORDER = [16]u8{ 1,2,3,4, 5,6,7,8, 9,10,11,12, 13,14,15,0 };
const ROW    = [16]i32{ 0,0,0,0, 1,1,1,1, 2,2,2,2, 3,3,3,3 };
const COLUMN = [16]i32{ 0,1,2,3, 0,1,2,3, 0,1,2,3, 0,1,2,3 };

// State struct to represent the puzzle state
const State = struct {
    est_tot_moves: u8,
    moves: []u8,
    est_moves_rem: u8,
    allocator: Allocator,

    pub fn init(allocator: Allocator, order: [16]u8) !State {
        return State{
            .est_tot_moves = estimate_moves(order),
            .moves          = try allocator.dupe(u8, ""), // empty
            .est_moves_rem  = estimate_moves(order),
            .allocator      = allocator,
        };
    }

    pub fn deinit(self: *State) void {
        self.allocator.free(self.moves);
    }
};

// BoardState represents the entire game state
const BoardState = struct {
    order: [16]u8,
    state: State,
};

// Find the index of a tile in the order array
fn findIndex(order: [16]u8, tile: u8) usize {
    var i: usize = 0;
    for (order) |v| {
        if (v == tile) return i;
        i += 1;
    }
    @panic("findIndex: tile not found");
}

// Estimate the number of moves (Manhattan distance)
fn estimate_moves(current: [16]u8) u8 {
    var h: u8 = 0;
    for (current) |tile| {
        const ci = findIndex(current, tile);
        const gi = findIndex(CORRECT_ORDER, tile);
        const rd = @abs(ROW[ci] - ROW[gi]);
        const cd = @abs(COLUMN[ci] - COLUMN[gi]);
        h += @as(u8, @intCast(rd + cd));
    }
    return h;
}

// Make a single move (swap hole with neighbor)
fn makeMove(
    allocator: Allocator,
    parent: *const State,
    order: [16]u8,
    dir: u8,
    idx: usize,
    new_idx: usize,
) !BoardState {
    var new_order = order;
    new_order[idx]     = order[new_idx];
    new_order[new_idx] = order[idx];

    const rem = estimate_moves(new_order);
    const mv: [1]u8 = .{dir};
    const combined = try std.mem.concat(allocator, u8, &[_][]const u8{ parent.moves, &mv });

    return BoardState{
        .order = new_order,
        .state = State{
            .est_tot_moves = @as(u8, @intCast(combined.len)) + rem,
            .moves         = combined,
            .est_moves_rem = rem,
            .allocator     = allocator,
        },
    };
}

// Generate all children from a parent (takes *const so we don't double-free)
fn generateChildren(allocator: Allocator, parent: *const BoardState) !ArrayList(BoardState) {
    var children = ArrayList(BoardState).init(allocator);
    const hole = findIndex(parent.order, 0);

    if (COLUMN[hole] > 0) {
        const c = try makeMove(allocator, &parent.state, parent.order, 'l', hole, hole - 1);
        try children.append(c);
    }
    if (COLUMN[hole] < 3) {
        const c = try makeMove(allocator, &parent.state, parent.order, 'r', hole, hole + 1);
        try children.append(c);
    }
    if (ROW[hole] > 0) {
        const c = try makeMove(allocator, &parent.state, parent.order, 'u', hole, hole - 4);
        try children.append(c);
    }
    if (ROW[hole] < 3) {
        const c = try makeMove(allocator, &parent.state, parent.order, 'd', hole, hole + 4);
        try children.append(c);
    }

    return children;
}

// Compare function for priority queue
fn boardCompare(_: void, a: BoardState, b: BoardState) std.math.Order {
    return std.math.order(a.state.est_tot_moves, b.state.est_tot_moves);
}

// Hash an order into a u64
fn hashOrder(order: [16]u8) u64 {
    var r: u64 = 0;
    for (order) |v| r = (r << 4) | v;
    return r;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var open_states = PriorityQueue(BoardState, void, boardCompare).init(allocator, {});
    defer {
        while (open_states.count() > 0) {
            var item = open_states.remove();
            item.state.deinit();
        }
        open_states.deinit();
    }

    var closed_states = AutoHashMap(u64, void).init(allocator);
    defer closed_states.deinit();

    const start_order = [16]u8{15,14,1,6,9,11,4,12, 0,10,7,3,13,8,5,2};
    const initial_state = try State.init(allocator, start_order);
    try open_states.add(BoardState{ .order = start_order, .state = initial_state });

    const stdout = std.io.getStdOut().writer();

    while (open_states.count() > 0) {
        var current = open_states.remove();

        // goal check
        if (std.mem.eql(u8, &current.order, &CORRECT_ORDER)) {
            try stdout.print(
                "Open: {d}, Closed: {d}, Moves: {d}\n",
                .{ open_states.count(), closed_states.count(), current.state.moves.len },
            );
            try stdout.print("Path: {s}\n", .{ current.state.moves });
            current.state.deinit();
            break;
        }

        const h = hashOrder(current.order);
        if (closed_states.contains(h)) {
            current.state.deinit();
            continue;
        }
        try closed_states.put(h, {});

        var children = try generateChildren(allocator, &current);
        defer children.deinit();

        // ↓ Here’s the fix: shadow each child into a mutable `var child`
        for (children.items) |child| {
            var my_child = child; // now `child.state.deinit()` sees a `*State`, not `*const State`
            const ch = hashOrder(my_child.order);
            if (closed_states.contains(ch)) {
                my_child.state.deinit();
                continue;
            }
            try open_states.add(my_child);
        }

        current.state.deinit();
    }
}
