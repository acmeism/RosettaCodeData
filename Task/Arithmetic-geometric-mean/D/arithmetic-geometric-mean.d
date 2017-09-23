import std.stdio, std.math, std.meta, std.typecons;

real agm(real a, real g, in int bitPrecision=60) pure nothrow @nogc @safe {
    do {
        //{a, g} = {(a + g) / 2.0, sqrt(a * g)};
        AliasSeq!(a, g) = tuple((a + g) / 2.0, sqrt(a * g));
    } while (feqrel(a, g) < bitPrecision);
    return a;
}

void main() @safe {
    writefln("%0.19f", agm(1, 1 / sqrt(2.0)));
}
