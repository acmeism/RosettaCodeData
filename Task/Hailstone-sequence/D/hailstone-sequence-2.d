import std.stdio, std.algorithm, std.typecons, std.range;

auto hailstone(uint m) pure nothrow @nogc {
    return m
           .recurrence!q{ a[n - 1] & 1 ? a[n - 1] * 3 + 1 : a[n - 1]/2}
           .until!q{ a == 1 }(OpenRight.no);
}

void main() {
  enum M = 27;
  immutable h = M.hailstone.array;
  writeln("hailstone(", M, ")= ", h[0 .. 4], " ... " , h[$ - 4 .. $]);
  writeln("Length hailstone(", M, ")= ", h.length);

  enum N = 100_000;
  immutable p = iota(1, N)
                .map!(i => tuple(i.hailstone.walkLength, i))
                .reduce!max;
  writeln("Longest sequence in [1,", N, "]= ",p[1]," with len ",p[0]);
}
