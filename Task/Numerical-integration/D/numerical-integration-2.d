import std.stdio, std.typecons, std.typetuple;

template integrate(alias method) {
    template integrate(alias f) {
        double integrate(Float)(in Float a, in Float b,
                                in int steps) pure nothrow {
            Float s = 0.0;
            immutable Float h = (b - a) / steps;
            foreach (i; 0 .. steps)
                s += method!(f, Float)(a + h * i, h);
            return h * s;
        }
    }
}

double rectangularLeft(alias f, Float)(in Float x, in Float h)
pure nothrow {
    return f(x);
}

double rectangularMiddle(alias f, Float)(in Float x, in Float h)
pure nothrow {
    return f(x + h / 2);
}

double rectangularRight(alias f, Float)(in Float x, in Float h)
pure nothrow {
    return f(x + h);
}

double trapezium(alias f, Float)(in Float x, in Float h)
pure nothrow {
    return (f(x) + f(x + h)) / 2;
}

double simpson(alias f, Float)(in Float x, in Float h)
pure nothrow {
    return (f(x) + 4 * f(x + h / 2) + f(x + h)) / 6;
}

void main() {
    static double f1(in double x) pure nothrow { return x ^^ 3; }
    static double f2(in double x) pure nothrow { return 1 / x; }
    static double f3(in double x) pure nothrow { return x; }
    alias TypeTuple!(f1, f2, f3, f3) funcs;

    alias TypeTuple!("rectangular left:   ",
                     "rectangular middle: ",
                     "rectangular right:  ",
                     "trapezium:          ",
                     "simpson:            ") names;

    alias TypeTuple!(integrate!rectangularLeft,
                     integrate!rectangularMiddle,
                     integrate!rectangularRight,
                     integrate!trapezium,
                     integrate!simpson) ints;

    immutable args = [tuple(0.0,     1.0,        10),
                      tuple(1.0,   100.0,     1_000),
                      tuple(0.0, 5_000.0, 5_000_000),
                      tuple(0.0, 6_000.0, 6_000_000)];

    foreach (i, f; funcs) {
        foreach (j, n; names) {
            alias ints[j] integ;
            writefln("%s %f", n, integ!f(args[i].tupleof));
        }
        writeln();
    }
}
