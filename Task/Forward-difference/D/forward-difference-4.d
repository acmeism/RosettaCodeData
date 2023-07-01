void main() {
  import std.stdio, std.range;

  auto D = [90.5, 47, 58, 29, 22, 32, 55, 5, 55, 73.5];
  writefln("%(%s\n%)",
    recurrence!q{ (a[n - 1][0 .. $ - 1] =
                   a[n - 1][1 .. $] -
                   a[n - 1][0 .. $ - 1])[0 .. $] }(D)
    .take(D.length));
}
