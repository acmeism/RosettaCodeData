import std.typecons;

alias Tuple!(int,"a", int,"b") Pair;

FP calc(FP, F)(in F fun, in int n) pure nothrow {
    FP temp = 0;

    foreach_reverse (ni; 1 .. n+1) {
        immutable p = fun(ni);
        temp = cast(FP)p.b / (cast(FP)p.a + temp);
    }
    return cast(FP)fun(0).a + temp;
}

// int[2] fsqrt2(in int n) pure nothrow {
Pair fsqrt2(in int n) pure nothrow {
    return Pair(n > 0 ? 2 : 1,
                1);
}

Pair fnapier(in int n) pure nothrow {
    return Pair(n > 0 ? n : 2,
                n > 1 ? (n - 1) : 1);
}

Pair fpi(in int n) pure nothrow {
    return Pair(n > 0 ? 6 : 3,
                (2 * n - 1) ^^ 2);
}

void main() {
    import std.stdio;

    writefln("%.19f", calc!real(&fsqrt2, 200));
    writefln("%.19f", calc!real(&fnapier, 200));
    writefln("%.19f", calc!real(&fpi, 200));
}
