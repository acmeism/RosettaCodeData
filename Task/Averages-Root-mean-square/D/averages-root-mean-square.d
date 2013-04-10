import std.stdio, std.math, std.algorithm, std.range;

real rms(R)(R d) {
  return sqrt(reduce!((a, b) => a + b * b)(d) / cast(real)d.length);
}

void main() {
  writefln("%.19f", rms(iota(1, 11)));
}
