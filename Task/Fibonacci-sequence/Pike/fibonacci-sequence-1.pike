int
fibIter(int n) {
    int fibPrev, fib, i;
    if (n < 2) {
        return 1;
    }
    fibPrev = 0;
    fib = 1;
    for (i = 1; i < n; i++) {
        int oldFib = fib;
        fib += fibPrev;
        fibPrev = oldFib;
    }
    return fib;
}
