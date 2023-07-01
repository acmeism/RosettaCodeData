const print = @import("std").debug.print;
pub fn main() void {
  const numbers = [_]u8{ 1, 2, 3, 4, 5 };
  var sum: u8 = 0;
  var product: u8 = 1;
  for (numbers) |number| {
    product *= number;
    sum += number;
  }
  print("{} {}\n", .{ product, sum });
}
