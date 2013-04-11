import std.stdio, std.range, std.array, std.algorithm, std.math;

struct Domain {
    real b, e, s;

    auto range() const /*pure nothrow*/ {
        // return iota(b, e + s, s);
        return iota(cast()b, e + s, s);
    }
}

real eval0(alias RY, alias X, alias Y)(in real x) pure nothrow {
    real a = 0.0L;
    foreach_reverse (i; 2 .. X.length - 3)
        a = (x - X[i]) / (RY[i] - RY[i-2] + a);
    return Y[1] + (x - X[1]) / (RY[1] + a);
}

struct Thiele {
    immutable real[] Y, X, rhoY, rhoX;

    this(real[] y, real[] x) /*pure nothrow*/
    in {
        assert(x.length > 2, "at leat 3 values");
        assert(x.length == y.length, "input arrays not of same size");
    } body {
        this.Y = y.idup;
        this.X = x.idup;
        rhoY = rhoN(Y, X);
        rhoX = rhoN(X, Y);
    }

    this(in real delegate(real) f,
         Domain d=Domain(0.0L, 1.55L, 0.05L)) {
        auto xrng = d.range().array();
        this(array(map!f(xrng)), xrng);
    }

    auto rhoN(immutable(real)[] y, immutable(real)[] x) /*pure*/ {
        int N = x.length;
        real[][] p = new real[][](N, N);
        p[0][] = y[]; // array/vector operation follow
        p[1][0..$-1] = (x[0 .. $-1] - x[1 .. $]) /
                       (p[0][0 .. $-1] - p[0][1 .. $]);
        foreach (int j; 2 .. N - 1) {
            immutable M = N - j - 1;
            p[j][0..M] = p[j-2][1..M+1] + (x[0..M] - x[j..M+j]) /
                         (p[j-1][0 .. M] - p[j-1][1 .. M+1]);
        }
        return p.map!q{a[1]}().array().idup;
    }

    alias eval0!(rhoY, X, Y) eval;
    alias eval0!(rhoX, Y, X) inverse;
}

void main() {
    // can't pass sin,cos,tan directly
    auto tsin = Thiele((real x) => sin(x));
    auto tcos = Thiele((real x) => cos(x));
    auto ttan = Thiele((real x) => tan(x));

    writefln(" %d interpolating points\n", tsin.X.length);
    writefln("std.math.sin(0.5): %20.18f", sin(0.5L));
    writefln("  Thiele sin(0.5): %20.18f\n", tsin.eval(0.5L));

    writefln("*%20.19f library constant", PI);
    writefln(" %20.19f 6 * inv_sin(0.5)", tsin.inverse(0.5L) * 6.0L);
    writefln(" %20.19f 3 * inv_cos(0.5)", tcos.inverse(0.5L) * 3.0L);
    writefln(" %20.19f 4 * inv_tan(1.0)", ttan.inverse(1.0L) * 4.0L);
}
