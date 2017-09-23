public static long fib(int n) {
    if (n < 0)
        throw new IllegalArgumentException("n can not be a negative number");

    return new Object() {
        private long fibInner(int n) {
            return (n < 2) ? n : (fibInner(n - 1) + fibInner(n - 2));
        }
    }.fibInner(n);
}
