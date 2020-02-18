import java.math.BigInteger;

public class SumMultiples {

    public static void main(String[] args) {
        BigInteger m1 = BigInteger.valueOf(3);
        BigInteger m2 = BigInteger.valueOf(5);
        for ( int i = 1 ; i <= 25 ; i++ ) {
            BigInteger limit = BigInteger.valueOf(10).pow(i);
            System.out.printf("Limit = 10^%d, answer = %s%n", i, sumMultiples(limit.subtract(BigInteger.ONE), m1, m2));
        }
    }

    //  Use Inclusion - Exclusion
    private static BigInteger sumMultiples(BigInteger max, BigInteger n1, BigInteger n2) {
        return sumMultiple(max, n1).add(sumMultiple(max, n2)).subtract(sumMultiple(max, n1.multiply(n2)));
    }

    private static BigInteger sumMultiple(BigInteger max, BigInteger m) {
        BigInteger maxDivM = max.divide(m);
        return m.multiply(maxDivM.multiply(maxDivM.add(BigInteger.ONE))).divide(BigInteger.valueOf(2));
    }

    //  Used for testing
    @SuppressWarnings("unused")
    private static long sumMultiples(long max, long n1, long n2) {
        return sumMultiple(max, n1) + sumMultiple(max, n2) - sumMultiple(max, n1 * n2);
    }

    private static long sumMultiple(long max, long n) {
        long sum = 0;
        for ( int i = 1 ; i <= max ; i++ ) {
            if ( i % n == 0 ) {
                sum += i;
            }
        }
        return sum;
    }

}
