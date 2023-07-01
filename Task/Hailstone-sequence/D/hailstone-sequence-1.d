import std.stdio, std.algorithm, std.range, std.typecons;

auto hailstone(uint n) pure nothrow {
  auto result = [n];
  while (n != 1) {
    n = (n & 1) ? (n * 3 + 1) : (n / 2);
    result ~= n;
  }
  return result;
}

void main() {
  enum M = 27;
  immutable h = M.hailstone;
  writeln("hailstone(", M, ")= ", h[0 .. 4], " ... " , h[$ - 4 .. $]);
  writeln("Length hailstone(", M, ")= ", h.length);

  enum N = 100_000;
  immutable p = iota(1, N)
                .map!(i => tuple(i.hailstone.length, i))
                .reduce!max;
  writeln("Longest sequence in [1,", N, "]= ",p[1]," with len ",p[0]);
}
