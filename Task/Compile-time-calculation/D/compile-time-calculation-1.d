import core.stdc.stdio;

long fact(long x) {
    long result = 1;
    foreach (i; 2 .. x + 1)
        result *= i;
    return result;
}

void main() {
    // enum means "compile-time constant", it forces CTFE.
    enum fact10 = fact(10);

    printf("%ld\n", fact10);
}
