T delegate(S) compose(T, U, S)(in T function(in U) f,
                               in U function(in S) g) {
    return s => f(g(s));
}

void main() {
    import std.stdio, std.math, std.range;

    immutable sin  = (in real x) => sin(x),
              asin = (in real x) => asin(x),
              cos  = (in real x) => cos(x),
              acos = (in real x) => acos(x),
              cube = (in real x) => x ^^ 3,
              cbrt = (in real x) => cbrt(x);

    foreach (f, g; zip([sin, cos, cube], [asin, acos, cbrt]))
        writefln("%6.3f", compose(f, g)(0.5));
}
