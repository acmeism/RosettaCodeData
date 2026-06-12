const std = @import("std");
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

fn VList(comptime T: type) type {
    return struct {
        const Self = @This();

        const Node = struct {
            data: []T,
            ref_count: usize,

            fn init(allocator: Allocator, size: usize) !*Node {
                const node = try allocator.create(Node);
                node.data = try allocator.alloc(T, size);
                node.ref_count = 1;
                return node;
            }

            fn retain(self: *Node) void {
                self.ref_count += 1;
            }

            fn release(self: *Node, allocator: Allocator) void {
                self.ref_count -= 1;
                if (self.ref_count == 0) {
                    allocator.free(self.data);
                    allocator.destroy(self);
                }
            }
        };

        datas: ArrayList(*Node),
        offset: usize,
        allocator: Allocator,

        pub fn init(allocator: Allocator) Self {
            return Self{
                .datas = ArrayList(*Node){},
                .offset = 0,
                .allocator = allocator,
            };
        }

        pub fn deinit(self: *Self) void {
            for (self.datas.items) |node| {
                node.release(self.allocator);
            }
            self.datas.deinit(self.allocator);
        }

        pub fn cons(self: *Self, a: T) !void {
            if (self.datas.items.len == 0) {
                const node = try Node.init(self.allocator, 1);
                node.data[0] = a;
                try self.datas.insert(self.allocator, 0, node);
                self.offset = 0;
                return;
            }

            if (self.offset == 0) {
                const new_capacity = self.datas.items[0].data.len * 2;
                const new_offset = new_capacity - 1;
                const node = try Node.init(self.allocator, new_capacity);

                // Initialize with default values
                for (node.data) |*item| {
                    item.* = std.mem.zeroes(T);
                }
                node.data[new_offset] = a;

                try self.datas.insert(self.allocator, 0, node);
                self.offset = new_offset;
                return;
            }

            self.offset -= 1;
            // Create a new node since the old one might be shared
            const old_node = self.datas.items[0];
            const node = try Node.init(self.allocator, old_node.data.len);
            @memcpy(node.data, old_node.data);
            node.data[self.offset] = a;

            old_node.release(self.allocator);
            self.datas.items[0] = node;
        }

        pub fn cdr(self: *const Self) !Self {
            if (self.datas.items.len == 0) {
                return Self.init(self.allocator);
            }

            var new_vlist = Self{
                .datas = try self.datas.clone(self.allocator),
                .offset = self.offset + 1,
                .allocator = self.allocator,
            };

            // Increment reference counts
            for (new_vlist.datas.items) |node| {
                node.retain();
            }

            if (new_vlist.offset < new_vlist.datas.items[0].data.len) {
                return new_vlist;
            }

            new_vlist.offset = 0;
            const node = new_vlist.datas.orderedRemove(0);
            node.release(self.allocator);

            return new_vlist;
        }

        pub fn length(self: *const Self) usize {
            if (self.datas.items.len == 0) {
                return 0;
            }
            return self.datas.items[0].data.len * 2 - self.offset - 1;
        }

        pub fn index(self: *const Self, i: usize) ?T {
            if (self.datas.items.len == 0) {
                return null;
            }

            var idx = i + self.offset;
            for (self.datas.items) |data| {
                if (idx < data.data.len) {
                    return data.data[idx];
                }
                idx -= data.data.len;
            }
            return null;
        }

        pub fn printList(self: *const Self) void {
            if (self.datas.items.len == 0) {
                std.debug.print("[]\n", .{});
                return;
            }

            const first = self.datas.items[0];
            std.debug.print("[", .{});

            for (self.offset..first.data.len) |i| {
                std.debug.print(" {c}", .{first.data[i]});
            }

            for (self.datas.items[1..]) |data| {
                for (0..data.data.len) |i| {
                    std.debug.print(" {c}", .{data.data[i]});
                }
            }

            std.debug.print(" ]\n", .{});
        }

        pub fn printStructure(self: *const Self) void {
            std.debug.print("offset:{}\n", .{self.offset});
            if (self.datas.items.len == 0) {
                std.debug.print("[]\n", .{});
                return;
            }

            const first = self.datas.items[0];
            std.debug.print("[", .{});
            for (self.offset..first.data.len) |i| {
                std.debug.print(" {c}", .{first.data[i]});
            }
            std.debug.print(" ]\n", .{});

            for (self.datas.items[1..]) |data| {
                std.debug.print("[", .{});
                for (0..data.data.len) |i| {
                    std.debug.print(" {c}", .{data.data[i]});
                }
                std.debug.print(" ]\n", .{});
            }
            std.debug.print("\n", .{});
        }
    };
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var vlist = VList(u8).init(allocator);
    defer vlist.deinit();

    std.debug.print("zero value for type.  empty vList:\n", .{});
    vlist.printList();
    vlist.printStructure();

    std.debug.print("demonstrate cons. 6 elements added:\n", .{});
    var ch: u8 = '6';
    while (ch >= '1') : (ch -= 1) {
        try vlist.cons(ch);
        if (ch == '1') break;
    }
    vlist.printList();
    vlist.printStructure();

    std.debug.print("demonstrate cdr. 1 element removed:\n", .{});
    var vlist2 = try vlist.cdr();
    defer vlist2.deinit();
    vlist2.printList();
    vlist2.printStructure();

    std.debug.print("demonstrate length. length = {}\n", .{vlist2.length()});

    if (vlist2.index(3)) |element| {
        std.debug.print("demonstrate element access. v[3] = {c}\n", .{element});
    }

    std.debug.print("show cdr releasing segment. 2 elements removed:\n", .{});
    var vlist3 = try vlist2.cdr();
    defer vlist3.deinit();
    var vlist4 = try vlist3.cdr();
    defer vlist4.deinit();
    vlist4.printList();
    vlist4.printStructure();
}
