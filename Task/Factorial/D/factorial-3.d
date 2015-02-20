import std.stdio, std.algorithm, std.range;

uint factorial(in uint n) pure nothrow @nogc
in {
    assert(n <= 12);
} body {
    return reduce!q{a * b}(1u, iota(1, n + 1));
}

// Computed and printed at compile-time.
pragma(msg, 12.factorial);

void main() {
    // Computed and printed at run-time.
    12.factorial.writeln;
}
