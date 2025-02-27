const std = @import("std");
const print = std.debug.print;
pub fn main() void {

  print("032: Spc ", .{});
  for(33..127) |i| {
    print("{:03}: {c:<4}", .{ i, std.math.cast(u8, i).? });
    if (@mod(i, 6) == 1) {
      print("\n", .{});
    }
  }
  print("127: Del", .{});
}
