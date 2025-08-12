const std = @import("std");
const print = std.debug.print;
const Allocator = std.mem.Allocator;

const Factory = struct {
    count: u32,
    allocator: Allocator,
    ref_count: u32,

    const Self = @This();

    pub fn create(allocator: Allocator) !*Self {
        const factory = try allocator.create(Self);
        factory.* = Self{
            .count = 0,
            .allocator = allocator,
            .ref_count = 1,
        };
        return factory;
    }

    pub fn retain(self: *Self) *Self {
        self.ref_count += 1;
        return self;
    }

    pub fn release(self: *Self) void {
        self.ref_count -= 1;
        if (self.ref_count == 0) {
            self.allocator.destroy(self);
        }
    }

    pub fn getWidget(self: *Self) !Widget {
        return Widget.create(self);
    }

    fn incrementCount(self: *Self) void {
        self.count += 1;
        print("Widget spawning. There are now {} Widgets instantiated.\n", .{self.count});
    }

    fn decrementCount(self: *Self) void {
        self.count -= 1;
        print("Widget dying. There are now {} Widgets instantiated.\n", .{self.count});
    }
};

const Widget = struct {
    parent: ?*Factory,

    const Self = @This();

    pub fn create(parent: *Factory) Self {
        _ = parent.retain(); // Increment parent's reference count
        parent.incrementCount();

        return Self{
            .parent = parent,
        };
    }

    pub fn deinit(self: *Self) void {
        if (self.parent) |parent| {
            parent.decrementCount();
            parent.release();
            self.parent = null;
        }
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const factory = try Factory.create(allocator);
    defer factory.release();

    var widget1 = try factory.getWidget();
    var widget2 = try factory.getWidget();

    widget1.deinit();

    var widget3 = try factory.getWidget();
    widget3.deinit();
    widget2.deinit();
}
