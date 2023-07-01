void main() /*@safe*/ {
    import std.stdio, std.algorithm, std.range, std.typecons;

    immutable properDivs = (in uint n) pure nothrow @safe /*@nogc*/ =>
        iota(1, (n + 1) / 2 + 1).filter!(x => n % x == 0 && n != x);

    iota(1, 11).map!properDivs.writeln;
    iota(1, 20_001).map!(n => tuple(properDivs(n).count, n)).reduce!max.writeln;
}
