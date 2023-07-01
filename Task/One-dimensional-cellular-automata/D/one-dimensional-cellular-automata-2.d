void main() {
    import std.stdio, std.algorithm, std.range;

    auto A = "_###_##_#_#_#_#__#__".map!q{a == '#'}.array;
    auto B = A.dup;

    do {
        A.map!q{ "_#"[a] }.writeln;
        A.zip(A.cycle.drop(1), A.cycle.drop(A.length - 1))
        .map!(t => [t[]].sum == 2).copy(B);
        A.swap(B);
    } while (A != B);
}
