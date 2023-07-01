pub fn isLeapYear(year: anytype) bool {
  const inttype = @TypeOf(year);
  if (@typeInfo(inttype) != .Int) {
    @compileError("non-integer type used on leap year: " ++ @typeName(inttype));
  }
  return (if (@mod(year, @as(inttype, 100)) == 0)
    @mod(year, @as(inttype, 400)) == 0
  else
    @mod(year, @as(inttype, 4)) == 0);
}
