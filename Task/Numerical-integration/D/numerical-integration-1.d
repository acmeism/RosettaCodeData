import std.stdio, std.typecons, std.typetuple;

template integrate(alias method) {
    double integrate(F, Float)(in F f, in Float a,
                               in Float b, in int steps) {
        double s = 0.0;
        immutable double h = (b - a) / steps;
        foreach (i; 0 .. steps)
            s += method(f, a + h * i, h);
        return h * s;
    }
}

double rectangularLeft(F, Float)(in F f, in Float x, in Float h)
pure nothrow {
    return f(x);
}

double rectangularMiddle(F, Float)(in F f, in Float x, in Float h)
pure nothrow {
    return f(x + h / 2);
}

double rectangularRight(F, Float)(in F f, in Float x, in Float h)
pure nothrow {
    return f(x + h);
}

double trapezium(F, Float)(in F f, in Float x, in Float h)
pure nothrow {
    return (f(x) + f(x + h)) / 2;
}

double simpson(F, Float)(in F f, in Float x, in Float h)
pure nothrow {
    return (f(x) + 4 * f(x + h / 2) + f(x + h)) / 6;
}

void main() {
    immutable args = [
        tuple((double x) => x ^^ 3, 0.0, 1.0, 10),
        tuple((double x) => 1 / x, 1.0, 100.0, 1000),
        tuple((double x) => x, 0.0, 5_000.0, 5_000_000),
        tuple((double x) => x, 0.0, 6_000.0, 6_000_000)];

    alias TypeTuple!(integrate!rectangularLeft,
                     integrate!rectangularMiddle,
                     integrate!rectangularRight,
                     integrate!trapezium,
                     integrate!simpson) ints;

    alias TypeTuple!("rectangular left:   ",
                     "rectangular middle: ",
                     "rectangular right:  ",
                     "trapezium:          ",
                     "simpson:            ") names;

    foreach (a; args) {
        foreach (i, n; names)
            writefln("%s %f", n, ints[i](a.tupleof));
        writeln();
    }
}
