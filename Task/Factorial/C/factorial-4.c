int factorialSafe(int n) {
    return n<0 ? -1 : n == 0 ? 1 : n * factorialSafe(n - 1);
}
