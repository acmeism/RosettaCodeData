import std.stdio, std.algorithm, std.range;

/// Iterative.
int factorial(in int n) {
    int result = 1;
    foreach (i; 1 .. n + 1)
        result *= i;
    return result;
}

/// Recursive.
int recFactorial(in int n) {
    if (n == 0)
        return 1;
    else
        return n * recFactorial(n - 1);
}

/// Functional-style.
int fact(in int n) {
    return iota(1, n + 1).reduce!q{a * b};
}

/// Tail recursive (at run-time, with DMD).
int tfactorial(in int n) {
    static int facAux(int n, int acc) {
        if (n < 1)
            return acc;
        else
            return facAux(n - 1, acc * n);
    }
    return facAux(n, 1);
}

// Computed and printed at compile-time.
pragma(msg, 15.factorial);
pragma(msg, 15.recFactorial);
pragma(msg, 15.fact);
pragma(msg, 15.tfactorial);

void main() {
    // Computed and printed at run-time.
    15.factorial.writeln;
    15.recFactorial.writeln;
    15.fact.writeln;
    15.tfactorial.writeln;
}
