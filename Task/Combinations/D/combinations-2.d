import std.stdio, std.algorithm, std.range;

immutable(int)[][] comb(immutable int[] s, in int m) pure nothrow @safe {
  if (!m) return [[]];
  if (s.empty) return [];
  return s[1 .. $].comb(m - 1).map!(x => s[0] ~ x).array ~ s[1 .. $].comb(m);
}

void main() {
    4.iota.array.comb(2).writeln;
}
