import std.stdio;

ulong[2] tri(ulong lim, ulong a=3, ulong b=4, ulong c=5) {
  immutable l = a + b + c;
  if (l > lim)
    return [0, 0];
  typeof(return) r = [1, lim / l];
  r[] += tri(lim,  a - 2*b + 2*c,  2*a - b + 2*c,  2*a - 2*b + 3*c)[];
  r[] += tri(lim,  a + 2*b + 2*c,  2*a + b + 2*c,  2*a + 2*b + 3*c)[];
  r[] += tri(lim, -a + 2*b + 2*c, -2*a + b + 2*c, -2*a + 2*b + 3*c)[];
  return r;
}

void main() {
  foreach (immutable p; 1 .. 8)
    writeln(10 ^^ p, " ", tri(10 ^^ p));
}
