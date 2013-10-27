import std.stdio, std.algorithm, std.range, std.typecons;

struct Hailstone(size_t cacheSize = 500_000) {
  size_t n;
  __gshared static size_t[cacheSize] cache;

  bool empty() const pure nothrow { return n == 0; }
  size_t front() const pure nothrow { return n; }

  void popFront() nothrow {
    if (n >= cacheSize) {
      n = n == 1 ? 0 : (n & 1 ? n*3 + 1 : n/2);
    } else if (cache[n]) {
      n = cache[n];
    } else {
      immutable n2 = n == 1 ? 0 : (n & 1 ? n*3 + 1 : n/2);
      n = cache[n] = n2;
    }
  }
}

void main() {
  enum M = 27;
  const h = M.Hailstone!().array;
  writeln("hailstone(", M, ")= ", h[0 .. 4], " ... " , h[$ - 4 .. $]);
  writeln("Length hailstone(", M, ")= ", h.length);

  enum N = 100_000;
  immutable p = iota(1, N)
                .map!(i => tuple(i.Hailstone!().walkLength, i))
                .reduce!max;
  writeln("Longest sequence in [1,", N, "]= ",p[1]," with len ",p[0]);
}
