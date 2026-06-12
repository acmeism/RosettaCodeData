import java.math.BigInteger;

public class MersennePrimes {
    private static final int MAX = 20;

    private static final BigInteger ONE = BigInteger.ONE;
    private static final BigInteger TWO = BigInteger.valueOf(2);

    private static boolean isPrime(int n) {
        if (n < 2) return false;
        if (n % 2 == 0) return n == 2;
        if (n % 3 == 0) return n == 3;
        int d = 5;
        while (d * d <= n) {
            if (n % d == 0) return false;
            d += 2;
            if (n % d == 0) return false;
            d += 4;
        }
        return true;
    }

    public static void main(String[] args) {
        int count = 0;
        int p = 2;
        while (true) {
            BigInteger m = TWO.shiftLeft(p - 1).subtract(ONE);
            if (m.isProbablePrime(10)) {
                System.out.printf("2 ^ %d - 1\n", p);
                if (++count == MAX) break;
            }
            // obtain next prime, p
            do {
                p = (p > 2) ? p + 2 : 3;
            } while (!isPrime(p));
        }
    }
}
