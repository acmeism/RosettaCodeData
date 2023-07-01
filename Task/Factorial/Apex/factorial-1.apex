public static long fact(final Integer n) {
    if (n < 0) {
        System.debug('No negative numbers');
        return 0;
    }
    long ans = 1;
    for (Integer i = 1; i <= n; i++) {
        ans *= i;
    }
    return ans;
}
