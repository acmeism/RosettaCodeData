pub fn gcd(u: anytype, v: anytype) @TypeOf(u) {
  if (@typeInfo(@TypeOf(u)) != .Int) {
    @compileError("non-integer type used on gcd: " ++ @typeName(@TypeOf(u)));
  }
  if (@typeInfo(@TypeOf(v)) != .Int) {
    @compileError("non-integer type used on gcd: " ++ @typeName(@TypeOf(v)));
  }
  return if (v != 0) gcd(v, @mod(u,v)) else u;
}
