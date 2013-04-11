import std.stdio, std.math, std.algorithm;

bool nearZero(T)(in T a, in T b = T.epsilon * 4) pure nothrow {
    return abs(a) <= b;
}

T[] findRoot(T)(immutable T function(in T) pure nothrow f,
                in T start, in T end, in T step=cast(T)0.001L,
                T tolerance = cast(T)1e-4L) {
    if (nearZero(step))
        writefln("WARNING: step size may be too small.");
    immutable fi = f;

    /// Search root by simple bisection.
    T searchRoot(T a, T b) pure nothrow {
        T root;
        int limit = 49;
        T gap = b - a;

        while (!nearZero(gap) && limit--) {
            if (nearZero(fi(a))) return a;
            if (nearZero(fi(b))) return b;
            root = (b + a) / 2.0L;
            if (nearZero(fi(root))) return root;
            if (fi(a) * fi(root) < 0)
                b = root;
            else
                a = root;
            gap = b - a;
        }

        return root;
    }

    immutable dir = cast(T)(end > start ? 1.0 : -1.0);
    immutable step2 = (end > start) ? abs(step) : -abs(step);
    T[T] result;
    for (T x = start; (x * dir) <= (end * dir); x += step2)
        if (f(x) * f(x + step2) <= 0) {
            immutable T r = searchRoot(x, x + step2);
            result[r] = f(r);
        }

    return result.keys.sort().release();
}

void report(T)(in T[] r, immutable T function(in T) pure f,
               in T tolerance = cast(T)1e-4L) {
    if (r.length) {
        writefln("Root found (tolerance = %1.4g):", tolerance);
        foreach (x; r) {
            immutable T y = f(x);
            if (nearZero(y))
                writefln("... EXACTLY at %+1.20f, f(x) = %+1.4g",x,y);
            else if (nearZero(y, tolerance))
                writefln(".... MAY-BE at %+1.20f, f(x) = %+1.4g",x,y);
            else
                writefln("Verify needed, f(%1.4g) = " ~
                         "%1.4g > tolerance in magnitude", x, y);
        }
    } else
        writefln("No root found.");
}

real f(in real x) pure nothrow {
    return x ^^ 3 - (3 * x ^^ 2) + 2 * x;
}

void main() {
    findRoot(&f, -1.0L, 3.0L, 0.001L).report(&f);
}
