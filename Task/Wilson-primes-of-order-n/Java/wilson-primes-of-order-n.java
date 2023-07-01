import java.math.BigInteger;
import java.util.*;

public class WilsonPrimes {
    public static void main(String[] args) {
        final int limit = 11000;
        BigInteger[] f = new BigInteger[limit];
        f[0] = BigInteger.ONE;
        BigInteger factorial = BigInteger.ONE;
        for (int i = 1; i < limit; ++i) {
            factorial = factorial.multiply(BigInteger.valueOf(i));
            f[i] = factorial;
        }
        List<Integer> primes = generatePrimes(limit);
        System.out.printf(" n | Wilson primes\n--------------------\n");
        BigInteger s = BigInteger.valueOf(-1);
        for (int n = 1; n <= 11; ++n) {
            System.out.printf("%2d |", n);
            for (int p : primes) {
                if (p >= n && f[n - 1].multiply(f[p - n]).subtract(s)
                        .mod(BigInteger.valueOf(p * p))
                        .equals(BigInteger.ZERO))
                    System.out.printf(" %d", p);
            }
            s = s.negate();
            System.out.println();
        }
    }

    private static List<Integer> generatePrimes(int limit) {
        boolean[] sieve = new boolean[limit >> 1];
        Arrays.fill(sieve, true);
        for (int p = 3, s = 9; s < limit; p += 2) {
            if (sieve[p >> 1]) {
                for (int q = s; q < limit; q += p << 1)
                    sieve[q >> 1] = false;
            }
            s += (p + 1) << 2;
        }
        List<Integer> primes = new ArrayList<>();
        if (limit > 2)
            primes.add(2);
        for (int i = 1; i < sieve.length; ++i) {
            if (sieve[i])
                primes.add((i << 1) + 1);
        }
        return primes;
    }
}
