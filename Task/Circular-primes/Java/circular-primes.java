import java.math.BigInteger;
import java.util.Arrays;

public class CircularPrimes {
    public static void main(String[] args) {
        System.out.println("First 19 circular primes:");
        int p = 2;
        for (int count = 0; count < 19; ++p) {
            if (isCircularPrime(p)) {
                if (count > 0)
                    System.out.print(", ");
                System.out.print(p);
                ++count;
            }
        }
        System.out.println();
        System.out.println("Next 4 circular primes:");
        int repunit = 1, digits = 1;
        for (; repunit < p; ++digits)
            repunit = 10 * repunit + 1;
        BigInteger bignum = BigInteger.valueOf(repunit);
        for (int count = 0; count < 4; ) {
            if (bignum.isProbablePrime(15)) {
                if (count > 0)
                    System.out.print(", ");
                System.out.printf("R(%d)", digits);
                ++count;
            }
            ++digits;
            bignum = bignum.multiply(BigInteger.TEN);
            bignum = bignum.add(BigInteger.ONE);
        }
        System.out.println();
        testRepunit(5003);
        testRepunit(9887);
        testRepunit(15073);
        testRepunit(25031);
    }

    private static boolean isPrime(int n) {
        if (n < 2)
            return false;
        if (n % 2 == 0)
            return n == 2;
        if (n % 3 == 0)
            return n == 3;
        for (int p = 5; p * p <= n; p += 4) {
            if (n % p == 0)
                return false;
            p += 2;
            if (n % p == 0)
                return false;
        }
        return true;
    }

    private static int cycle(int n) {
        int m = n, p = 1;
        while (m >= 10) {
            p *= 10;
            m /= 10;
        }
        return m + 10 * (n % p);
    }

    private static boolean isCircularPrime(int p) {
        if (!isPrime(p))
            return false;
        int p2 = cycle(p);
        while (p2 != p) {
            if (p2 < p || !isPrime(p2))
                return false;
            p2 = cycle(p2);
        }
        return true;
    }

    private static void testRepunit(int digits) {
        BigInteger repunit = repunit(digits);
        if (repunit.isProbablePrime(15))
            System.out.printf("R(%d) is probably prime.\n", digits);
        else
            System.out.printf("R(%d) is not prime.\n", digits);
    }

    private static BigInteger repunit(int digits) {
        char[] ch = new char[digits];
        Arrays.fill(ch, '1');
        return new BigInteger(new String(ch));
    }
}
