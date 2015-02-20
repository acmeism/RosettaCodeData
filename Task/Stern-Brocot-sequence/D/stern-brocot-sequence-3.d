void main() {
    import std.stdio, std.numeric, std.range, std.algorithm, std.bigint, std.conv;

    /// Stern-Brocot sequence, 0-th member is 0.
    T sternBrocot(T)(T n) pure nothrow /*safe*/ {
        T a = 1, b = 0;
        while (n) {
            if (n & 1) b += a;
            else       a += b;
            n >>= 1;
        }
        return b;
    }
    alias sb = sternBrocot!uint;

    enum nFirst = 15;
    writefln("The first %d values:\n%s\n", nFirst, iota(1, nFirst + 1).map!sb);

    foreach (immutable nOccur; iota(1, 10 + 1).chain(100.only))
        writefln("1-based index of the first occurrence of %3d in the series: %d",
                 nOccur, sequence!q{n}.until!(n => sb(n) == nOccur).walkLength);

    auto s = iota(1, 1_001).map!sb;
    assert(s.zip(s.dropOne).all!(ss => ss[].gcd == 1),
           "A fraction from adjacent terms is reducible.");

    sternBrocot(10.BigInt ^^ 20_000).text.length.writeln;
}
