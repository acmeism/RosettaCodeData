public static long fact(final int n) {
    if (n < 0) {
        System.err.println("No negative numbers");
        return 0;
    }
    long ans = 1;
    for (int i = 1; i <= n; i++) {
        ans *= i;
    }
    return ans;
}
