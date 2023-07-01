const std = @import("std");
pub fn main() void {
  const string = "Hello,How,Are,You,Today";
  var tokens = std.mem.split(u8, string, ",");
  std.debug.print("{s}", .{tokens.next().?});
  while (tokens.next()) |token| {
    std.debug.print(".{s}", .{token});
  }
}
