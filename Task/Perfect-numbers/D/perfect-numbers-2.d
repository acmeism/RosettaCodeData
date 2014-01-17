import std.stdio, std.algorithm, std.range;

bool isPerfect(in uint n) pure nothrow
in {
    assert(n > 0);
} body {
    return n == reduce!((s, i) => n % i ? s : s + i)(0, iota(1, n-1));
}

void main() {
    iota(1, 10_000).filter!isPerfect.writeln;
}
