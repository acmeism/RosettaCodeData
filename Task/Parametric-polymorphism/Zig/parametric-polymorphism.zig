const std = @import("std");

pub fn main() void {
    var tree = Tree(u8).init(10);
    std.debug.print("Before: {}\n", .{tree.value});
    tree.replace_all(65);
    std.debug.print("After: {}\n", .{tree.value});

}

pub fn Tree(T: type) type {

    return struct {
      const Self = @This();
      value: T,
      left: ?*Self,
      right: ?*Self,

      pub fn init(value: T) Self {
          return Self{
              .value = value,
              .left = null,
              .right = null,
          };
      }

      pub fn replace_all(self: *Self, value: T) void {
          self.value = value;
          if (self.left) |_| self.left.?.replace_all(value);
          if (self.right) |_| self.right.?.replace_all(value);
      }
    };
}
