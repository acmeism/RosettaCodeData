long long unsigned fib(unsigned n) {
    return n < 2 ? n : fib(n - 1) + fib(n - 2);
}
