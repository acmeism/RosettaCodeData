void main() @safe /*@nogc*/ {
    import std.stdio, std.algorithm, std.range, std.typecons, std.array;

    immutable properDivs = (in uint n) pure nothrow @safe /*@nogc*/ =>
        iota(1, (n + 1) / 2 + 1).filter!(x => n % x == 0);

    enum rangeMax = 20_000;
    auto n2d = iota(1, rangeMax + 1).map!(n => properDivs(n).sum);

    foreach (immutable n, immutable divSum; n2d.enumerate(1))
        if (n < divSum && divSum <= rangeMax && n2d[divSum - 1] == n)
            writefln("Amicable pair: %d and %d with proper divisors:\n    %s\n    %s",
                     n, divSum, properDivs(n), properDivs(divSum));
}
