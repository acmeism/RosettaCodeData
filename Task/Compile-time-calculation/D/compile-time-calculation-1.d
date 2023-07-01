long fact(in long x) pure nothrow @nogc {
    long result = 1;
    foreach (immutable i; 2 .. x + 1)
        result *= i;
    return result;
}

void main() {
    // enum means "compile-time constant", it forces CTFE.
    enum fact10 = fact(10);

    import core.stdc.stdio;

    printf("%ld\n", fact10);
}
