const print = @import("std").debug.print;
pub fn main() void {
  var i: u8 = 99;
  while (i > 2) : (i-= 1) {
  print(
    \\{} bottles of beer on the wall, {} bottles of beer.
    \\Take one down and pass it around, {} bottles of beer on the wall.
    \\
    \\
   , .{i, i, i-1});
  }
  print(
    \\2 bottles of beer on the wall, 2 bottles of beer.
    \\Take one down and pass it around, 1 bottle of beer on the wall.
    \\
    \\1 bottle of beer on the wall, 1 bottle of beer.
    \\Take one down and pass it around, no more bottles of beer on the wall.
    \\
    \\No more bottles of beer on the wall, no more bottles of beer.
    \\Go to the store and buy some more, 99 bottles of beer on the wall.
  , .{});
}
