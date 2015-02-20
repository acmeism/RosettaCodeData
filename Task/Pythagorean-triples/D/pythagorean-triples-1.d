void main() @safe {
    import std.stdio, std.range, std.algorithm, std.typecons, std.numeric;

    enum triples = (in uint n) pure nothrow @safe /*@nogc*/ =>
        iota(1, n + 1)
        .map!(z => iota(1, z + 1)
                   .map!(x => iota(x, z + 1).map!(y => tuple(x, y, z))))
        .joiner.joiner
        .filter!(t => t[0] ^^ 2 + t[1] ^^ 2 == t[2] ^^ 2 && t[].only.sum <= n)
        .map!(t => tuple(t[0 .. 2].gcd == 1, t[]));

    auto xs = triples(100);
    writeln("Up to 100 there are ", xs.count, " triples, ",
            xs.filter!q{ a[0] }.count, " are primitive.");
}
