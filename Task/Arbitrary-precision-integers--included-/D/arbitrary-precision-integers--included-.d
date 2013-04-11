import std.stdio, std.bigint, std.conv;

void main() {
  auto s = text(BigInt(5) ^^ 4 ^^ 3 ^^ 2);
  writefln("5^4^3^2 = %s..%s (%d digits)", s[0..20], s[$-20..$], s.length);
}
