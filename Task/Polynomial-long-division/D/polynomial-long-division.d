import std.stdio, std.range, std.algorithm, std.typecons;

Tuple!(double[],double[]) polyDiv(in double[] inN, in double[] inD)
/*pure nothrow*/ {
    // code smell: a function that does two things
    static int trimAndDegree(T)(ref T[] poly) /*nothrow pure*/ {
        poly.length -= poly.retro().countUntil!q{a != 0}();
        return (cast(int)poly.length) - 1;
    }

    double[] N = inN.dup;
    const(double)[] D = inD;
    const dD = trimAndDegree(D);
    auto dN = trimAndDegree(N);
    double[] q, r;
    if (dD < 0)
        throw new Exception("ZeroDivisionError");
    if (dN >= dD) {
        q = repeat(0.0).take(dN).array();
        while (dN >= dD) {
            auto d = repeat(0.0).take(dN - dD).array() ~ D;
            const mult = q[dN - dD] = N[$ - 1] / d[$ - 1];
            d[] *= mult;
            N[] -= d[];
            dN = trimAndDegree(N);
        }
    } else {
        q = [0.0];
    }
    r = N;
    return tuple(q, r);
}

void main() {
    immutable N = [-42.0, 0.0, -12.0, 1.0];
    immutable D = [-3.0, 1.0, 0.0, 0.0];
    writefln("%s / %s = %s  remainder %s", N, D, polyDiv(N,D).tupleof);
}
