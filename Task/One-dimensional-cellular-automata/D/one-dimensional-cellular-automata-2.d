import std.stdio, std.algorithm, std.array, std.range;

void main() {
    auto A = "_###_##_#_#_#_#__#__".map!q{a == '#'}.array;
    auto B = A.dup;

    do {
        A.map!q{ "_#"[a] }.writeln;
        zip(A, A.cycle.drop(1), A.cycle.drop(A.length - 1))
        //.map!(t => [t[]].sum == 2).copy(B);
        .map!q{ a[0] + a[1] + a[2] == 2 }.copy(B);
        A.swap(B);
    } while (A != B);
}
