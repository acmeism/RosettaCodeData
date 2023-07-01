const std = @import("std");
fn concat(allocator: std.mem.Allocator, a: []const u32, b: []const u32) ![]u32 {
  const result = try allocator.alloc(u32, a.len + b.len);
  std.mem.copy(u32, result, a);
  std.mem.copy(u32, result[a.len..], b);
  return result;
}

pub fn main() void {
  var general_purpose_allocator = std.heap.GeneralPurposeAllocator(.{}){};
  const gpa = general_purpose_allocator.allocator();
  var array1 = [_]u32{ 1, 2, 3, 4, 5 };
  var array2 = [_]u32{ 6, 7, 8, 9, 10, 11, 12 };
  const array3 = concat(gpa, &array1, &array2);
  std.debug.print("Array 1: {any}\nArray 2: {any}\nArray 3: {any}", .{ array1, array2, array3 });
}
