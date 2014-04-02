import std.stdio, std.algorithm, std.range;

bool isPerfectNumber1(in uint n) pure nothrow
in {
    assert(n > 0);
} body {
    return n == iota(1, n - 1).filter!(i => n % i == 0).sum;
}

void main() {
    iota(1, 10_000).filter!isPerfectNumber1.writeln;
}
