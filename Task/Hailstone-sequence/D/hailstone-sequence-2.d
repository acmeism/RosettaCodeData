import std.stdio, std.algorithm, std.range, std.typecons;

struct Hail {
  int n;
  bool empty() { return n == 0; }
  int front() { return n; }
  void popFront() { n = n == 1 ? 0 : (n & 1 ? n*3 + 1 : n/2); }
}

void main() {
  enum M = 27;
  auto h = array(Hail(M));
  writeln("hailstone(", M, ")= ", h[0 .. 4], " ... " , h[$-4 .. $]);
  writeln("length hailstone(", M, ")= ", h.length);

  enum N = 100_000;
  auto s = map!(i => tuple(walkLength(Hail(i)), i))(iota(1, N));
  auto p = reduce!max(s);
  writeln("Longest sequence in [1,", N, "]= ",p[1]," with len ",p[0]);
}
