uint factorial(in uint n) pure nothrow @nogc
in {
    assert(n <= 12);
} body {
    uint result = 1;
    foreach (immutable i; 1 .. n + 1)
        result *= i;
    return result;
}

// Computed and printed at compile-time.
pragma(msg, 12.factorial);

void main() {
    import std.stdio;

    // Computed and printed at run-time.
    12.factorial.writeln;
}
