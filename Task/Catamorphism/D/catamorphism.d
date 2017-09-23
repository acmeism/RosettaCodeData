void main() {
    import std.stdio, std.algorithm, std.range, std.meta, std.numeric,
           std.conv, std.typecons;

    auto list = iota(1, 11);
    alias ops = AliasSeq!(q{a + b}, q{a * b}, min, max, gcd);

    foreach (op; ops)
        writeln(op.stringof, ": ", list.reduce!op);

    // std.algorithm.reduce supports multiple functions in parallel:
    reduce!(ops[0], ops[3], text)(tuple(0, 0.0, ""), list).writeln;
}
