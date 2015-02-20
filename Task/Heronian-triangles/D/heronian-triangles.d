import std.stdio, std.math, std.range, std.algorithm, std.numeric, std.traits, std.typecons;

double hero(in uint a, in uint b, in uint c) pure nothrow @safe @nogc {
    immutable s = (a + b + c) / 2.0;
    immutable a2 = s * (s - a) * (s - b) * (s - c);
    return (a2 > 0) ? a2.sqrt : 0.0;
}

bool isHeronian(in uint a, in uint b, in uint c) pure nothrow @safe @nogc {
    immutable h = hero(a, b, c);
    return h > 0 && h.floor == h.ceil;
}

T gcd3(T)(in T x, in T y, in T z) pure nothrow @safe @nogc {
    return gcd(gcd(x, y), z);
}

void main() /*@safe*/ {
    enum uint maxSide = 200;

    // Sort by increasing area, perimeter, then sides.
    //auto h = cartesianProduct!3(iota(1, maxSide + 1))
    auto r = iota(1, maxSide + 1);
    const h = cartesianProduct(r, r, r)
              //.filter!({a, b, c} => ...
              .filter!(t => t[0] <= t[1] && t[1] <= t[2] &&
                            t[0] + t[1] > t[2] &&
                            t[].gcd3 == 1 && t[].isHeronian)
              .array
              .schwartzSort!(t => tuple(t[].hero, t[].only.sum, t.reverse))
              .release;

    static void showTriangles(R)(R ts) @safe {
        "Area Perimeter Sides".writeln;
        foreach (immutable t; ts)
            writefln("%3s %8d %3dx%dx%d", t[].hero, t[].only.sum, t[]);
    }

    writefln("Primitive Heronian triangles with sides up to %d: %d", maxSide, h.length);
    "\nFirst ten when ordered by increasing area, then perimeter,then maximum sides:".writeln;
    showTriangles(h.take(10));

    "\nAll with area 210 subject to the previous ordering:".writeln;
    showTriangles(h.filter!(t => t[].hero == 210));
}
