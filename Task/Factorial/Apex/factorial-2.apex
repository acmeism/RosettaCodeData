public static long factRec(final Integer n) {
    if (n < 0){
        System.debug('No negative numbers');
        return 0;
    }
    return (n < 2) ? 1 : n * fact(n - 1);
}
