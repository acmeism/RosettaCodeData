void main() /*@safe*/ {
    import std.stdio, std.algorithm, std.range;

    static immutable properDivs = (in uint n) pure nothrow @safe /*@nogc*/ =>
        iota(1, (n + 1) / 2 + 1).filter!(x => n % x == 0 && n != x);

    enum Class { deficient, perfect, abundant }

    static Class classify(in uint n) pure nothrow @safe /*@nogc*/ {
        immutable p = properDivs(n).sum;
        with (Class)
            return (p < n) ? deficient : ((p == n) ? perfect : abundant);
    }

    enum rangeMax = 20_000;
    //iota(1, 1 + rangeMax).map!classify.hashGroup.writeln;
    iota(1, 1 + rangeMax).map!classify.array.sort().group.writeln;
}
