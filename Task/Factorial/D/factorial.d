import std.stdio, std.algorithm, std.metastrings, std.range;

// iterative
long factorial(long n) {
    long result = 1;
    foreach (i; 1 .. n + 1)
        result *= i;
    return result;
}

// recursive
long recFactorial(long n) {
    if (n == 0)
        return 1;
    else
        return n * recFactorial(n - 1);
}

// functional-style
long fact(long n) {
    return iota(1, n + 1).reduce!q{a * b}();
}

// tail recursive (at run-time, with DMD)
long tfactorial(long n) {
    static long facAux(long n, long acc) {
        if (n < 1)
            return acc;
        else
            return facAux(n - 1, acc * n);
    }
    return facAux(n, 1);
}

// computed and printed at compile-time
pragma(msg, toStringNow!(factorial(15)));
pragma(msg, toStringNow!(recFactorial(15)));
pragma(msg, toStringNow!(fact(15)));
pragma(msg, toStringNow!(tfactorial(15)));

void main() {
    // computed and printed at run-time
    writeln(factorial(15));
    writeln(recFactorial(15));
    writeln(fact(15));
    writeln(tfactorial(15));
}
