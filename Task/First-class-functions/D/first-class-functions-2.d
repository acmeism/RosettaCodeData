void main() {
    import std.stdio, std.math, std.range;

    static T delegate(S) compose(T, U, S)(in T function(in U) f,
                                          in U function(in S) g) {
        return s => f(g(s));
    }

    immutable sin  = (in real x) pure nothrow => x.sin,
              asin = (in real x) pure nothrow => x.asin,
              cos  = (in real x) pure nothrow => x.cos,
              acos = (in real x) pure nothrow => x.acos,
              cube = (in real x) pure nothrow => x ^^ 3,
              cbrt = (in real x) /*pure*/ nothrow => x.cbrt;

    foreach (f, g; [sin, cos, cube].zip([asin, acos, cbrt]))
        writefln("%6.3f", compose(f, g)(0.5));
}
