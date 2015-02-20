import std.stdio, std.range, std.traits;

/// Approximates y(t) in y'(t)=f(t,y) with y(a)=y0 and t=a..b and the step size h.
void euler(F)(in F f, in double y0, in double a, in double b, in double h) @safe
if (isCallable!F && __traits(compiles, { real r = f(0.0, 0.0); })) {
    double y = y0;
    foreach (immutable t; iota(a, b, h)) {
        writefln("%.3f  %.3f", t, y);
        y += h * f(t, y);
    }
    "done".writeln;
}

void main() {
    /// Example: Newton's cooling law.
    enum newtonCoolingLaw = (in double time, in double t)
        pure nothrow @safe @nogc => -0.07 * (t - 20);

    euler(newtonCoolingLaw, 100, 0, 100,  2);
    euler(newtonCoolingLaw, 100, 0, 100,  5);
    euler(newtonCoolingLaw, 100, 0, 100, 10);
}
