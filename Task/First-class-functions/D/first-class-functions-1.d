import std.stdio, std.math, std.typetuple, std.functional;

enum sin  = (in real x) => std.math.sin(x),
     asin = (in real x) => std.math.asin(x),
     cos  = (in real x) => std.math.cos(x),
     acos = (in real x) => std.math.acos(x),
     cube = (in real x) => x ^^ 3,
     cbrt = (in real x) => std.math.cbrt(x);

void main() {
    alias TypeTuple!(sin,  cos,  cube) dir;
    alias TypeTuple!(asin, acos, cbrt) inv;
    foreach (i, f; dir) {
        writefln("%6.3f", compose!(f, inv[i])(0.5));
    }
}
