const print = @import("std").debug.print;
pub fn main() void {
  var i: u8 = 33;
  print(" 32: Spc", .{});
  while (i < 127) : (i += 1) {
    print("{:03}: {c}  ", .{ i, i });
    if (@mod(i, 6) == 1) {
      print("\n", .{});
    }
  }
  print("127: Del", .{});
}
