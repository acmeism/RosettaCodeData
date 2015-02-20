import std.stdio, std.random, std.math, std.typecons, std.complex,
       std.traits;

Nullable!(Tuple!(size_t, size_t))
bfClosestPair2(T)(in Complex!T[] points) pure nothrow @nogc {
    auto minD = Unqual!(typeof(points[0].re)).infinity;
    if (points.length < 2)
        return typeof(return)();

    size_t minI, minJ;
    foreach (immutable i; 0 .. points.length - 1)
        foreach (immutable j; i + 1 .. points.length) {
            auto dist = (points[i].re - points[j].re) ^^ 2;
            if (dist < minD) {
                dist += (points[i].im - points[j].im) ^^ 2;
                if (dist < minD) {
                    minD = dist;
                    minI = i;
                    minJ = j;
                }
            }
        }

    return typeof(return)(tuple(minI, minJ));
}

void main() {
    alias C = Complex!double;
    auto rng = 31415.Xorshift;
    C[10_000] pts;
    foreach (ref p; pts)
        p = C(uniform(0.0, 1000.0, rng), uniform(0.0, 1000.0, rng));

    immutable ij = pts.bfClosestPair2;
    if (ij.isNull)
        return;
    writefln("Closest pair: Distance: %f  p1, p2: %f, %f",
             abs(pts[ij[0]] - pts[ij[1]]), pts[ij[0]], pts[ij[1]]);
}
