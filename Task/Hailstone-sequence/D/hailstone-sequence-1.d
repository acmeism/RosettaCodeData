import std.stdio, std.algorithm, std.range, std.typecons;

auto hailstone(int n) pure nothrow {
  auto result = [n];
  while (n != 1) {
    n = n & 1 ? n*3 + 1 : n/2;
    result ~= n;
  }
  return result;
}

void main() {
  enum M = 27;
  auto h = hailstone(M);
  writeln("hailstone(", M, ")= ", h[0 .. 4], " ... " , h[$-4 .. $]);
  writeln("length hailstone(", M, ")= ", h.length);

  enum N = 100_000;
  auto s = iota(1, N).map!(i => tuple(hailstone(i).length, i))();
  auto p = reduce!max(s);
  writeln("Longest sequence in [1,", N, "]= ",p[1]," with len ",p[0]);
}
