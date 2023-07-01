struct Hailstone {
  uint n;
  bool empty() const pure nothrow @nogc { return n == 0; }
  uint front() const pure nothrow @nogc { return n; }
  void popFront() pure nothrow @nogc {
    n = n == 1 ? 0 : (n & 1 ? (n * 3 + 1) : n / 2);
  }
}

void main() {
  import std.stdio, std.algorithm, std.range, std.typecons;

  enum M = 27;
  immutable h = M.Hailstone.array;
  writeln("hailstone(", M, ")= ", h[0 .. 4], " ... " , h[$ - 4 .. $]);
  writeln("Length hailstone(", M, ")= ", h.length);

  enum N = 100_000;
  immutable p = iota(1, N)
                .map!(i => tuple(i.Hailstone.walkLength, i))
                .reduce!max;
  writeln("Longest sequence in [1,", N, "]= ",p[1]," with len ",p[0]);
}
