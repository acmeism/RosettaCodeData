public static ulong Fib(uint n) {
    return Fib(0, 1, n);
}

private static ulong Fib(ulong a, ulong b, uint n) {
    return (n < 1)? a :(n == 1)?  b : Fib(b, a + b, n - 1);
}
