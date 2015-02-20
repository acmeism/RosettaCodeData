void main() {
    import std.stdio, std.algorithm, std.range, std.numeric,
           std.conv, std.typecons, std.typetuple;

    auto list = iota(1, 11);
    alias ops = TypeTuple!(q{a + b}, q{a * b}, min, max, gcd);

    foreach (op; ops)
        writeln(op.stringof, ": ", list.reduce!op);

    // std.algorithm.reduce supports multiple functions in parallel:
    reduce!(ops[0], ops[3], text)(tuple(0, 0.0, ""), list).writeln;
}
