const std = @import("std");
const ArrayList = std.ArrayList;
const HashMap = std.HashMap;
const print = std.debug.print;
const Allocator = std.mem.Allocator;

// Simple graph representation using adjacency lists
const Graph = struct {
    neighbors: ArrayList(ArrayList(usize)),
    allocator: Allocator,

    const Self = @This();

    pub fn init(allocator: Allocator, size: usize) !Self {
        var neighbors = ArrayList(ArrayList(usize)).init(allocator);
        try neighbors.ensureTotalCapacity(size);

        for (0..size) |_| {
            try neighbors.append(ArrayList(usize).init(allocator));
        }

        return Self{
            .neighbors = neighbors,
            .allocator = allocator,
        };
    }

    pub fn deinit(self: *Self) void {
        for (self.neighbors.items) |*neighbor_list| {
            neighbor_list.deinit();
        }
        self.neighbors.deinit();
    }

    pub fn addEdge(self: *Self, from: usize, to: usize) !void {
        std.debug.assert(to < self.len());
        try self.neighbors.items[from].append(to);
    }

    pub fn addEdges(self: *Self, from: usize, to: []const usize) !void {
        const limit = self.len();
        for (to) |vertex| {
            std.debug.assert(vertex < limit);
            try self.neighbors.items[from].append(vertex);
        }
    }

    pub fn getEdges(self: *const Self, vertex: usize) []const usize {
        return self.neighbors.items[vertex].items;
    }

    pub fn isEmpty(self: *const Self) bool {
        return self.neighbors.items.len == 0;
    }

    pub fn len(self: *const Self) usize {
        return self.neighbors.items.len;
    }
};

const VertexState = struct {
    index: usize,
    low_link: usize,
    on_stack: bool,
};

const Tarjan = struct {
    graph: *const Graph,
    index: usize,
    stack: ArrayList(usize),
    state: ArrayList(VertexState),
    components: ArrayList(ArrayList(usize)),
    allocator: Allocator,

    const Self = @This();
    const INVALID_INDEX: usize = std.math.maxInt(usize);

    pub fn init(allocator: Allocator, graph: *const Graph) !Self {
        var state = ArrayList(VertexState).init(allocator);
        try state.ensureTotalCapacity(graph.len());

        for (0..graph.len()) |_| {
            try state.append(VertexState{
                .index = INVALID_INDEX,
                .low_link = INVALID_INDEX,
                .on_stack = false,
            });
        }

        return Self{
            .graph = graph,
            .index = 0,
            .stack = ArrayList(usize).init(allocator),
            .state = state,
            .components = ArrayList(ArrayList(usize)).init(allocator),
            .allocator = allocator,
        };
    }

    pub fn deinit(self: *Self) void {
        for (self.components.items) |*component| {
            component.deinit();
        }
        self.components.deinit();
        self.stack.deinit();
        self.state.deinit();
    }

    pub fn walk(allocator: Allocator, graph: *const Graph) !ArrayList(ArrayList(usize)) {
        var tarjan = try Self.init(allocator, graph);
        defer tarjan.deinit();

        return try tarjan.visitAll();
    }

    fn visitAll(self: *Self) !ArrayList(ArrayList(usize)) {
        for (0..self.graph.len()) |vertex| {
            if (self.state.items[vertex].index == INVALID_INDEX) {
                try self.visit(vertex);
            }
        }

        // Move components out to avoid double-free
        var result = ArrayList(ArrayList(usize)).init(self.allocator);
        try result.ensureTotalCapacity(self.components.items.len);

        for (self.components.items) |component| {
            try result.append(component);
        }

        // Clear the original components to avoid double-free
        self.components.clearRetainingCapacity();

        return result;
    }

    fn visit(self: *Self, v: usize) !void {
        self.state.items[v].index = self.index;
        self.state.items[v].low_link = self.index;
        self.index += 1;
        try self.stack.append(v);
        self.state.items[v].on_stack = true;

        for (self.graph.getEdges(v)) |w| {
            if (self.state.items[w].index == INVALID_INDEX) {
                try self.visit(w);
                const w_low_link = self.state.items[w].low_link;
                self.state.items[v].low_link = @min(self.state.items[v].low_link, w_low_link);
            } else if (self.state.items[w].on_stack) {
                const w_index = self.state.items[w].index;
                self.state.items[v].low_link = @min(self.state.items[v].low_link, w_index);
            }
        }

        if (self.state.items[v].low_link == self.state.items[v].index) {
            var component = ArrayList(usize).init(self.allocator);

            while (true) {
                const w = self.stack.pop().?;
                self.state.items[w].on_stack = false;
                try component.append(w);
                if (w == v) {
                    break;
                }
            }

            try self.components.append(component);
        }
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var graph = try Graph.init(allocator, 8);
    defer graph.deinit();

    try graph.addEdge(0, 1);
    try graph.addEdge(2, 0);
    try graph.addEdges(5, &[_]usize{ 2, 6 });
    try graph.addEdge(6, 5);
    try graph.addEdge(1, 2);
    try graph.addEdges(3, &[_]usize{ 1, 2, 4 });
    try graph.addEdges(4, &[_]usize{ 5, 3 });
    try graph.addEdges(7, &[_]usize{ 4, 7, 6 });

    var components = try Tarjan.walk(allocator, &graph);
    defer {
        for (components.items) |*component| {
            component.deinit();
        }
        components.deinit();
    }

    for (components.items) |component| {
        print("{any}\n", .{component.items});
    }
}
