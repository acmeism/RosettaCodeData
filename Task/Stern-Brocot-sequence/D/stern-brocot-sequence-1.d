import std.stdio, std.numeric, std.range, std.algorithm;

/// Generates members of the stern-brocot series, in order,
/// returning them when the predicate becomes false.
uint[] sternBrocot(bool delegate(in uint[]) pure nothrow @safe @nogc pred=seq => seq.length < 20)
pure nothrow @safe {
    typeof(return) sb = [1, 1];
    size_t i = 0;
    while (pred(sb)) {
        sb ~= [sb[i .. i + 2].sum, sb[i + 1]];
        i++;
    }
    return sb;
}

void main() {
    enum nFirst = 15;
    writefln("The first %d values:\n%s\n", nFirst,
             sternBrocot(seq => seq.length < nFirst).take(nFirst));

    foreach (immutable nOccur; iota(1, 10 + 1).chain(100.only))
        writefln("1-based index of the first occurrence of %3d in the series: %d",
                 nOccur, sternBrocot(seq => nOccur != seq[$ - 2]).length - 1);

    enum nGcd = 1_000;
    auto s = sternBrocot(seq => seq.length < nGcd).take(nGcd);
    assert(zip(s, s.dropOne).all!(ss => ss[].gcd == 1),
           "A fraction from adjacent terms is reducible.");
}
