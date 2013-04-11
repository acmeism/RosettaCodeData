import std.stdio, std.algorithm, std.range;

bool isPerfect(in int n) /*pure nothrow*/ {
    return n == iota(1, n - 1).reduce!((s, i) => n % i ? s : s + i)();
}

void main() {
    iota(3, 10_000).filter!isPerfect().writeln();
}
