import java.util.*;

public class ErdosPrimes {
    public static void main(String[] args) {
        boolean[] sieve = primeSieve(1000000);
        int maxPrint = 2500;
        int maxCount = 7875;
        System.out.printf("Erd\u0151s primes less than %d:\n", maxPrint);
        for (int count = 0, prime = 1; count < maxCount; ++prime) {
            if (erdos(sieve, prime)) {
                ++count;
                if (prime < maxPrint) {
                    System.out.printf("%6d", prime);
                    if (count % 10 == 0)
                        System.out.println();
                }
                if (count == maxCount)
                    System.out.printf("\n\nThe %dth Erd\u0151s prime is %d.\n", maxCount, prime);
            }
        }
    }

    private static boolean erdos(boolean[] sieve, int p) {
        if (!sieve[p])
            return false;
        for (int k = 1, f = 1; f < p; ++k, f *= k) {
            if (sieve[p - f])
                return false;
        }
        return true;
    }

    private static boolean[] primeSieve(int limit) {
        boolean[] sieve = new boolean[limit];
        Arrays.fill(sieve, true);
        if (limit > 0)
            sieve[0] = false;
        if (limit > 1)
            sieve[1] = false;
        for (int i = 4; i < limit; i += 2)
            sieve[i] = false;
        for (int p = 3; ; p += 2) {
            int q = p * p;
            if (q >= limit)
                break;
            if (sieve[p]) {
                int inc = 2 * p;
                for (; q < limit; q += inc)
                    sieve[q] = false;
            }
        }
        return sieve;
    }
}
