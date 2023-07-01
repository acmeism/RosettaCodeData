import std.stdio, std.algorithm, std.range, std.typecons, std.concurrency;

auto hailstone(size_t n) {
    return new Generator!size_t({
        yield(n);
        while (n > 1) {
            n = (n & 1) ? (3 * n + 1) : (n / 2);
            yield(n);
        }
    });
}

void main() {
  enum M = 27;
  const h = M.hailstone.array;
  writeln("hailstone(", M, ")= ", h[0 .. 4], " ... " , h[$ - 4 .. $]);
  writeln("Length hailstone(", M, ")= ", h.length);

  enum N = 100_000;
  immutable p = iota(1, N)
                .map!(i => tuple(i.hailstone.walkLength, i))
                .reduce!max;
  writeln("Longest sequence in [1,", N, "]= ",p[1]," with len ",p[0]);
}
