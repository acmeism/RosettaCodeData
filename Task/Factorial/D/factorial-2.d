uint factorial(in uint n) pure nothrow
in {
    assert(n <= 12);
} body {
    if (n == 0)
        return 1;
    else
        return n * factorial(n - 1);
}

// Computed and printed at compile-time.
pragma(msg, 12.factorial);

void main() {
    import std.stdio;

    // Computed and printed at run-time.
    12.factorial.writeln;
}
