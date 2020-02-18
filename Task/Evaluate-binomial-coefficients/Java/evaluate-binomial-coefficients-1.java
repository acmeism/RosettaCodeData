public class Binomial {

    // precise, but may overflow and then produce completely incorrect results
    private static long binomialInt(int n, int k) {
        if (k > n - k)
            k = n - k;

        long binom = 1;
        for (int i = 1; i <= k; i++)
            binom = binom * (n + 1 - i) / i;
        return binom;
    }

    // same as above, but with overflow check
    private static Object binomialIntReliable(int n, int k) {
        if (k > n - k)
            k = n - k;

        long binom = 1;
        for (int i = 1; i <= k; i++) {
            try {
                binom = Math.multiplyExact(binom, n + 1 - i) / i;
            } catch (ArithmeticException e) {
                return "overflow";
            }
        }
        return binom;
    }

    // using floating point arithmetic, larger numbers can be calculated,
    // but with reduced precision
    private static double binomialFloat(int n, int k) {
        if (k > n - k)
            k = n - k;

        double binom = 1.0;
        for (int i = 1; i <= k; i++)
            binom = binom * (n + 1 - i) / i;
        return binom;
    }

    // slow, hard to read, but precise
    private static BigInteger binomialBigInt(int n, int k) {
        if (k > n - k)
            k = n - k;

        BigInteger binom = BigInteger.ONE;
        for (int i = 1; i <= k; i++) {
            binom = binom.multiply(BigInteger.valueOf(n + 1 - i));
            binom = binom.divide(BigInteger.valueOf(i));
        }
        return binom;
    }

    private static void demo(int n, int k) {
        List<Object> data = Arrays.asList(
                n,
                k,
                binomialInt(n, k),
                binomialIntReliable(n, k),
                binomialFloat(n, k),
                binomialBigInt(n, k));

        System.out.println(data.stream().map(Object::toString).collect(Collectors.joining("\t")));
    }

    public static void main(String[] args) {
        demo(5, 3);
        demo(1000, 300);
    }
}
