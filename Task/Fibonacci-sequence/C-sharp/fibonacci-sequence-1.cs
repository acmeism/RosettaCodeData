public static ulong Fib(uint n) {
    return (n < 2)? n : Fib(n - 1) + Fib(n - 2);
}
