uint factorial(in uint n) pure nothrow
in {
    assert(n <= 12);
} body {
    static uint inner(uint n, uint acc) pure nothrow {
        if (n < 1)
            return acc;
        else
            return inner(n - 1, acc * n);
    }
    return inner(n, 1);
}

// Computed and printed at compile-time.
pragma(msg, 12.factorial);

void main() {
    import std.stdio;

    // Computed and printed at run-time.
    12.factorial.writeln;
}
