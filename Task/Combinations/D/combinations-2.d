import std.stdio, std.algorithm, std.range;

T[][] comb(T)(in T[] s, in int m) /*pure*/ nothrow {
  if (!m) return [[]];
  if (s.empty) return [];
  return s[1 .. $].comb(m - 1).map!(x => s[0] ~ x).array ~
         s[1 .. $].comb(m);
}

void main() {
    4.iota.array.comb(2).writeln;
}
